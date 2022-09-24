### SCRIPTING and MODULES ###
get-module 
Get-help *system*

## MODULES
# showing modules locations 
## 1
Get-ChildItem env:\ -| where Name -like *module*
## 2 - better. splitting
$env:PSModulePath -split ";"
cd     C:\Users\kk\Documents\PowerShell\Modules
    C:\Program Files\PowerShell\Modules
    c:\program files\powershell\7\Modules
    C:\Program Files\WindowsPowerShell\Modules
    C:\Windows\system32\WindowsPowerShell\v1.0\Modules

# copy module to C:\Users\kk\Documents\PowerShell\Modules
# 'get-help get-diskinfo' shows loaded module
# module name must match its folder 
# good practice to reload module 'Import-Module .\Diskinfo\Diskinfo.psm1 -force -verbose'

## gathering disk info off 3 machines in different subnet/Hyper VMs
$hostname="192.168.69.134"
$password = ConvertTo-SecureString "A241071z" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ("kk1\adm1", $password )
$winrmPort1 = "5001" 
$winrmPort2 = "5002" 
$winrmPort3 = "5003" 
$vm1=new-PSSession -ComputerName $hostName -Port $winrmPort1 -Credential $cred
$vm2=new-PSSession -ComputerName $hostName -Port $winrmPort2 -Credential $cred
$vm3=new-PSSession -ComputerName $hostName -Port $winrmPort3 -Credential $cred

Get-PSSession -name runspace1
Get-Diskinfo |gm
get-process -Session $vm1.InstanceId
