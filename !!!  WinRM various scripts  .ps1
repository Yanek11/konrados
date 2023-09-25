###########################################################################################
################################ WINRM / REMOTE POWERSHELL ################################
###########################################################################################

# VM2 Azure   20.0.55.132
# my laptop 146.70.85.194,194.110.114.98
# port 5985 http
### port 5986 https

## quick config
winrm quickconfig
winrm get winrm/config
winrm enumerate winrm/config/listener
Get-Item WSMan:\localhost\Listener*

### VM2 commands (Azure)
Get-Item WSMan:\localhost\Client\TrustedHosts

#### replacing / creating a list
Set-Item WSMan:\localhost\Client\TrustedHosts -Value 'vm1,vm2,vm3'
#### adding / concatenating
Set-Item WSMan:\localhost\Client\TrustedHosts -Value '192.168.69.128' -Concatenate

### DELETE HTTPS listener
winrm delete winrm/config/Listener?Address=*+Transport=HTTPs

### creating CUSTOM Listeners
### CREATE

#1 CMD - command propmpt
# OPTIONAL  if no listener is available
winrm quickconfig 
#1
Winrm set winrm/config/listener?Address=*+Transport=HTTP @{Port="8888"}
#2 checking
winrm enumerate winrm/config/listener
#3 configure Windows firewall to allow traffic on port 8888
#4 restart WinRm ?
#5 test connection

# compromising security
winrm set winrm/config/Client '@{AllowUnencrypted = "true"}'
# compromising security

  
###
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
###
### laptop
winrm set winrm/config/Client '@{AllowUnencrypted = "true"}'
Set-Item WSMan:\localhost\Client\TrustedHosts -Value '192.168.69.128',  '192.168.69.141'-Concatenate

winrs -r:20.0.55.132 dir
winrs -r:20.0.55.132 -un -u:kk -p:A241071z123! ipconfig



### not working (Access denied)  so troubleshooting needed - username incorrect TSHOOT
Import-Module PSDiagnostics
Enable-PsWsmanCombinedTrace
Invoke-Command -script { get-service } -computer 20.0.55.132
Disable-PsWsmanCombinedTrace
# checking logs
get-winevent -logname Microsoft-Windows-WinRM/Operational -max 22 | select message


### Configuring HTTPs listerner on WinRM Server/Service - Azure Vm-2
### configuring HTTPs
New-SelfSignedCertificate -DnsName "vm1kk1kk1.uksouth.cloudapp.azure.com" -CertStoreLocation Cert:\LocalMachine\My

# thumbnail
2340B3198F55A3FBCB4A9360C8AA771FA3A3CFDF
# delete old listener
winrm delete winrm/config/Listener?Address=*+Transport=HTTPs
WinRM e winrm/config/listener

# creating HTTPs listener
winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname="vm2kk1.uksouth.cloudapp.azure.com"; CertificateThumbprint="2340B3198F55A3FBCB4A9360C8AA771FA3A3CFDF"}'
# verifying 
WinRM e winrm/config/listener


***************************

### Connecting from client
$hostName="laptop" 
$winrmPort = "5986"

# Get the credentials of the machine
$cred = Get-Credential

# Connect to the remote machine in Azure - SUCCESS :)
$soptions = New-PSSessionOption -SkipCACheck
Enter-PSSession -ComputerName $hostName -Port $winrmPort -Credential $cred -SessionOption $soptions -UseSSL

# connecting using Invoke-Command - not working when connecting from my laptop. works when connecting between 2 Azure Vms
Invoke-Command -ComputerName $hostName {$env:COMPUTERNAME} -Credential $cred -UseSSL -Port $winrmPort 


*********************
# Conencting between Azure hosts
### Connecting from client
$hostName="vm2" 
$winrmPort = "8888" # HTTP

# Get the credentials of the machine
$cred = Get-Credential

# connecting using Invoke-Command - not working when connecting from my laptop. works when connecting between 2 Azure Vms
Invoke-Command -ComputerName $hostName {$env:COMPUTERNAME} -Credential $cred -Port $winrmPort 
# multiple hosts searching 
Invoke-Command -ComputerName $hostName {get-service | where {$_.status -eq "Stopped" -and $_.Name -like "wua*" }} -Credential $cred -Port $winrmPort 

************ Connecting from home laptop to Azure host

### Connecting from client
### using HTTP

$hostName="20.0.49.78" 
$winrmPort = "8888" # HTTP

# Get the credentials of the machine
$cred = Get-Credential

# connecting using Invoke-Command - not working when connecting from my laptop. works when connecting between 2 Azure Vms
Invoke-Command -ComputerName $hostName {$env:COMPUTERNAME} -Credential $cred -Port $winrmPort 
# multiple hosts searching 
Invoke-Command -ComputerName $hostName {get-service | where {$_.status -eq "Stopped" -and $_.Name -like "wua*" }} -Credential $cred -Port $winrmPort 

### using HTTPs and SSL

# creating HTTPs port 8888 and SSL

## 1 delete old HTTP and HTTPs
winrm delete winrm/config/Listener?Address=*+Transport=HTTPs
winrm delete winrm/config/Listener?Address=*+Transport=HTTP

## 2 - certificate
New-SelfSignedCertificate -DnsName "vm1kk1kk1.uksouth.cloudapp.azure.com" -CertStoreLocation Cert:\LocalMachine\My
# thumbprint 
DFB4048F2C7CA01269384C781E3B0B0DCCDEFBFD

## 3 - configure 
winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname="vm1kk1kk1.uksouth.cloudapp.azure.com"; CertificateThumbprint="DFB4048F2C7CA01269384C781E3B0B0DCCDEFBFD"}'

## 4 - change port
Winrm set winrm/config/listener?Address=*+Transport=HTTPs @{Port="8888"}

## 5 - test - connecting to Azure VM via WinRM
$hostname="vm1kk1kk1.uksouth.cloudapp.azure.com"
$soptions = New-PSSessionOption -SkipCACheck
# $cred = Get-Credential
# very insecure !!!!!!!
$password = ConvertTo-SecureString "A241071z123!" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ("kk", $password )
# very insecure !!!!!!!
$winrmPort = "8888" # HTTP
Enter-PSSession -ComputerName $hostName -Port $winrmPort -Credential $cred -SessionOption $soptions -UseSSL


### DOUBLE HOP - CONNECTING TO ANOTHER Azure host for VM1
$hostname="vm1kk1kk1.uksouth.cloudapp.azure.com"
$soptions = New-PSSessionOption -SkipCACheck
Enter-PSSession -ComputerName $hostName -Port $winrmPort -Credential $cred -SessionOption $soptions -UseSSL

# installing AD forest / domain on VM1/Azure
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath “C:\Windows\NTDS” -DomainMode “WinThreshold” -DomainName “kk1.fun” -DomainNetbiosName “Kk1” -ForestMode “WinThreshold” -InstallDns:$true -LogPath “C:\Windows\NTDS” -NoRebootOnCompletion:$false -SysvolPath “C:\Windows\SYSVOL” -Force:$true

### Broke DNS and lost access to VM2@Azure. configured DNs server from automatic to IP of new Azure VM1 DC 10.0.0.4
# solution 1 - configure DNS server via PS
### VM restart fixes the problem


$cred = Get-Credential
$winrmPort = "8888" # HTTP
$hostname="vm2"
Invoke-Command -ComputerName vm2 {$env:COMPUTERNAME} -Credential $cred -Port $winrmPort 
Invoke-Command -ComputerName vm2 {dir c:\} -Credential $cred -Port $winrmPort 

# executing command on a remote host and piping the output to a locsl PS session - takes 2.39 secs
measure-command {Invoke-Command -ComputerName vm2 -ScriptBlock {get-process} -Credential $cred -Port $winrmPort |where {$_.name -ne "notepad"}}

# running Invoke command via a PS Session on multiple machines
$cred = Get-Credential
$winrmPort = "8888" # HTTP
$hostname=("vm2","vm3")
Invoke-Command -ComputerName $hostName  -ScriptBlock {get-process |where {$_.name -ne "notepad"}} -Credential $cred -Port $winrmPort

### Session and Enter-Session. 
$cred = Get-Credential
$winrmPort = "8888" # HTTP
$sess=New-PSSession -ComputerName vm2 -Credential $cred -Port $winrmPort
Get-PSSession # shows the session created and stored in $sess
Invoke-command -session $sess {$var=10}
Invoke-command -session $sess {$var} # shows 10 
$sess | Remove-PSSession

### adding a user and adding to a security group. using FILTER
New-ADUser -Name "kkadm" -Accountpassword (Read-Host -AsSecureString "AccountPassword") -Enabled $true
Get-ADUser -filter {name -like "*adm*"}
Get-ADGroup -filter {name -like "*domain*adm*"}

$user=Get-ADUser -filter {name -like "*adm*"}
$group = Get-ADGroup -filter {name -like "*domain*adm*"}; 
Add-ADGroupMember $group -Member $user 

### import AD module via PSSession on DC
## Session and Enter-Session. 
$password = ConvertTo-SecureString "A241071z123!" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ("kk", $password )
$winrmPort = "8888" # HTTP
$hostname="vm1kk1kk1.uksouth.cloudapp.azure.com"
$soptions = New-PSSessionOption -SkipCACheck

$sess=New-PSSession -ComputerName $hostName -Credential $cred -Port $winrmPort -UseSSL -SessionOption $soptions
Get-PSSession # shows the session created and stored in $sess

import-module -Name ActiveDirectoryModule -PSSession $sess

### & causing execution ###
$comm="get-process"
$comm # output is expression 'get-process'
&$comm #     output is a result of command  'get-process'



### Connection to VM1@Azure
$hostname="vm1kk1kk1.uksouth.cloudapp.azure.com"
$soptions = New-PSSessionOption -SkipCACheck
# $cred = Get-Credential
# very insecure !!!!!!!
$password = ConvertTo-SecureString "A241071z123!" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ("kk", $password )
# very insecure !!!!!!!
$winrmPort = "8888" # HTTP
Enter-PSSession -ComputerName $hostName -Port $winrmPort -Credential $cred -SessionOption $soptions -UseSSL

### Connection to VM2

### PowerShell Web Access ###
Install-WindowsFeature –Name WindowsPowerShellWebAccess -ComputerName <computer_name> -IncludeManagementTools -Restart

### REMOTING coninue ###

