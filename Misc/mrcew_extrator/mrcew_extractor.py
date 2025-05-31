import re
import sys
import argparse
import base64
import binascii
import jsbeautifier

def is_base64(s: str) -> bool:
    s_stripped = re.sub(r"\s+", "", s)
    padding_needed = (-len(s_stripped)) % 4
    if padding_needed:
        s_stripped += "=" * padding_needed

    if not re.fullmatch(r"[A-Za-z0-9+/]+={0,2}", s_stripped):
        return False

    try:
        base64.b64decode(s_stripped, validate=True)
    except (binascii.Error, ValueError):
        return False

    return True


def extract_all_payloads(file_path):
    try:
        with open(file_path, "r", encoding="utf-8", errors="replace") as f:
            html = f.read()
    except Exception as e:
        print(f"[!] Failed to open file: {e}", file=sys.stderr)
        return []

    blobs = re.findall(r"atob\(\s*'([A-Za-z0-9+/=\s]+)'\s*\)", html)
    if not blobs:
        print("[!] No atob('…') blobs discovered.", file=sys.stderr)
        return []

    results = []
    for blob in blobs:
        candidate = re.sub(r"\s+", "", blob)
        if not is_base64(candidate):
            continue

        padding_needed = (-len(candidate)) % 4
        padded = candidate + ("=" * padding_needed)
        try:
            decoded_bytes = base64.b64decode(padded)
            once_decoded = decoded_bytes.decode("utf-8", errors="replace")
        except Exception as e:
            print(f"[!] Error decoding blob: {e}", file=sys.stderr)
            continue

        results.append((candidate, once_decoded))

    if not results:
        print("[!] Found atob pattern, but none decoded successfully.", file=sys.stderr)
    return results


def peel_layers(once_decoded):
    data = once_decoded
    layers = 0

    while True:
        if not is_base64(data):
            break
        padding_needed = (-len(data)) % 4
        padded = data + ("=" * padding_needed)
        try:
            decoded_bytes = base64.b64decode(padded)
            data = decoded_bytes.decode("utf-8", errors="replace")
            layers += 1
        except Exception:
            break

    return data, layers


def format_data(content):
    return content.replace("\\x20", " ").replace("\\x0a", "\n").replace("\\x22", "\"").replace("\\x27", "'")

def prettify_payload(text: str) -> str:
    opts = jsbeautifier.default_options()
    opts.indent_size = 2
    opts.preserve_newlines = True
    opts.max_preserve_newlines = 2
    return jsbeautifier.beautify(text, opts)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="mrcew phishing document payload extraction tool"
    )
    parser.add_argument(
        "-f", help="phishing file (must end in .html)", required=True
    )
    args = parser.parse_args()

    if not args.f.endswith(".html"):
        print("[!] File does not end with .html. Please supply a .html file.", file=sys.stderr)
        sys.exit(1)

    all_blobs = extract_all_payloads(args.f)
    if not all_blobs:
        sys.exit(0)

    final_payloads = []
    for idx, (_orig, once_decoded) in enumerate(all_blobs, start=1):
        final_text, layers = peel_layers(once_decoded)
        if layers == 0:
            continue
        final_text = format_data(final_text)
        prettify_payload(final_text)
        final_payloads.append((idx, layers, final_text))

    if not final_payloads:
        print("[!] No fully decoded payloads to write.", file=sys.stderr)
        sys.exit(0)
    output_filename = "mrcew_payload_output.html"
    try:
        with open(output_filename, "w", encoding="utf-8") as f:
            for idx, layers, text in final_payloads:
                f.write(text)
                f.write("\n\n")
        print(f"[+] All payloads written to ./{output_filename}")
    except Exception as e:
        print(f"[!] Unable to write combined payload file: {e}", file=sys.stderr)
        sys.exit(1)
