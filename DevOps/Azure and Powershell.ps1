### DNS CONFIGURATION ###

# changing VM DNS must be done from AZ Powershell not locally 
# adding  DNS server via AZ Powershell

    Get-AzNetworkInterface
    $nic = Get-AzNetworkInterface -ResourceGroupName "RG1" -Name "azexch033"
    $nic.DnsSettings.DnsServers.add("1.1.1.15")
## Azure DNS 168.63.129.16  
    $nic.DnsSettings.DnsServers.add("168.63.129.16")
    $nic | Set-AzNetworkInterface


# checking if change OK
$nic = Get-AzNetworkInterface -ResourceGroupName "RG1" -Name "azexch033"
$nic.DnsSettings.DnsServers


# adding DNS server via local Powershell - - only for non-Azure VM
Get-DnsClientServerAddress
Set-DNSClientServerAddress "Ethernet" –ServerAddresses ("1.1.1.15", "168.63.129.16")

# resetting DNS addresses
Set-DNSClientServerAddress -ResetServerAddresses

### POWERSHELL REMOTE ###

# Enabling Remote Powershell
Enable-PSRemoting -Force
New-NetFirewallRule -Name "Allow WinRM HTTPS" -DisplayName "WinRM HTTPS" -Enabled True -Profile Any -Action Allow -Direction Inbound -LocalPort 5986 -Protocol TCP
$thumbprint = (New-SelfSignedCertificate -DnsName $env:COMPUTERNAME -CertStoreLocation Cert:\LocalMachine\My).Thumbprint
$command = "winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=""$env:computername""; CertificateThumbprint=""$thumbprint""}"
cmd.exe /C $command

Get-Item WSMan:\localhost\Client\TrustedHosts

# Machine 1 - non domain - 3.3.3.5
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value 'dc01.kaka.local'
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value '*.kakaka.store'

# Machine 2 - domain joined - dc01.kaka.local
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value '3.3.3.15','3.3.3.16','1.1.1.16','1.1.1.15' -Concatenate

# checking 
Get-Item WSMan:\localhost\Client\TrustedHosts

# Connecting to remote machine in Azure via VPN 
Enter-PSSession -ComputerName 3.3.3.16 -Credential kkadm # local admin
## AD login
Enter-PSSession -ComputerName 3.3.3.16 -Credential "ad-adm@ad.kakaka.store" # AD admin

Enter-PSSession -ComputerName 1.1.1.16 -Credential "ad-adm@ad.kakaka.store" # AD admin

### AD / DOMAIN ###
# renaming machine
Rename-Computer -newname azExch-04
# adding computer to a AD domain
Add-Computer -DomainName kaka.local -Restart


### FIREWALL ###
## enabling ICMP
netsh advfirewall firewall add rule name="Allow ICMPv4" protocol="icmpv4:8,any" dir=in action=allow

### Second Exchange installation via remote Powershell  (1vCPU/3.5GB RAM) ###

# checking software version
Get-WmiObject -Class Win32_Product | where-object name -like *Exchange* | select-object Name, Version

# removing unfinished Exchange installation
./setup.exe /mode:uninstall /IAcceptExchangeServerLicenseTerms_DiagnosticDataON 

## installing features
    Install-WindowsFeature RSAT-Clustering-CmdInterface, NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation, RSAT-ADDS

    .\Setup.exe /mode:Install /role:Mailbox /OrganizationName:"First Organization"  /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF 



    ### NEW EXCHANGE 2016 INSTALLATION ###
# adding pin point DNS - 1.1.1.16 
mail.kakaka.store
autodiscover.kakaka.store
# testing
Resolve-DnsName autodiscover.kakaka.store
Resolve-DnsName mail.kakaka.store


# setting new Namespace URLs
# https://practical365.com/exchange-server-2016-client-access-namespace-configuration/

$srv="azexch05","eset"

#1 OWA - Outlook Web App
Get-OwaVirtualDirectory -Server $srv | Set-OwaVirtualDirectory -InternalUrl https://mail.kakaka.store/owa -ExternalUrl https://mail.kakaka.store/owa
Get-OwaVirtualDirectory -Server $srv |select InternalUrl # checking

#2 Autodiscover
Set-Clientaccessservice -identity $srv -autodiscoverserviceinternaluri https://mail.kakaka.store/Autodiscover/Autodiscover.xml 
Get-ClientAccessService |select name, autodiscoverserviceinternaluri

#3 ECP - Exchange COntrol Panel
    Get-EcpVirtualDirectory -Server $srv | Set-EcpVirtualDirectory -ExternalUrl $null -InternalUrl https://mail.kakaka.store/ecp
    Get-EcpVirtualDirectory -Server $srv |select InternalUrl, -ExternalUrl

#4 EWS - Exchange Web Services
Get-WebServicesVirtualDirectory -Server $srv | Set-WebServicesVirtualDirectory -ExternalUrl https://mail.kakaka.store/EWS/Exchange.asmx  -InternalUrl https://mail.kakaka.store/EWS/Exchange.asmx 
Get-WebServicesVirtualDirectory -Server $srv

#5 MAPI 
Get-MapiVirtualDirectory -Server $srv | Set-MapiVirtualDirectory -ExternalUrl https://mail.kakaka.store/mapi -InternalUrl https://mail.kakaka.store/mapi

Get-MapiVirtualDirectory | FL ServerName, *url*, *auth* # checking

#6 ActiveSync
Get-ActiveSyncVirtualDirectory -Server $srv | Set-ActiveSyncVirtualDirectory -ExternalUrl https://mail.kakaka.store/Microsoft-Server-ActiveSync -InternalUrl https://mail.kakaka.store/Microsoft-Server-ActiveSync
Get-ActiveSyncVirtualDirectory -Server $srv 

#7 OAB - Offline Address Book
Get-OabVirtualDirectory -Server $srv | Set-OabVirtualDirectory -ExternalUrl https://mail.kakaka.store/OAB -InternalUrl https://mail.kakaka.store/OAB
Get-OabVirtualDirectory -Server $srv 

#8 Powershell - OPTIONAL ?!

Get-powershellVirtualDirectory -Server $srv | Set-powershellVirtualDirectory -ExternalUrl $null -InternalUrl https://mail.kakaka.store/powershell
Get-powershellVirtualDirectory -Server $srv 

# checking Exchange services status where StartType Automatic
get-service | where {$_.status -eq "Stopped" -and $_.Name -like "msex*" -and $_.StartType -like "Automatic*"}

# Exchange Management Shell - connecting remotely from another machine to Exchange 

    Set-ExecutionPolicy RemoteSigned
    $UserCredential = Get-Credential
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://exch01.ad.kakaka.store/powershell -Authentication Kerberos -Credential $UserCredential
    Import-PSSession $Session -DisableNameChecking -AllowClobber

# Exchange Health check
Get-ServerHealth -identity $srv |where-object {$_.alertvalue -eq "unHealthy"}
# checking MAPI connectivity
Get-MailboxDatabase | Test-MAPIConnectivity

# DNS
https://www.howto-outlook.com/howto/autodiscoverconfiguration.htm
## adding autodiscover -external DNS
    Name: autodiscover
    TTL: 3600
    RR Type: CNAME
    Value: mail.kakaka.Store
Resolve-DnsName -Type mx kakaka.store -Server 9.9.9.9 |FT -AutoSize
Resolve-DnsName -Type A MX.kakaka.store -Server 9.9.9.9 |FT -AutoSize
Resolve-DnsName -Type txt AUTODISCOVER.kakaka.store -Server 9.9.9.9 |FT -AutoSize

# SSL certificate creation - Zero SSL

# Checking Hotfixes installed
systeminfo /fo csv | ConvertFrom-Csv | Select OS*, System*, Hotfix* | Format-List


# DHCP replication HA
    Invoke-DhcpServerv4FailoverReplication -ComputerName "dc01.ad.kakaka.store" -Name "First relationship"

    Get-DhcpServerv4Failover
    get-help
    et-help *dhcp* |where {$_.Name -like "get-*scope*"}
    Get-DhcpServerv4Scopes

    Get-DhcpServerv4Lease -ScopeId 1.1.1.0 | where-object {$_.Hostname -like "ese*"}

    Enter-PSSession -ComputerName mx.kakaka.store -Credential "backup\adm-kk-backup" -Port 673
    Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value '*.kakaka.store' -Concatenate

# M365 trial

konradkaluszynski@konradk760.onmicrosoft.com

######### Exchange - remove / delete Exchange server from AD ######### 

### azExch03 could not be uninstalled so I had to remove it manually using https://www.stellarinfo.com/article/remove-failed-exchange-server-from-active-directory.php

## Unmount the mailbox database
Get-MailboxDatabase -Server azexch03 |Dismount-Database
Get-MailboxDatabase -Server azexch03 -Status | ft name,mounted
Get-MailboxDatabase -Server azexch03 |remove-MailboxDatabase
## Delete the mailbox database

## Remove the database files

# fixing connectivity errors - Microsoft remote Connectivity Analyzer
## https://terenceluk.blogspot.com/2019/04/running-remote-connectivity-analyzer.html
# Outlook Anywhere
Get-OutlookAnywhere | FL Identity,*Host*,*requireSSL*

Set-OutlookAnywhere -Identity:"exch01\Rpc (Default Web Site)" -DefaultAuthenticationMethod NTLM -InternalHostname <internalFQDNURL> -InternalClientsRequireSsl $true -ExternalHostname <externalFQDNURL> -ExternalClientsRequireSsl $true -SSLOffloading $false

### DAG - installing of second Exchange server ###
# https://www.alitajran.com/create-dag-exchange-server/

# Exch01
# - renaming existing database to DB01

Get-MailboxDatabase | fl Name,EdbFilePath,LogFolderPath # Mailbox Database 1209001991
Set-MailboxDatabase "Mailbox Database 0171670896" -Name "DB05"

# moving database to another folder - F:\Mailbox Databases
Move-DatabasePath DB01 -EdbFilePath "F:\Mailbox Databases\DB01.edb" -LogFolderPath "F:\Mailbox Databases\DB01"
Move-DatabasePath DB02 -EdbFilePath "F:\Mailbox Databases\DB02.edb" -LogFolderPath "F:\Mailbox Databases\DB02"
Move-DatabasePath DB05 -EdbFilePath "c:\Mailbox Databases\DB05.edb" -LogFolderPath "c:\Mailbox Databases\DB05" # azExch05

# checking DAG health
Test-ReplicationHealth 
Get-ServerComponentState -Identity Exch01
Get-ServerComponentState -Identity Eset
Test-ServiceHealth exch01
Test-ServiceHealth eset
Get-MailboxDatabaseCopyStatus |ft -AutoSize

# adding second copy of the mailbox database on different Exchange server (ESET)
Add-MailboxDatabaseCopy -Identity DB01 -MailboxServer ESET -ActivationPreference 2
##  restart the Microsoft Exchange Information Store service on server ESET after adding new mailbox
restart-Service -Name "MSExchangeIS" # ESET
# same for EXCH01
Add-MailboxDatabaseCopy -Identity DB02 -MailboxServer EXCH01 -ActivationPreference 2
restart-Service -Name "MSExchangeIS" # EXCH01

# adding Exchange #3 (azExch05)
get-MailboxDatabase -Server azexch05 | select name,logfolderpath
Set-MailboxDatabase "Mailbox Database 0171670896" -Name "DB05"
Move-DatabasePath DB05 -EdbFilePath "f:\Mailbox Databases\DB05.edb" -LogFolderPath "f:\Mailbox Databases\DB05" # azExch05
# add new server to DAG
Add-DatabaseAvailabilityGroupServer -MailboxServer azexch05 -Identity dag1
# adding mailboxes copies
Add-MailboxDatabaseCopy -Identity DB05 -MailboxServer Exch01 -ActivationPreference 2
Add-MailboxDatabaseCopy -Identity DB05 -MailboxServer ESET -ActivationPreference 2
##  adding ESET and EXCH01 databases on azEXCH 
## execute on EXCH01
Add-MailboxDatabaseCopy -Identity DB01 -MailboxServer azExch05 -ActivationPreference 2
Add-MailboxDatabaseCopy -Identity DB02 -MailboxServer azExch05 -ActivationPreference 2
# restart MS Exchange Information Store service on current server
get-service -name  "msexchangeis" |Restart-Service
# or restart the service on all 3 servers
get-service -name  "msexchangeis" -ComputerName eset,azexch05,exch01 |Restart-Service
#checking status
get-service -name  "msexchangeis" -ComputerName eset,exch01,azexch05 |select machinename,name,status

### removing database copies on azExch05
## https://www.alitajran.com/mailbox-server-cannot-be-removed-from-dag/
Remove-MailboxDatabaseCopy -Identity "DB05\Exch01" -Confirm:$false
Remove-MailboxDatabaseCopy -Identity "DB01\azexch05" -Confirm:$false
Add-MailboxDatabaseCopy -Identity DB02 -MailboxServer azExch05 -ActivationPreference 2
Add-MailboxDatabaseCopy -Identity DB05 -MailboxServer ESET -ActivationPreference 2

# setting MS Exchange services to Automatic Delayed 
Get-Service | Where-Object {$_.StartupType -eq "Automatic" -and $_.name -like "msexc*"} | set-service  -Startuptype "AutomaticDelayedStart"
Get-Service | Where-Object {$_.StartupType -eq "AutomaticDelayedStart" -and $_.name -like "msexc*"}| select DisplayName, Status, StartupType

# Sending email via Powershell - COOL :)
$smtp = New-Object Net.Mail.SmtpClient("mx.kakaka.store")
$smtp.Send("test1@kakaka.store","test2@kakaka.store","Test Email","This is a test")

### Failover between Exch01 and ESET / EXCH02
 # what to do when EXCH01 goes down
# Proxmox/SMart host - change SMTP relay
# check ECP / Mailflow / Send connectors / Source server - current active Exchange must be added
# check active Exchange: ECP/servers/ESET/Outlook Anywhere - external and internal hostname
# check SSL binding: if there are multiple binding to the same port like 444 (backend) or 443 (OWA), delete the duplicates, restart IIS/iisreset

# Disk operations - resize, delete
# VMware
##free space check
df -h  /vmfs/volumes/datastore1/
## folder usage 
du -h  /vmfs/volumes/datastore1/

# BreakIT VM disks
# Target /vmfs/volumes/Backup\ datastore/Disks/BreakIT/

# Source
/vmfs/volumes/datastore1/TEST2/
/vmfs/volumes/datastore1/SRV-TEST-02/

## FILES
/vmfs/volumes/datastore1/TEST2/W2016-1.vmdk 
/vmfs/volumes/datastore1/TEST2/W2016-1-flat.vmdk

/vmfs/volumes/datastore1/SRV-TEST-02/SRV-TEST-02.vmdk

vmkfstools --clonevirtualdisk "/vmfs/volumes/datastore1/TEST2/W2016-1.vmdk" --diskformat thin "/vmfs/volumes/Backup\ datastore/Disks/BreakIT/W2016-1-thin.vmdk" 

vmkfstools -i "/vmfs/volumes/datastore1/SRV-TEST-02/SRV-TEST-02.vmdk" -d thick "/vmfs/volumes/Backup\ datastore/Disks/BreakIT/SRV-TEST-02.vmdk"

# killing unresponsive VM via ESXI cmd
https://kb.vmware.com/s/article/1014165#steps_using_esxi_esxcli_command_to_power_off_virtual_machine
## getting world ID 
esxcli vm process list # 2101825
## kill
esxcli vm process kill --type= [soft,hard,force] --world-id= WorldNumber
esxcli vm process kill --type=soft --world-id=2101825
vim-cmd vmsvc/power.off 17
vim-cmd vmsvc/getallvms


# Outlook / Exchange # commands
## checking Outlook clients connected to Exchange
Get-LogonStatistics -server  SRV-19-EXCH01.ad.kakaka.store | Where-Object { $_.ApplicationId -like "Outlook" } | Select-Object UserName, ApplicationId, ClientVersion, LastAccessTime # not working on 2019
## checking queue - EMS
get-queue

# changing Send conenctor port on Exchange - EMS
get-sendconnector
set-sendconnector -identity "Proxmox" -port 26
get-sendconnector "Proxmox" |fl port
get-service | Where-Object {$_.Name -eq "MSExchangeTransport" } |Restart-Service