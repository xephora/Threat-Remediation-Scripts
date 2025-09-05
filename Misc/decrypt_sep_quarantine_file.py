import sys

def decode_payload(file):
    print("[+] Bruteforcing Keys..")
    for key in range(0x100):
        decoded_bytes = bytearray((byte ^ key) % 256 for byte in file)
            # I added some typical file signatures I observed overtime.
            if decoded_bytes[:9] == b"<!DOCTYPE":
            filetype = "HTML Doc"
            filename = sys.argv[1] + "_decoded.html"
        elif decoded_bytes[:2] == b"MZ":
            filetype = "PE File"
            filename = sys.argv[1] + "_decoded.exe"
        elif decoded_bytes[:4] == b"%PDF":
            filetype = "PDF File"
            filename = sys.argv[1] + "_decoded.pdf"
        else:
            continue

        try:
            with open(filename, "wb") as f:
                f.write(decoded_bytes)
                print(f"[+] {filetype} -> {filename} written")
        except Exception as e:
            return f"[!] Failed to write file: {e}"

        return f"[+] Found {filetype} with key {hex(key)}"

    return "[!] Exhausted keys.."

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python decrypt_sep_quarantine_file.py <quarantine_file>")
        sys.exit(1)

    with open(sys.argv[1], "rb") as f:
        file = f.read()
    print(decode_payload(file))
