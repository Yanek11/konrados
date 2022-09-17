    # connect to multiple machines
    # two versions: 1 - SSL enabled for WinRM
# search for files with a specific string in a name and save to variable
    ## filename cotains *dupaduza* in c: and  %USERPROFILE%
    ## save modify, size and location/path
# export the variable to HTML file


    # check if WinRM can connect / scan 
    Test-NetConnection -Port $Portwinrm -ComputerName $Computers -Verbose
    #check firewall rule

# Invoke-session
# get-childitem -filter 


## securely store password
$Computers="srv02","srv03"
$String1="dupa"
$Creds=
$Portwinrm='5985'
$Path="C:\temp\"
$Path1="%USERPROFILE%"


invoke-command -ComputerName $Computers -Port $Portwinrm -ScriptBlock {gci -filter "*interop*" -Path $using:path -File -recurse -Depth 6} |select fullname,pscomputername,creationtime,lastwritetime,@{Name="Size KB";Expression={ "{0:N0}" -f ($_.Length / 1KB) }} |ft 


invoke-command -ComputerName $Computers -Port $Portwinrm -ScriptBlock { <#cmd echo#> cmd $path1 <#gci -filter "*interop*" -Path $using:path1 -File -recurse -Depth 6#>} |ft 
^(?!.*Users.*).+$


#invoke-command -ComputerName $Computers -Port $Portwinrm -ScriptBlock {Get-Childitem c:\temp\ | Select-Object FullName,creationtime,lastwritetime, @{Name="Size KB";Expression={ "{0:N0}" -f ($_.Length / 1KB) }}}



invoke-command -ComputerName $Computers -Port $Portwinrm -ScriptBlock {gci c:\temp\ |select fullname,creationtime,lastwritetime|ft}

#region ############ ESTABLISHING CONNECTION WINRM ############ 

#region quick config
    ## Checking current config
    winrm get winrm/config
    winrm enumerate winrm/config/listener
    ## quick config
    winrm quickconfig
    
    Get-Item WSMan:\localhost\Listener*
    Get-Item WSMan:\localhost\Client\TrustedHosts
    #### replacing / creating a list
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value 'vm1,vm2,vm3'
    #### adding / concatenating
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value '192.168.69.134' -Concatenate
    ### DELETE HTTPS listener
    winrm delete winrm/config/Listener?Address=*+Transport=HTTPs
#endregion

#region WINRM CUSTOM LISTENER
### creating CUSTOM Listeners
#1 CMD - command propmpt
# OPTIONAL  if no listener is available
winrm quickconfig 
Winrm set winrm/config/listener?Address=*+Transport=HTTP @{Port="8888"}
winrm enumerate winrm/config/listener
configure Windows firewall to allow traffic on port 8888
#endregion

#region Windows Remote Shell
winrs -r:20.0.55.132 dir # -r remote host
winrs -r:20.0.55.132 -un -u:kk -p:A241071z123! ipconfig # -un unencrypted -u username
#endregion

#region  Configuring HTTPs listerner on WinRM Server/Service 
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
#endregion

#region WINRM Connecting from client. Invoke-Command / Enter-PSSession
$hostName="vm2kk1.uksouth.cloudapp.azure.com" 
$winrmPort = "5986"
$cred = Get-Credential
$soptions = New-PSSessionOption -SkipCACheck
Enter-PSSession -ComputerName $hostName -Port $winrmPort -Credential $cred -SessionOption $soptions -UseSSL

# connecting using Invoke-Command - not working when connecting from my laptop. works when connecting between 2 Azure Vms
Invoke-Command -ComputerName $hostName {$env:COMPUTERNAME} -Credential $cred -UseSSL -Port $winrmPort 
#endregion

#region # creating HTTPs port 8888 and SSL

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

#endregion

#region DOUBLE HOP - CONNECTING TO ANOTHER Azure host for VM1
$hostname="vm1kk1kk1.uksouth.cloudapp.azure.com"
$soptions = New-PSSessionOption -SkipCACheck
Enter-PSSession -ComputerName $hostName -Port $winrmPort -Credential $cred -SessionOption $soptions -UseSSL
#endregion

#region ## Session and Enter-Session. 
$cred = Get-Credential
$winrmPort = "8888" # HTTP
$sess=New-PSSession -ComputerName vm2 -Credential $cred -Port $winrmPort
Get-PSSession # shows the session created and stored in $sess
Invoke-command -session $sess {$var=10}
Invoke-command -session $sess {$var} # shows 10 
$sess | Remove-PSSession
#endregion

#endregion
