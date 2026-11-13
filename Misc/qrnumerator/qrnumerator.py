import cv2
import sys
import re
from pyzbar.pyzbar import decode
from urllib.parse import urlparse, parse_qs

def analyze_qr_data(data):
    result = {
        "raw_data": data,
        "type": "unknown",
        "parsed": {}
    }

    if data.startswith("http://") or data.startswith("https://"):
        result["type"] = "url"
        parsed_url = urlparse(data)
        result["parsed"] = {
            "scheme": parsed_url.scheme,
            "domain": parsed_url.netloc,
            "path": parsed_url.path,
            "query": parse_qs(parsed_url.query)
        }

    elif data.startswith("WIFI:"):
        result["type"] = "wifi"
        wifi_pattern = re.findall(r'(\w+):([^;]+)', data)
        result["parsed"] = {k: v for k, v in wifi_pattern}

    elif data.startswith("mailto:"):
        result["type"] = "email"
        result["parsed"] = {"email": data.replace("mailto:", "")}

    elif data.startswith("tel:"):
        result["type"] = "phone"
        result["parsed"] = {"number": data.replace("tel:", "")}

    result["indicators"] = []

    if "@" in data and not data.startswith("mailto:"):
        result["indicators"].append("Possible credential/data string")

    if re.search(r'(bit\.ly|tinyurl|t\.co)', data):
        result["indicators"].append("Shortened URL detected")

    if re.search(r'[\w\-]{20,}\.[\w\-]{20,}\.[\w\-]{20,}', data):
        result["indicators"].append("Possible token/JWT-like structure")

    return result

def scan_qr_from_image(image_path):
    image = cv2.imread(image_path)

    if image is None:
        print(f"[ERROR] Could not load image: {image_path}")
        return

    b, g, r = cv2.split(image)

    red_boost = cv2.subtract(r, g)

    norm = cv2.normalize(red_boost, None, 0, 255, cv2.NORM_MINMAX)

    _, thresh1 = cv2.threshold(norm, 100, 255, cv2.THRESH_BINARY)

    thresh2 = cv2.adaptiveThreshold(
        norm,
        255,
        cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
        cv2.THRESH_BINARY,
        11,
        2
    )

    inverted = cv2.bitwise_not(thresh1)

    attempts = [image, norm, thresh1, thresh2, inverted]

    decoded_objects = []

    for attempt in attempts:
        decoded_objects = decode(attempt)
        if decoded_objects:
            break

    if not decoded_objects:
        detector = cv2.QRCodeDetector()
        data, points, _ = detector.detectAndDecode(image)

        if data:
            print("\n=== QR Code (OpenCV) ===")
            analysis = analyze_qr_data(data)

            print(f"[RAW] {analysis['raw_data']}")
            print(f"[TYPE] {analysis['type']}")

            if analysis["parsed"]:
                print("[PARSED]")
                for k, v in analysis["parsed"].items():
                    print(f"  {k}: {v}")

            if analysis["indicators"]:
                print("[INDICATORS]")
                for ind in analysis["indicators"]:
                    print(f"  - {ind}")
            return

        print("[INFO] No QR codes found.")
        return

    for i, obj in enumerate(decoded_objects, 1):
        data = obj.data.decode("utf-8", errors="ignore")

        print(f"\n=== QR Code #{i} ===")
        analysis = analyze_qr_data(data)

        print(f"[RAW] {analysis['raw_data']}")
        print(f"[TYPE] {analysis['type']}")

        if analysis["parsed"]:
            print("[PARSED]")
            for k, v in analysis["parsed"].items():
                print(f"  {k}: {v}")

        if analysis["indicators"]:
            print("[INDICATORS]")
            for ind in analysis["indicators"]:
                print(f"  - {ind}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python qrnumerator.py <image_path>")
        sys.exit(1)

    image_path = sys.argv[1]
    scan_qr_from_image(image_path)
