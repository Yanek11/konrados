# creating PS Session
$password = ConvertTo-SecureString "A241071z123!" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ("kk", $password )
$winrmPort = "8888" # HTTP
$hostname="vm1kk1kk1.uksouth.cloudapp.azure.com"
$soptions = New-PSSessionOption -SkipCACheck
Enter-PSSession -ComputerName $hostName -Port $winrmPort -Credential $cred -SessionOption $soptions -UseSSL
# creating PS Session

# testing 
Get-Item WSMan:\localhost\Client\TrustedHosts

Import-Module PSDiagnostics
Enable-PsWsmanCombinedTrace
Invoke-Command -script { get-service } -computer 20.0.55.132
Disable-PsWsmanCombinedTrace
# checking logs
get-winevent -logname Microsoft-Windows-WinRM/Operational -max 22 | select message