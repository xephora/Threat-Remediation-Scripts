from dotnetfile import DotNetPE
import sys
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives.ciphers.algorithms import AES
from cryptography.hazmat.primitives.ciphers.modes import CBC
from cryptography.hazmat.primitives.padding import PKCS7
from cryptography.hazmat.backends import default_backend
from base64 import b64decode

def aes_decrypt(input_bytes, key, iv):
        backend = default_backend()
        cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=backend)
        decryptor = cipher.decryptor()
        padded_data = decryptor.update(input_bytes) + decryptor.finalize()
        unpadder = PKCS7(AES.block_size).unpadder()
        data = unpadder.update(padded_data) + unpadder.finalize()

        try:
                with open("decrypt_bin.gz","wb") as f:
                        f.write(data)
        except:
                print(f"[!] Failed to write payload.")

def get_PEstreams(PE):
        data = PE.get_resources().pop()['Data']
        return data

if __name__ == "__main__":
        PE = sys.argv[1]
        dotnet_file = DotNetPE(PE)
        encrypted_data = get_PEstreams(dotnet_file) # Resouce stream is taking out of the .net bin containing the encrypted blob
        key = b64decode("UZvlWL382SgvCZYlj18UTZUOUtJMFPCo9FZJzxSxiHw=")
        iv = b64decode("RqIrsHLwODhnyJldiyQd5g==")
        aes_decrypt(encrypted_data, key, iv) # The data is decrypted and then written to disk.
