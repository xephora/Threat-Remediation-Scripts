#!/usr/bin/env python3

import argparse
import string
from pathlib import Path
from collections import defaultdict


DEFAULT_BLOCK_SIZE = 1024


def load_search_terms(search_arg):
    """
    Interpret the search argument as either:

      1. A wordlist file, if the supplied path exists.
      2. A single literal search keyword otherwise.

    Wordlists contain one search term per line.
    Blank lines and lines beginning with # are ignored.
    """

    candidate = Path(search_arg).expanduser()

    if candidate.is_file():

        print(f"[+] Search mode: wordlist")
        print(f"[+] Wordlist: {candidate.resolve()}")

        terms = []

        with candidate.open(
            "r",
            encoding="utf-8",
            errors="replace"
        ) as f:

            for line in f:

                line = line.strip()

                if not line:
                    continue

                if line.startswith("#"):
                    continue

                terms.append(line)

        if not terms:
            raise SystemExit(
                f"[-] Wordlist contains no search terms: "
                f"{candidate}"
            )

    else:

        print("[+] Search mode: single keyword")

        if not search_arg:
            raise SystemExit(
                "[-] Search keyword cannot be empty."
            )

        terms = [search_arg]

    # Deduplicate case-insensitively while
    # preserving original ordering.

    seen = set()
    unique_terms = []

    for term in terms:

        normalized = term.lower()

        if normalized not in seen:
            seen.add(normalized)
            unique_terms.append(term)

    return unique_terms


def extract_strings(data, minimum=4):
    """
    Extract printable ASCII strings and their
    absolute byte offsets from the journal.
    """

    results = []
    start = None

    for i, byte in enumerate(data):

        printable = (
            32 <= byte <= 126
            or byte == 9
        )

        if printable:

            if start is None:
                start = i

        else:

            if start is not None:

                if i - start >= minimum:

                    raw = data[start:i]

                    results.append(
                        (
                            start,
                            raw.decode(
                                "ascii",
                                errors="replace"
                            )
                        )
                    )

                start = None

    # Handle printable data extending to EOF.

    if start is not None:

        if len(data) - start >= minimum:

            results.append(
                (
                    start,
                    data[start:].decode(
                        "ascii",
                        errors="replace"
                    )
                )
            )

    return results


def hexdump(data, base_offset=0):
    """
    Produce an xxd-style hexadecimal + ASCII dump.
    """

    output = []

    for i in range(0, len(data), 16):

        chunk = data[i:i + 16]

        hex_part = " ".join(
            f"{b:02x}" for b in chunk
        )

        hex_part = f"{hex_part:<47}"

        ascii_part = "".join(
            chr(b)
            if 32 <= b <= 126
            else "."
            for b in chunk
        )

        output.append(
            f"{base_offset + i:08x}  "
            f"{hex_part}  "
            f"|{ascii_part}|"
        )

    return "\n".join(output)


def find_matches(strings_found, search_terms):
    """
    Search extracted strings for the requested terms.

    Matching is case-insensitive.
    """

    results = []

    for offset, text in strings_found:

        lower_text = text.lower()

        matched_terms = []

        for term in search_terms:

            if term.lower() in lower_text:
                matched_terms.append(term)

        if matched_terms:

            results.append(
                (
                    offset,
                    text,
                    matched_terms
                )
            )

    return results


def block_number(offset, block_size):
    """
    Return journal block containing the byte offset.
    """

    return offset // block_size


def block_offset(offset, block_size):
    """
    Return offset relative to the containing block.
    """

    return offset % block_size


def contextual_hits(
    data,
    hits,
    before=64,
    after=256
):
    """
    Produce a hexadecimal/ASCII context window
    around every search hit.
    """

    output = []

    for offset, text, matched_terms in hits:

        start = max(
            0,
            offset - before
        )

        end = min(
            len(data),
            offset + len(text) + after
        )

        output.append(
            "=" * 78
        )

        output.append(
            f"HIT @ {offset} / 0x{offset:x}"
        )

        output.append(
            f"Matched: {', '.join(matched_terms)}"
        )

        output.append(
            f"String: {text!r}"
        )

        output.append(
            "-" * 78
        )

        output.append(
            hexdump(
                data[start:end],
                start
            )
        )

        output.append("")

    return "\n".join(output)


def dump_matching_blocks(
    data,
    hits,
    block_size
):
    """
    Group hits by journal block and dump the entire
    block containing each match.
    """

    blocks = defaultdict(list)

    for offset, text, matched_terms in hits:

        block = block_number(
            offset,
            block_size
        )

        blocks[block].append(
            (
                offset,
                text,
                matched_terms
            )
        )

    output = []

    for block in sorted(blocks):

        start = block * block_size

        end = min(
            start + block_size,
            len(data)
        )

        output.append(
            "=" * 78
        )

        output.append(
            f"JOURNAL BLOCK {block}"
        )

        output.append(
            f"File offset: "
            f"{start} / 0x{start:x}"
        )

        output.append(
            "-" * 78
        )

        output.append(
            "Matches:"
        )

        for offset, text, matched_terms in blocks[block]:

            relative = offset - start

            output.append(
                f"  +0x{relative:03x} "
                f"(absolute {offset} / 0x{offset:x})"
            )

            output.append(
                f"      Matched: "
                f"{', '.join(matched_terms)}"
            )

            output.append(
                f"      String: {text!r}"
            )

        output.append("")
        output.append("HEX/ASCII:")
        output.append("")

        output.append(
            hexdump(
                data[start:end],
                start
            )
        )

        output.append("")

    return "\n".join(output)


def main():

    parser = argparse.ArgumentParser(
        description=(
            "Search an extracted EXT journal for a "
            "single keyword or a wordlist of keywords."
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:

  Single keyword:

    python3 parsejournal.py journal.bin "force-wait.sh"

  Keyword containing spaces:

    python3 parsejournal.py journal.bin "some search string"

  Wordlist:

    python3 parsejournal.py journal.bin keywords.txt

  Custom output directory:

    python3 parsejournal.py journal.bin keywords.txt -o results

Wordlist format:

    keyword1
    keyword2
    filename.txt
    another search term

Blank lines and lines beginning with # are ignored.
"""
    )

    parser.add_argument(
        "journal",
        help="Extracted EXT journal file"
    )

    parser.add_argument(
        "search",
        help=(
            "A single search keyword OR the path "
            "to a wordlist file"
        )
    )

    parser.add_argument(
        "-o",
        "--output",
        default=None,
        help="Output directory"
    )

    parser.add_argument(
        "--block-size",
        type=int,
        default=DEFAULT_BLOCK_SIZE,
        help=(
            "Journal/filesystem block size "
            f"(default: {DEFAULT_BLOCK_SIZE})"
        )
    )

    parser.add_argument(
        "--min-string",
        type=int,
        default=4,
        help=(
            "Minimum printable string length "
            "(default: 4)"
        )
    )

    parser.add_argument(
        "--before",
        type=int,
        default=64,
        help=(
            "Number of bytes shown before each "
            "match (default: 64)"
        )
    )

    parser.add_argument(
        "--after",
        type=int,
        default=256,
        help=(
            "Number of bytes shown after each "
            "match (default: 256)"
        )
    )

    args = parser.parse_args()

    # ---------------------------------------------------------
    # Validate journal
    # ---------------------------------------------------------

    journal = Path(
        args.journal
    ).expanduser().resolve()

    if not journal.exists():

        raise SystemExit(
            f"[-] Journal not found: {journal}"
        )

    if not journal.is_file():

        raise SystemExit(
            f"[-] Journal is not a regular file: "
            f"{journal}"
        )

    if args.block_size <= 0:

        raise SystemExit(
            "[-] --block-size must be greater than zero."
        )

    if args.min_string <= 0:

        raise SystemExit(
            "[-] --min-string must be greater than zero."
        )

    if args.before < 0 or args.after < 0:

        raise SystemExit(
            "[-] --before and --after cannot be negative."
        )

    # ---------------------------------------------------------
    # Determine single keyword vs wordlist
    # ---------------------------------------------------------

    search_terms = load_search_terms(
        args.search
    )

    print(
        f"[+] Search terms loaded: "
        f"{len(search_terms):,}"
    )

    for term in search_terms:
        print(f"    - {term}")

    # ---------------------------------------------------------
    # Output directory
    # ---------------------------------------------------------

    if args.output:

        output_dir = Path(
            args.output
        ).expanduser().resolve()

    else:

        output_dir = Path(
            f"{journal.stem}_parsed"
        ).resolve()

    output_dir.mkdir(
        parents=True,
        exist_ok=True
    )

    # ---------------------------------------------------------
    # Load journal
    # ---------------------------------------------------------

    print()
    print(f"[+] Journal: {journal}")

    data = journal.read_bytes()

    print(
        f"[+] Journal size: "
        f"{len(data):,} bytes"
    )

    print(
        f"[+] Block size: "
        f"{args.block_size:,} bytes"
    )

    # ---------------------------------------------------------
    # Extract strings
    # ---------------------------------------------------------

    print()
    print("[+] Extracting printable strings...")

    strings_found = extract_strings(
        data,
        args.min_string
    )

    print(
        f"[+] Printable strings: "
        f"{len(strings_found):,}"
    )

    # ---------------------------------------------------------
    # Search
    # ---------------------------------------------------------

    hits = find_matches(
        strings_found,
        search_terms
    )

    print(
        f"[+] Matching strings: "
        f"{len(hits):,}"
    )

    # ---------------------------------------------------------
    # Save all strings
    # ---------------------------------------------------------

    all_strings_file = (
        output_dir /
        "all_strings.txt"
    )

    with all_strings_file.open(
        "w",
        encoding="utf-8"
    ) as f:

        for offset, text in strings_found:

            block = block_number(
                offset,
                args.block_size
            )

            relative = block_offset(
                offset,
                args.block_size
            )

            f.write(
                f"{offset:10d} "
                f"0x{offset:08x} "
                f"block={block:<6d} "
                f"+0x{relative:03x} "
                f"{text}\n"
            )

    # ---------------------------------------------------------
    # Save matches
    # ---------------------------------------------------------

    matches_file = (
        output_dir /
        "matches.txt"
    )

    with matches_file.open(
        "w",
        encoding="utf-8"
    ) as f:

        for offset, text, matched_terms in hits:

            block = block_number(
                offset,
                args.block_size
            )

            relative = block_offset(
                offset,
                args.block_size
            )

            f.write(
                f"{offset:10d} "
                f"0x{offset:08x} "
                f"block={block:<6d} "
                f"+0x{relative:03x} "
                f"[{','.join(matched_terms)}] "
                f"{text}\n"
            )

    # ---------------------------------------------------------
    # Context around hits
    # ---------------------------------------------------------

    context_file = (
        output_dir /
        "match_context.txt"
    )

    context_file.write_text(
        contextual_hits(
            data,
            hits,
            before=args.before,
            after=args.after
        ),
        encoding="utf-8"
    )

    # ---------------------------------------------------------
    # Complete journal blocks containing hits
    # ---------------------------------------------------------

    blocks_file = (
        output_dir /
        "matching_blocks.txt"
    )

    blocks_file.write_text(
        dump_matching_blocks(
            data,
            hits,
            args.block_size
        ),
        encoding="utf-8"
    )

    # ---------------------------------------------------------
    # Save search terms
    # ---------------------------------------------------------

    terms_file = (
        output_dir /
        "search_terms.txt"
    )

    with terms_file.open(
        "w",
        encoding="utf-8"
    ) as f:

        for term in search_terms:
            f.write(term + "\n")

    # ---------------------------------------------------------
    # Console results
    # ---------------------------------------------------------

    if hits:

        print()
        print("=" * 78)
        print("MATCHES")
        print("=" * 78)

        for offset, text, matched_terms in hits:

            block = block_number(
                offset,
                args.block_size
            )

            relative = block_offset(
                offset,
                args.block_size
            )

            display = text

            if len(display) > 200:
                display = display[:197] + "..."

            print()

            print(
                f"[+] Offset: "
                f"{offset} / 0x{offset:x}"
            )

            print(
                f"    Block: {block}"
            )

            print(
                f"    Block offset: "
                f"+0x{relative:03x}"
            )

            print(
                f"    Matched: "
                f"{', '.join(matched_terms)}"
            )

            print(
                f"    String: {display}"
            )

    else:

        print()
        print("[-] No matching strings found.")

    # ---------------------------------------------------------
    # Report summary
    # ---------------------------------------------------------

    print()
    print("[+] Reports:")

    print(
        f"    {matches_file}"
    )

    print(
        f"    {context_file}"
    )

    print(
        f"    {blocks_file}"
    )

    print(
        f"    {all_strings_file}"
    )

    print(
        f"    {terms_file}"
    )


if __name__ == "__main__":
    main()
