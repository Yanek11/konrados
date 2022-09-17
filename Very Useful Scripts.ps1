#Region 1 finding CLASS NAME for get-CimInstance
Get-CimClass -Namespace root/CIMV2 | where CimClassName -like win32*system*
#Endregion

#Region 2 Enabling NAT via HyperV
New-NetIPAddress -IPAddress 1.1.1.254 -PrefixLength 24 -InterfaceIndex 53
New-NetNat -Name NATNetwork -InternalIPInterfaceAddressPrefix 1.1.1.0/24
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort 3001 -Protocol TCP -InternalIPAddress "1.1.1.1" -InternalPort 3389 -NatName NATNetwork
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort 5001 -Protocol TCP -InternalIPAddress "1.1.1.1" -InternalPort 5985 -NatName NATNetwork
#Endregion

#Region 3  Edit firewall rule scope with PowerShell ### ADDING MULTIPLE IPs - FIREWALL
Get-NetFirewallrule -DisplayName "*remote desktop*" # searching for a rule
Get-NetFirewallrule -Name "RemoteDesktop-UserMode-In-TCP"
#Endregion

#region 3.1 - FIREWALL COMMAND LINE
netsh advfirewall firewall
netsh firewall show state
#endregion


#Region 4 ading multiple IPs
Get-NetFirewallrule -Name "RemoteDesktop-UserMode-In-TCP" |   Get-NetFirewallAddressFilter | Set-NetFirewallAddressFilter -RemoteAddress '89.66.64.239','146.70.85.194','194.110.114.98'
Get-NetFirewallrule -Name "WinRM 8888" |   Get-NetFirewallAddressFilter | Set-NetFirewallAddressFilter -RemoteAddress '10.0.0.0/24'
#Endregion

#region 5 - How to execute fast script
### Both commands solve the same problem but Invoke is much more efficient
    #1 - FAST
invoke-command -ComputerName (Get-Content servers.txt) {}
    #2 - SLOW serial execition. if one of executions takes along time, the whole thing stops
foreach ($s in (get-content servers.txt)) {Invoke-Command -ComputerName $s {}}
#Endregion

#Region 6 # showing variables
dir variable:
dir Variable:\? 
dir Variable:\ErrorView
dir Variable:*error*
<# result
Name                           Value
----                           -----
Error                          {Cannot find path 'ErrorView\parameter' because it does not exist., Cannot call method. The provider does not support the use…
ErrorActionPreference          Continue
ErrorView                      ConciseView
Errorlog                       False
MyError                        {HRESULT 0x80070035,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand}
#>
dir Variable:\IsWindows
#Endregion

#Region 6 TABLE VIEWS 
<# get-process as example
default view shows weird columns
Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
    267      16     5484      25200       0.98   6148   3 ApplicationFrameHost
    396      29    58568     111848       4.09   1140   3 brave
    176       9     2140       7720       0.06   2504   3 brave
#>
# commands below are not working 100% . taken from Jumpstart YT training
get-process -name *bra* |sort  priority |ft -view priority
get-process -name *bra* |sort  StartTime |ft -view StartTime| select name,StartTime
get-process |gm
#Endregion

#Region 7 Write-output vs Write-Host 
#DONt USE  Write-Host 
Write-output # creates an object and casn be usedin a pipeline
Write-Host # displays string on the screen. no pipeline
#Endregion

#Region 8 ----

#Endregion