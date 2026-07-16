#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import hashlib
import json
import os
import plistlib
import shutil
import sqlite3
import sys
import tempfile
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any, Iterable


SQLITE_HEADER = b"SQLite format 3\x00"

SIDECAR_SUFFIXES = (
    "-wal",
    "-shm",
    "-journal",
)

SKIP_DIRECTORY_NAMES = {
    ".Spotlight-V100",
    ".Trashes",
    ".fseventsd",
    ".DocumentRevisions-V100",
}

TCC_SERVICE_NAMES = {
    "kTCCServiceAddressBook": "Contacts",
    "kTCCServiceAppleEvents": "Automation / Apple Events",
    "kTCCServiceBluetoothAlways": "Bluetooth",
    "kTCCServiceCalendar": "Calendar",
    "kTCCServiceCamera": "Camera",
    "kTCCServiceDeveloperTool": "Developer Tools",
    "kTCCServiceFileProviderDomain": "File Provider",
    "kTCCServiceListenEvent": "Input Monitoring",
    "kTCCServiceLiverpool": "Location Services",
    "kTCCServiceMediaLibrary": "Media Library",
    "kTCCServiceMicrophone": "Microphone",
    "kTCCServiceMotion": "Motion and Fitness",
    "kTCCServicePhotos": "Photos",
    "kTCCServicePhotosAdd": "Add Photos Only",
    "kTCCServicePostEvent": "Accessibility",
    "kTCCServiceReminders": "Reminders",
    "kTCCServiceScreenCapture": "Screen Recording",
    "kTCCServiceSystemPolicyAllFiles": "Full Disk Access",
    "kTCCServiceSystemPolicyDesktopFolder": "Desktop Folder",
    "kTCCServiceSystemPolicyDocumentsFolder": "Documents Folder",
    "kTCCServiceSystemPolicyDownloadsFolder": "Downloads Folder",
    "kTCCServiceSystemPolicyNetworkVolumes": "Network Volumes",
    "kTCCServiceSystemPolicyRemovableVolumes": "Removable Volumes",
    "kTCCServiceSystemPolicySysAdminFiles": "System Administration Files",
}

TCC_AUTH_VALUES = {
    0: "Denied",
    1: "Unknown / Restricted",
    2: "Allowed",
    3: "Limited",
}

TCC_AUTH_REASONS = {
    0: "Error",
    1: "User Consent",
    2: "User Consent",
    3: "User Set",
    4: "System Set",
    5: "Service Policy",
    6: "MDM Policy",
    7: "Override Policy",
    8: "Missing Usage String",
    9: "Prompt Timeout",
    10: "Preflight Unknown",
    11: "Entitled",
    12: "App Type Policy",
}

TCC_CLIENT_TYPES = {
    0: "Bundle ID",
    1: "Absolute Path",
}


def log(message: str) -> None:
    """Print a status message immediately."""

    print(message, flush=True)


def sanitize_filename(value: str, maximum_length: int = 150) -> str:
    """
    Convert a path or table name into a filesystem-safe name.
    """

    safe = []

    for character in value:
        if character.isalnum() or character in ("-", "_", "."):
            safe.append(character)
        else:
            safe.append("_")

    result = "".join(safe).strip("._")

    while "__" in result:
        result = result.replace("__", "_")

    if not result:
        result = "unnamed"

    return result[:maximum_length]


def quote_identifier(identifier: str) -> str:
    """
    Safely quote an SQLite table or column identifier.
    """

    return '"' + identifier.replace('"', '""') + '"'


def is_sidecar_file(path: Path) -> bool:
    """
    Determine whether a file is an SQLite sidecar rather than a primary DB.
    """

    lower_name = path.name.lower()
    return any(lower_name.endswith(suffix) for suffix in SIDECAR_SUFFIXES)


def has_sqlite_header(path: Path) -> bool:
    """
    Determine whether a file starts with the SQLite file signature.
    """

    try:
        if not path.is_file() or path.stat().st_size < len(SQLITE_HEADER):
            return False

        with path.open("rb") as handle:
            return handle.read(len(SQLITE_HEADER)) == SQLITE_HEADER

    except (OSError, PermissionError):
        return False


def discover_sqlite_databases(root: Path) -> list[Path]:
    """
    Recursively locate primary SQLite databases by inspecting file headers.
    """

    databases: list[Path] = []

    for current_root, directory_names, file_names in os.walk(
        root,
        followlinks=False,
    ):
        directory_names[:] = [
            name
            for name in directory_names
            if name not in SKIP_DIRECTORY_NAMES
        ]

        current_path = Path(current_root)

        for file_name in file_names:
            candidate = current_path / file_name

            if is_sidecar_file(candidate):
                continue

            if has_sqlite_header(candidate):
                databases.append(candidate)

    return sorted(databases, key=lambda item: str(item).lower())


def make_database_output_name(database: Path, evidence_root: Path) -> str:
    """
    Create a unique output-directory name based on the database's relative path.
    """

    try:
        relative_path = database.relative_to(evidence_root)
    except ValueError:
        relative_path = database

    relative_text = str(relative_path)
    digest = hashlib.sha256(relative_text.encode("utf-8")).hexdigest()[:10]
    safe_path = sanitize_filename(relative_text)

    return f"{safe_path}_{digest}"


def copy_database_with_sidecars(
    database: Path,
    working_directory: Path,
) -> Path:
    """
    Copy a SQLite database and any adjacent WAL/SHM files to a temporary folder.

    Copying the files avoids writing to mounted evidence and allows SQLite to
    process valid WAL contents from the working copy.
    """

    copied_database = working_directory / database.name
    shutil.copy2(database, copied_database)

    for suffix in ("-wal", "-shm", "-journal"):
        source_sidecar = Path(str(database) + suffix)

        if source_sidecar.exists() and source_sidecar.is_file():
            destination_sidecar = Path(str(copied_database) + suffix)
            shutil.copy2(source_sidecar, destination_sidecar)

    return copied_database


def sqlite_connect(database: Path) -> sqlite3.Connection:
    """
    Open a copied SQLite database.

    The copy exists in a disposable temporary directory, so SQLite may safely
    process WAL contents without touching the original evidence.
    """

    connection = sqlite3.connect(
        str(database),
        timeout=30,
    )

    connection.text_factory = lambda data: data.decode(
        "utf-8",
        errors="replace",
    )

    return connection


def list_tables(connection: sqlite3.Connection) -> list[str]:
    """
    Return all non-internal tables in an SQLite database.
    """

    cursor = connection.execute(
        """
        SELECT name
        FROM sqlite_master
        WHERE type = 'table'
          AND name NOT LIKE 'sqlite_%'
        ORDER BY name COLLATE NOCASE
        """
    )

    return [str(row[0]) for row in cursor.fetchall()]


def get_table_columns(
    connection: sqlite3.Connection,
    table_name: str,
) -> list[dict[str, Any]]:
    """
    Return column metadata for a table.
    """

    quoted_table = quote_identifier(table_name)

    cursor = connection.execute(
        f"PRAGMA table_info({quoted_table})"
    )

    columns = []

    for row in cursor.fetchall():
        columns.append(
            {
                "column_id": row[0],
                "column_name": row[1],
                "declared_type": row[2],
                "not_null": row[3],
                "default_value": row[4],
                "primary_key": row[5],
            }
        )

    return columns


def get_table_row_count(
    connection: sqlite3.Connection,
    table_name: str,
) -> int:
    """
    Count rows in an SQLite table.
    """

    quoted_table = quote_identifier(table_name)
    cursor = connection.execute(f"SELECT COUNT(*) FROM {quoted_table}")

    row = cursor.fetchone()
    return int(row[0]) if row else 0


def convert_value_for_csv(value: Any) -> Any:
    """
    Convert SQLite values into safe CSV representations.

    BLOB values are prefixed with 'hex:' to make their encoding explicit.
    """

    if value is None:
        return ""

    if isinstance(value, memoryview):
        value = value.tobytes()

    if isinstance(value, (bytes, bytearray)):
        return "hex:" + bytes(value).hex()

    if isinstance(value, (str, int, float)):
        return value

    return str(value)


def export_table(
    connection: sqlite3.Connection,
    table_name: str,
    output_directory: Path,
) -> tuple[Path, int]:
    """
    Export all rows from a single SQLite table to CSV.
    """

    output_directory.mkdir(parents=True, exist_ok=True)

    output_name = sanitize_filename(table_name) + ".csv"
    output_path = output_directory / output_name

    quoted_table = quote_identifier(table_name)
    cursor = connection.execute(f"SELECT * FROM {quoted_table}")

    column_names = [
        description[0]
        for description in cursor.description or []
    ]

    row_count = 0

    with output_path.open(
        "w",
        newline="",
        encoding="utf-8-sig",
        errors="replace",
    ) as csv_file:
        writer = csv.writer(csv_file)
        writer.writerow(column_names)

        while True:
            rows = cursor.fetchmany(1000)

            if not rows:
                break

            for row in rows:
                writer.writerow(
                    [convert_value_for_csv(value) for value in row]
                )
                row_count += 1

    return output_path, row_count


def export_schema(
    connection: sqlite3.Connection,
    tables: Iterable[str],
    output_directory: Path,
) -> Path:
    """
    Export table and column metadata to schema.csv.
    """

    output_path = output_directory / "schema.csv"

    with output_path.open(
        "w",
        newline="",
        encoding="utf-8-sig",
    ) as csv_file:
        writer = csv.DictWriter(
            csv_file,
            fieldnames=[
                "table_name",
                "column_id",
                "column_name",
                "declared_type",
                "not_null",
                "default_value",
                "primary_key",
            ],
        )

        writer.writeheader()

        for table_name in tables:
            for column in get_table_columns(connection, table_name):
                writer.writerow(
                    {
                        "table_name": table_name,
                        **column,
                    }
                )

    return output_path


def export_sqlite_master(
    connection: sqlite3.Connection,
    output_directory: Path,
) -> Path:
    """
    Export SQLite object definitions, including table and index SQL.
    """

    output_path = output_directory / "sqlite_master.csv"

    cursor = connection.execute(
        """
        SELECT
            type,
            name,
            tbl_name,
            rootpage,
            sql
        FROM sqlite_master
        ORDER BY type, name
        """
    )

    with output_path.open(
        "w",
        newline="",
        encoding="utf-8-sig",
    ) as csv_file:
        writer = csv.writer(csv_file)
        writer.writerow(
            [
                "type",
                "name",
                "table_name",
                "root_page",
                "sql",
            ]
        )

        for row in cursor:
            writer.writerow(
                [convert_value_for_csv(value) for value in row]
            )

    return output_path


def normalize_column_map(
    connection: sqlite3.Connection,
    table_name: str,
) -> dict[str, str]:
    """
    Map lowercase column names to their actual SQLite names.
    """

    return {
        str(column["column_name"]).lower(): str(column["column_name"])
        for column in get_table_columns(connection, table_name)
    }


def parse_integer(value: Any) -> int | None:
    """
    Convert a value into an integer when possible.
    """

    if value is None or value == "":
        return None

    try:
        return int(value)
    except (TypeError, ValueError):
        return None


def format_unix_timestamp(value: Any) -> str:
    """
    Convert Unix seconds to UTC ISO-8601.
    """

    numeric_value = parse_integer(value)

    if numeric_value is None:
        return ""

    try:
        return datetime.fromtimestamp(
            numeric_value,
            tz=timezone.utc,
        ).isoformat()
    except (OverflowError, OSError, ValueError):
        return ""


def parse_tcc_permissions(
    connection: sqlite3.Connection,
    database: Path,
    output_directory: Path,
) -> Path | None:
    """
    Generate a human-readable permissions CSV for TCC databases.
    """

    tables = list_tables(connection)

    if "access" not in tables:
        return None

    column_map = normalize_column_map(connection, "access")

    required_columns = {"service", "client"}

    if not required_columns.issubset(column_map):
        return None

    selected_columns = [
        column_map["service"],
        column_map["client"],
    ]

    optional_names = [
        "client_type",
        "auth_value",
        "allowed",
        "auth_reason",
        "auth_version",
        "prompt_count",
        "last_modified",
        "flags",
        "policy_id",
        "indirect_object_identifier_type",
        "indirect_object_identifier",
    ]

    for optional_name in optional_names:
        if optional_name in column_map:
            selected_columns.append(column_map[optional_name])

    quoted_columns = ", ".join(
        quote_identifier(column)
        for column in selected_columns
    )

    cursor = connection.execute(
        f"""
        SELECT {quoted_columns}
        FROM {quote_identifier("access")}
        """
    )

    output_path = output_directory / "permissions_decoded.csv"

    with output_path.open(
        "w",
        newline="",
        encoding="utf-8-sig",
    ) as csv_file:
        fieldnames = [
            "database_path",
            "service",
            "permission",
            "client",
            "client_type",
            "authorization_value",
            "authorization_status",
            "authorization_reason_value",
            "authorization_reason",
            "last_modified_raw",
            "last_modified_utc",
            "raw_record_json",
        ]

        writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
        writer.writeheader()

        for row in cursor:
            record = dict(zip(selected_columns, row))

            service = record.get(column_map["service"])
            client = record.get(column_map["client"])

            client_type_value = None
            if "client_type" in column_map:
                client_type_value = parse_integer(
                    record.get(column_map["client_type"])
                )

            if "auth_value" in column_map:
                auth_value = parse_integer(
                    record.get(column_map["auth_value"])
                )
            elif "allowed" in column_map:
                auth_value = parse_integer(
                    record.get(column_map["allowed"])
                )
            else:
                auth_value = None

            auth_reason = None
            if "auth_reason" in column_map:
                auth_reason = parse_integer(
                    record.get(column_map["auth_reason"])
                )

            last_modified = None
            if "last_modified" in column_map:
                last_modified = record.get(
                    column_map["last_modified"]
                )

            serializable_record = {
                key: convert_value_for_csv(value)
                for key, value in record.items()
            }

            writer.writerow(
                {
                    "database_path": str(database),
                    "service": service or "",
                    "permission": TCC_SERVICE_NAMES.get(
                        str(service),
                        str(service or ""),
                    ),
                    "client": client or "",
                    "client_type": TCC_CLIENT_TYPES.get(
                        client_type_value,
                        str(client_type_value)
                        if client_type_value is not None
                        else "",
                    ),
                    "authorization_value": (
                        auth_value
                        if auth_value is not None
                        else ""
                    ),
                    "authorization_status": TCC_AUTH_VALUES.get(
                        auth_value,
                        str(auth_value)
                        if auth_value is not None
                        else "Unknown",
                    ),
                    "authorization_reason_value": (
                        auth_reason
                        if auth_reason is not None
                        else ""
                    ),
                    "authorization_reason": TCC_AUTH_REASONS.get(
                        auth_reason,
                        str(auth_reason)
                        if auth_reason is not None
                        else "",
                    ),
                    "last_modified_raw": (
                        last_modified
                        if last_modified is not None
                        else ""
                    ),
                    "last_modified_utc": format_unix_timestamp(
                        last_modified
                    ),
                    "raw_record_json": json.dumps(
                        serializable_record,
                        ensure_ascii=False,
                    ),
                }
            )

    return output_path


def recursively_find_values(
    value: Any,
    target_keys: set[str],
    found: dict[str, list[str]],
) -> None:
    """
    Search a decoded plist recursively for common notification fields.
    """

    if isinstance(value, dict):
        for key, item in value.items():
            normalized_key = str(key).lower()

            if normalized_key in target_keys:
                if isinstance(item, (str, int, float, bool)):
                    found.setdefault(normalized_key, []).append(str(item))

            recursively_find_values(item, target_keys, found)

    elif isinstance(value, (list, tuple)):
        for item in value:
            recursively_find_values(item, target_keys, found)


def decode_plist_blob(blob: Any) -> tuple[Any | None, str]:
    """
    Attempt to decode a SQLite BLOB as an Apple property list.
    """

    if blob is None:
        return None, "empty"

    if isinstance(blob, memoryview):
        blob = blob.tobytes()

    if not isinstance(blob, (bytes, bytearray)):
        return None, "not-a-blob"

    raw_bytes = bytes(blob)

    try:
        return plistlib.loads(raw_bytes), "plist"
    except Exception as error:
        return None, f"decode-error: {error}"


def apple_absolute_time_to_utc(value: Any) -> str:
    """
    Convert Apple absolute time, measured from 2001-01-01 UTC, to ISO-8601.
    """

    try:
        numeric_value = float(value)
    except (TypeError, ValueError):
        return ""

    try:
        apple_epoch = datetime(
            2001,
            1,
            1,
            tzinfo=timezone.utc,
        )

        return (
            apple_epoch + timedelta(seconds=numeric_value)
        ).isoformat()

    except (OverflowError, ValueError):
        return ""


def identify_notification_tables(
    connection: sqlite3.Connection,
) -> list[tuple[str, str]]:
    """
    Find tables and columns containing likely notification plist BLOBs.
    """

    findings: list[tuple[str, str]] = []

    candidate_column_names = {
        "data",
        "request",
        "content",
        "payload",
        "category",
        "categories",
    }

    for table_name in list_tables(connection):
        column_map = normalize_column_map(connection, table_name)

        for lowercase_name, actual_name in column_map.items():
            if lowercase_name in candidate_column_names:
                findings.append((table_name, actual_name))

    return findings


def parse_notifications(
    connection: sqlite3.Connection,
    database: Path,
    output_directory: Path,
) -> Path | None:
    """
    Decode plist BLOBs in likely usernoted notification tables.

    This parser is intentionally schema-tolerant. It does not assume that all
    macOS versions use identical notification tables.
    """

    database_path_lower = str(database).lower()
    tables = list_tables(connection)

    looks_like_usernoted = (
        "usernoted" in database_path_lower
        or {
            "app",
            "delivered",
            "displayed",
            "categories",
        }.issubset(set(tables))
    )

    if not looks_like_usernoted:
        return None

    candidates = identify_notification_tables(connection)

    if not candidates:
        return None

    output_path = output_directory / "notifications_decoded.csv"

    target_keys = {
        "title",
        "subtitle",
        "body",
        "message",
        "text",
        "informativetext",
        "nsinformativetext",
        "nstitle",
        "nssubtitle",
        "sender",
        "threadidentifier",
        "thread-id",
        "categoryidentifier",
        "identifier",
    }

    with output_path.open(
        "w",
        newline="",
        encoding="utf-8-sig",
    ) as csv_file:
        fieldnames = [
            "database_path",
            "source_table",
            "source_column",
            "sqlite_rowid",
            "decoded_type",
            "title",
            "subtitle",
            "body",
            "sender",
            "thread_identifier",
            "category_identifier",
            "decoded_plist_json",
            "raw_blob_hex",
            "decode_status",
        ]

        writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
        writer.writeheader()

        decoded_count = 0

        for table_name, blob_column in candidates:
            quoted_table = quote_identifier(table_name)
            quoted_blob_column = quote_identifier(blob_column)

            try:
                cursor = connection.execute(
                    f"""
                    SELECT rowid, {quoted_blob_column}
                    FROM {quoted_table}
                    """
                )
            except sqlite3.DatabaseError:
                continue

            for row_id, blob in cursor:
                decoded_plist, status = decode_plist_blob(blob)

                if decoded_plist is None:
                    continue

                found: dict[str, list[str]] = {}
                recursively_find_values(
                    decoded_plist,
                    target_keys,
                    found,
                )

                def first_value(*names: str) -> str:
                    for name in names:
                        values = found.get(name.lower())

                        if values:
                            return values[0]

                    return ""

                try:
                    decoded_json = json.dumps(
                        decoded_plist,
                        default=convert_value_for_csv,
                        ensure_ascii=False,
                    )
                except (TypeError, ValueError):
                    decoded_json = repr(decoded_plist)

                raw_hex = ""

                if isinstance(blob, memoryview):
                    blob = blob.tobytes()

                if isinstance(blob, (bytes, bytearray)):
                    raw_hex = bytes(blob).hex()

                writer.writerow(
                    {
                        "database_path": str(database),
                        "source_table": table_name,
                        "source_column": blob_column,
                        "sqlite_rowid": row_id,
                        "decoded_type": type(decoded_plist).__name__,
                        "title": first_value(
                            "title",
                            "nstitle",
                        ),
                        "subtitle": first_value(
                            "subtitle",
                            "nssubtitle",
                        ),
                        "body": first_value(
                            "body",
                            "message",
                            "informativetext",
                            "nsinformativetext",
                            "text",
                        ),
                        "sender": first_value("sender"),
                        "thread_identifier": first_value(
                            "threadidentifier",
                            "thread-id",
                        ),
                        "category_identifier": first_value(
                            "categoryidentifier",
                        ),
                        "decoded_plist_json": decoded_json,
                        "raw_blob_hex": raw_hex,
                        "decode_status": status,
                    }
                )

                decoded_count += 1

    if decoded_count == 0:
        output_path.unlink(missing_ok=True)
        return None

    return output_path


def run_integrity_check(
    connection: sqlite3.Connection,
) -> str:
    """
    Run SQLite's quick integrity check against the working copy.
    """

    try:
        cursor = connection.execute("PRAGMA quick_check")
        rows = cursor.fetchall()
        return "; ".join(str(row[0]) for row in rows)
    except sqlite3.DatabaseError as error:
        return f"Error: {error}"


def process_database(
    database: Path,
    evidence_root: Path,
    output_root: Path,
) -> dict[str, Any]:
    """
    Export one database and return an inventory record.
    """

    relative_path = str(database)

    try:
        relative_path = str(database.relative_to(evidence_root))
    except ValueError:
        pass

    output_name = make_database_output_name(
        database,
        evidence_root,
    )

    database_output_directory = output_root / output_name
    database_output_directory.mkdir(parents=True, exist_ok=True)

    inventory_record: dict[str, Any] = {
        "database_name": database.name,
        "relative_path": relative_path,
        "absolute_path": str(database),
        "size_bytes": "",
        "wal_present": Path(str(database) + "-wal").exists(),
        "shm_present": Path(str(database) + "-shm").exists(),
        "table_count": 0,
        "tables": "",
        "total_rows": 0,
        "integrity_check": "",
        "output_directory": str(database_output_directory),
        "status": "Pending",
        "error": "",
    }

    try:
        inventory_record["size_bytes"] = database.stat().st_size
    except OSError:
        pass

    try:
        with tempfile.TemporaryDirectory(
            prefix="mac_sqlite_"
        ) as temporary_directory:
            temporary_path = Path(temporary_directory)

            working_database = copy_database_with_sidecars(
                database,
                temporary_path,
            )

            connection = sqlite_connect(working_database)

            try:
                integrity_result = run_integrity_check(connection)
                inventory_record["integrity_check"] = integrity_result

                tables = list_tables(connection)
                inventory_record["table_count"] = len(tables)
                inventory_record["tables"] = "; ".join(tables)

                export_schema(
                    connection,
                    tables,
                    database_output_directory,
                )

                export_sqlite_master(
                    connection,
                    database_output_directory,
                )

                total_rows = 0

                for table_name in tables:
                    try:
                        output_path, row_count = export_table(
                            connection,
                            table_name,
                            database_output_directory,
                        )

                        total_rows += row_count

                        log(
                            f"        {table_name}: "
                            f"{row_count} rows -> {output_path.name}"
                        )

                    except sqlite3.DatabaseError as error:
                        log(
                            f"        [!] Failed to export table "
                            f"{table_name}: {error}"
                        )

                inventory_record["total_rows"] = total_rows

                tcc_report = parse_tcc_permissions(
                    connection,
                    database,
                    database_output_directory,
                )

                if tcc_report:
                    log(
                        f"        [+] TCC report: {tcc_report.name}"
                    )

                notification_report = parse_notifications(
                    connection,
                    database,
                    database_output_directory,
                )

                if notification_report:
                    log(
                        "        [+] Notification report: "
                        f"{notification_report.name}"
                    )

                inventory_record["status"] = "Exported"

            finally:
                connection.close()

    except (
        OSError,
        PermissionError,
        sqlite3.DatabaseError,
        shutil.Error,
    ) as error:
        inventory_record["status"] = "Failed"
        inventory_record["error"] = str(error)

        log(f"    [!] Failed: {error}")

    return inventory_record


def write_inventory(
    records: list[dict[str, Any]],
    output_root: Path,
) -> Path:
    """
    Write the global database inventory.
    """

    output_path = output_root / "database_inventory.csv"

    fieldnames = [
        "database_name",
        "relative_path",
        "absolute_path",
        "size_bytes",
        "wal_present",
        "shm_present",
        "table_count",
        "tables",
        "total_rows",
        "integrity_check",
        "output_directory",
        "status",
        "error",
    ]

    with output_path.open(
        "w",
        newline="",
        encoding="utf-8-sig",
    ) as csv_file:
        writer = csv.DictWriter(
            csv_file,
            fieldnames=fieldnames,
        )

        writer.writeheader()
        writer.writerows(records)

    return output_path


def parse_arguments() -> argparse.Namespace:
    """
    Parse command-line options.
    """

    parser = argparse.ArgumentParser(
        description=(
            "Recursively locate SQLite databases in a mounted macOS "
            "filesystem and export every table to CSV."
        )
    )

    parser.add_argument(
        "evidence_path",
        help=(
            "Root of the mounted macOS filesystem, such as "
            "/mnt/mac/root"
        ),
    )

    parser.add_argument(
        "-o",
        "--output",
        default="mac_sqlite_output",
        help=(
            "Output directory. Default: mac_sqlite_output"
        ),
    )

    return parser.parse_args()


def main() -> int:
    """
    Main program entry point.
    """

    args = parse_arguments()

    evidence_root = Path(
        os.path.abspath(
            os.path.expanduser(args.evidence_path)
        )
    )

    output_root = Path(
        os.path.abspath(
            os.path.expanduser(args.output)
        )
    )

    if not evidence_root.exists():
        print(
            f"[!] Evidence path does not exist: {evidence_root}",
            file=sys.stderr,
        )
        return 1

    if not evidence_root.is_dir():
        print(
            f"[!] Evidence path is not a directory: {evidence_root}",
            file=sys.stderr,
        )
        return 1

    output_root.mkdir(parents=True, exist_ok=True)

    log(f"[+] Evidence root: {evidence_root}")
    log(f"[+] Output root:   {output_root}")
    log("[+] Searching for SQLite databases...")

    databases = discover_sqlite_databases(evidence_root)

    if not databases:
        log("[!] No SQLite databases were found.")
        return 2

    log(f"[+] Found {len(databases)} SQLite databases.\n")

    inventory_records: list[dict[str, Any]] = []

    for index, database in enumerate(databases, start=1):
        log(
            f"[{index}/{len(databases)}] Processing:\n"
            f"    {database}"
        )

        inventory_record = process_database(
            database,
            evidence_root,
            output_root,
        )

        inventory_records.append(inventory_record)
        log("")

    inventory_path = write_inventory(
        inventory_records,
        output_root,
    )

    exported_count = sum(
        1
        for record in inventory_records
        if record["status"] == "Exported"
    )

    failed_count = sum(
        1
        for record in inventory_records
        if record["status"] == "Failed"
    )

    log("=" * 72)
    log("[+] Processing complete")
    log(f"[+] Databases found:    {len(databases)}")
    log(f"[+] Databases exported: {exported_count}")
    log(f"[+] Databases failed:   {failed_count}")
    log(f"[+] Inventory:          {inventory_path}")
    log(f"[+] Output directory:   {output_root}")

    return 0 if failed_count == 0 else 3


if __name__ == "__main__":
    raise SystemExit(main())
