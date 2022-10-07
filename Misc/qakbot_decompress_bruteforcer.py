import sys
import base64
from zipfile import ZipFile as zip

def variant1_decompression(html):
        f = open(f"{html}","rb")
        html_read = str(f.read())
        f.close()
        b64_blob = html_read.split("data = \"")[1].split("\";")[0]
        password = html_read.split("<p class=\"box\">")[1].split("</p>")[0].encode()
        stage1_decoded = str(base64.b64decode(b64_blob))
        stage2_decoded = base64.b64decode(stage1_decoded.split("content = \\\'")[1].split("\\\';")[0])
        if "504b03" in stage2_decoded.hex()[:6]:
                f = open("attachment.zip","wb")
                f.write(stage2_decoded)
                f.close()
                with zip("attachment.zip","r") as f:
                        f.extractall(pwd=password)
        else:
                print("[+] stage2 decode integrity check failed. No magic bytes 504b03 detected.")
                quit()

def variant2_decompression(html):
        f = open(f"{html}","rb")
        html_read = str(f.read())
        f.close()
        b64_blob = html_read.split("+ rev(\"")[1].split("\"));")[0]
        password = html_read.split("<p class=\"box\">")[1].split("</p>")[0].encode()
        stage1_decoded = str(base64.b64decode(b64_blob[::-1]))
        stage2_decoded = base64.b64decode(stage1_decoded.split("content = \\\'")[1].split("\\\';")[0])
        if "504b03" in stage2_decoded.hex()[:6]:
                f = open("attachment.zip","wb")
                f.write(stage2_decoded)
                f.close()
                with zip("attachment.zip","r") as f:
                        f.extractall(pwd=password)
        else:
                print("[+] stage2 decode integrity check failed. No magic bytes 504b03 detected.")
                quit()

def variant3_decompression(html):
        f = open(f"{html}","rb")
        html_read = str(f.read())
        f.close()
        b64_blob = html_read.split("data + \"")[1].split("\");")[0]
        password = html_read.split("<p class=\"box\">")[1].split("</p>")[0].encode()
        stage1_decoded = str(base64.b64decode(b64_blob))
        stage2_decoded = base64.b64decode(stage1_decoded.split("content = \\\'")[1].split("\\\';")[0])
        if "504b03" in stage2_decoded.hex()[:6]:
                f = open("attachment.zip","wb")
                f.write(stage2_decoded)
                f.close()
                with zip("attachment.zip","r") as f:
                        f.extractall(pwd=password)
        else:
                print("[+] stage2 decode integrity check failed. No magic bytes 504b03 detected.")
                quit()

if __name__ == "__main__":
        html = sys.argv[1]
        try:
            variant1_decompression(html)
        except:
            print("[!] attempt 1 failed")
        try:
            variant2_decompression(html)
        except:
            print("[!] attempt 2 failed")
        try:
            variant3_decompression(html)
        except:
            print("[!] attempt 3 failed")
