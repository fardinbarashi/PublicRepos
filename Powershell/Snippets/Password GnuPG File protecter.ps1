
 
 # GnuPpg - Settings
$publickey = "" 
$filepath = "FilesThatAregoingTobeProtected" 
$GpgPath = "C:\Program Files (x86)\GnuPG\bin\gpg.exe"
$PrivKey = ""
$Password = "" 
Start-Process -FilePath $GpgPath -ArgumentList "--pinentry-mode=loopback --batch --local-user $PrivKey --passphrase $Password --recipient $publickey --sign --encrypt $filepath\*"
