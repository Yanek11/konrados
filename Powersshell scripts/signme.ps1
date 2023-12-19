Write-host "hello"

$cert = New-SelfSignedCertificate -CertStoreLocation Cert:\CurrentUser\My -Type CodeSigningCert -Subject "myscripts"
Get-ChildItem -Path Cert:\CurrentUser\My | ? Subject -EQ "CN=myscripts"
Set-AuthenticodeSignature .\signme.ps1 $cert



