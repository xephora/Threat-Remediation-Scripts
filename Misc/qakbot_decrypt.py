"""
After reading Cisco Talos's analysis on the 2016 Qakbot analysis, I realize their link to download the Qakbot script was no longer accessible and tailored for Python 2.  They provided a screenshot of the code, so I re-coded the script made it Python 3 friendly.

Resouce: https://blog.talosintelligence.com/2016/04/qbot-on-the-rise.html

Results:

python3 decrypt.py oprl.dll
¿!?OËK0îáåqþÞÞ]«&ÝLit=3
install_time=10.40.23-12/02/2016
itstmp=1355724121
"""
from Crypto.Cipher import ARC4
from Crypto.Hash import SHA
import sys
import os

def Decryption(data, filename):
        h = SHA.new(filename)
        key = h.digest()
        cipher = ARC4.new(key)
        return cipher.decrypt(data)

if __name__ == "__main__":
        filename = sys.argv[1]
        cwd = os.getcwd()
        filepath = f"{cwd}/{filename}"
        data = open(filepath, "rb").read()
        filename = filename.split(".")[0]
        for i in range(0,26):
                letter = chr(0x61 + i)
                key = filename + letter
                decrypted = Decryption(data, key.encode())
                if decrypted[0:20] in SHA.new(decrypted[20:]).digest():
                        print(decrypted.decode("latin1"))
