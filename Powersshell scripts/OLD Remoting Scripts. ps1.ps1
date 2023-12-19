### Connection to VM1
$hostname="192.168.69.134"
$soptions = New-PSSessionOption -SkipCACheck
# $cred = Get-Credential
# very insecure !!!!!!!
$password = ConvertTo-SecureString "A241071z" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ("kk1\adm1", $password )
# very insecure !!!!!!!
$winrmPort = "5001" # HTTP
$vm1=new-PSSession -ComputerName $hostName -Port $winrmPort -Credential $cred
Import-PSSession -Session $vm1

Get-remoteADComputer -Filter * # using remoe command
$c=get-command  get-process
$c.parameters["name"]
get-command get-*adcomputer
Get-remoteADuser -filter *
(get-command get-remoteadcomputer).Definition
