### Decryption script for sample 3a5c4bcadbdfdae9975bd89b29a553cf249d1c9492f4f08e99a1468b27ac8306

```ps
function aesdecrypt($EBfDE){
    $aesobject=[System.Security.Cryptography.Aes]::Create();
    $aesobject.Mode=[System.Security.Cryptography.CipherMode]::CBC;
    $aesobject.Padding=[System.Security.Cryptography.PaddingMode]::PKCS7;
    $aesobject.Key=[System.Convert]::FromBase64String('b64encoded_KEY_STRING');
    $aesobject.IV=[System.Convert]::FromBase64String('b64encoded_IV_STRING');
    $decrypter=$aesobject.CreateDecryptor();
    $decrypted_data=$decrypter.TransformFinalBlock($EBfDE,0,$EBfDE.Length);
    $decrypter.Dispose();
    $aesobject.Dispose();
    $decrypted_data;
}

function decompress($EBfDE){
    $memorystream1=New-Object System.IO.MemoryStream(,$EBfDE);
    $memorystream2=New-Object System.IO.MemoryStream;
    $decompressed_data=New-Object System.IO.Compression.GZipStream($memorystream1,[IO.Compression.CompressionMode]::Decompress);
    $decompressed_data.CopyTo($memorystream2);
    $decompressed_data.Dispose();
    $memorystream1.Dispose();
    $memorystream2.Dispose();
    $memorystream2.ToArray();
}

$azQnO=[System.IO.File]::ReadLines("BATCH_SCRIPT.cmd");
$PE1=decompress (aesdecrypt ([Convert]::FromBase64String([System.Linq.Enumerable]::ElementAt($azQnO, 5).Substring(2))));
$PE2=decompress (aesdecrypt ([Convert]::FromBase64String([System.Linq.Enumerable]::ElementAt($azQnO, 6).Substring(2))));

[system.io.file]::writeallbytes("payload1.dll", $PE1);
[system.io.file]::writeallbytes("payload2.dll", $PE2);
```
