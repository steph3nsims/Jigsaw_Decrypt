#Simple script to decrypt files encrypted by the jigsaw malware...
$ErrorActionPreference = "SilentlyContinue"
$filename = read-host -Prompt "Filename to decode" 
if(!(test-path $filename)) 
	{Write-host "`nERROR: Please verify the filename is correct and you are in the right directory!"}
$EncryptionKey = [System.Convert]::FromBase64String("OoIsAwwF23cICQoLDA0ODe==")
$AESProvider = New-Object 'System.Security.Cryptography.AesManaged'
$AESProvider.key = $EncryptionKey
[Byte[]]$IV = ( 0, 1, 0, 3, 5, 3, 0, 1, 0, 0, 2, 0, 6, 7, 6, 0 )
$AESProvider.IV = $IV
$ciphertext = Get-content $filename -Encoding Byte
$decryptor = $AESProvider.CreateDecryptor()
$plaintxt = $decryptor.TransformFinalBlock($ciphertext, 16, $ciphertext.Length - 16);

[System.Text.Encoding]::ASCII.GetString($plaintxt[16..($plaintxt.count-1)]) | Out-file ([io.fileinfo]$filename).basename
