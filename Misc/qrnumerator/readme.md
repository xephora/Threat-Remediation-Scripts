## Quick and dirty QR Enumeration tool

### Installation

```
pip3 install -r requirements.txt

python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt
```

### Usage

```
python3 qrnumerator.py qrimage.png 

=== QR Code #1 ===
[RAW] https://example.com/JQwNMxLN
[TYPE] url
[PARSED]
  scheme: https
  domain: example.com
  path: /JQwNMxLN
  query: {}
```
