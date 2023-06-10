# Observed indicators

First Observed: June 09, 2023

### Description

A victim, visits a domain that serves malvertisements. These advertisements redirect the user to the distribution domain `trk.version2trk[.]xyz`. Once on this domain, the user is either lured into clicking a "Free Download" button or compelled to download an installation package called "Version2.exe". Initially, this package appears to be a benign version of Thunderbird. The installation of Thunderbird results in the impanting of NetSupportRAT, which then connects back to the command and control server at `168.100.11[.]196:443`.

### Dynamic Analysis

https://app.any.run/tasks/8d094aed-c8ea-4e76-81ff-3d6cde178ffc  
https://tria.ge/230609-t7arvscf67/behavioral2  

### Distribution Domains observed

```
http://trk.version2trk[.]xyz/usaweb33
http://trk.version2trk[.]xyz/usamav2/
http://trk.canadiantrk[.]site/usaweb33/
http://trk.canadiantrk[.]site/usamav2
```

### Impersonated software

```
Thunderbird
transmission-qt (bittorrent client)
```

### Observed version2.exe hashes observed

```
66fd6a988b2af54ba04b4edde9799cb2ca15aff3ed68d9b788b0fc8c35b6e7c5
918df3483605d66cdd9a1abf3df845cffc2ed38436bfbe4b7f9b9eb748e1b573
79aa0a0c8511f72991bcaeddb5ccfa681455cd8d1f2fb58b341405bb5da9e760
02bcf28caf0fc104546f41aa03897fbba98a7d029fee6306cd480975c263cad9
08923a60e120fe077674ca51b5be89138b260cfa92ae90b0012495109d3e525b
0f5e791c346a9fd37f563fd5ba1d376f1016e9b4edc2db23574b49ad3b545b72
30055a0ae998537579feab7fab0e4911553ca72e333e1480847b4cd7ea2d7561
4aa9263114f93e2aee1e7735d3ff29c56cf8bb8e555bf887d610f0485d0512ce
57c9ac1ac1dc43d4583c0fdb2c1e50978d8775f35df7754b653292b57056bebc
5d3ab75a75e96fc952cde54a5ce0e8979fec491362a69ed3bc0d64cd31cbcfe8
643aa8ccf74ff0d5d74a8904d3a51e93db2e056628f96080004cf6c25bb65baa
85e811a4ddb480f1089d00a39342549fe924f90ca28c3c76cc6e8238b65d53bd
94981c216abad66e2d7fe2d86f5ecd31298313bb298441acf98e61f6b842d3c4
d2605f477748bbadeb7e598d7220d693f02282937a48e3d451a4430c6a33ea83
e175cbc09f8d753ea75d912f3aa2b6777387c1b6bafa06a72b98ed45b8b43987
f7ab7804a864cba3f8c16150053b4aad2174690095ab3796a99e5a498b7da64b
dfd2d087d21a050665dee54a81a24a334852781de7dfadee885b7c7958193a7c
```

### Observed signers used

```
Name	TWO PILOTS DOO
Status	Valid
Issuer	Sectigo RSA Code Signing CA
Valid From	12:00 AM 09/11/2020
Valid To	11:59 PM 09/11/2023
Valid Usage	Code Signing
Algorithm	sha256RSA
Thumbprint	273786A315BEA0FB02D26EFDEAF83C17BD878A00
Serial Number	45 69 16 37 80 2B 58 41 04 DB 69 BF E5 D1 9C F8

Name	Ivosight Software Inc.
Status	Valid
Issuer	Sectigo RSA Code Signing CA
Valid From	12:00 AM 12/24/2020
Valid To	11:59 PM 10/02/2023
Valid Usage	Code Signing
Algorithm	sha256RSA
Thumbprint	16D3312563F689AD1716ABC8DD0E711F510F4CA2
Serial Number	11 1F 05 B2 98 83 49 80 39 17 25 2D 01 EE D3 09

Name	Rhynedahll Software LLC
Status	Valid
Issuer	SSL.com EV Code Signing Intermediate CA RSA R3
Valid From	04:42 PM 05/04/2023
Valid To	04:42 PM 05/03/2024
Valid Usage	Code Signing
Algorithm	sha256RSA
Thumbprint	97A037320A2AC3A7C4A41FA7B53AFC6EC886450B
Serial Number	65 1F 3E 5B 49 1B 19 7D 20 C4 9B 9C 7B 25 B7 75

Name	Gesellschaft für Softwareentwicklung und Analytik GmbH
Status	Valid
Issuer	SSL.com EV Code Signing Intermediate CA RSA R3
Valid From	08:47 PM 07/23/2020
Valid To	08:47 PM 07/23/2023
Valid Usage	Code Signing
Algorithm	sha256RSA
Thumbprint	F19B05B2C406A06B1A801B170955F1693C84C9C6
Serial Number	48 CA B1 8C D9 44 F8 57 F7 0A 7C 35 06 27 03 64

Name	Techsoft
Status	Valid
Issuer	Sectigo Public Code Signing CA R36
Valid From	12:00 AM 03/15/2022
Valid To	11:59 PM 03/14/2025
Valid Usage	Code Signing
Algorithm	sha384RSA
Thumbprint	C85DF3623274F9A30144BD72350B56C8DEE9AE76
Serial Number	00 F9 9A B9 FC DF 58 E1 77 18 27 FC 26 FD B6 2B 62
```

### Net Support C2

```
168.100.11.196
206.166.251.123
```
