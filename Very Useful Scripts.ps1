# Enabling NAT via HyperV
New-NetIPAddress -IPAddress 1.1.1.254 -PrefixLength 24 -InterfaceIndex 53
New-NetNat -Name NATNetwork -InternalIPInterfaceAddressPrefix 1.1.1.0/24

Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort 3001 -Protocol TCP -InternalIPAddress "1.1.1.1" -InternalPort 3389 -NatName NATNetwork
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort 5001 -Protocol TCP -InternalIPAddress "1.1.1.1" -InternalPort 5985 -NatName NATNetwork


### Edit firewall rule scope with PowerShell ### ADDING MULTIPLE IPs
Get-NetFirewallrule -DisplayName "*remote desktop*" # searching for a rule

Get-NetFirewallrule -Name "RemoteDesktop-UserMode-In-TCP"
# ading multiple IPs
Get-NetFirewallrule -Name "RemoteDesktop-UserMode-In-TCP" |   Get-NetFirewallAddressFilter | Set-NetFirewallAddressFilter -RemoteAddress '89.66.64.239','146.70.85.194','194.110.114.98'

Get-NetFirewallrule -Name "WinRM 8888" |   Get-NetFirewallAddressFilter | Set-NetFirewallAddressFilter -RemoteAddress '10.0.0.0/24'

### Both commands solve the same problem but Invoke is much more efficient
#1
invoke-command -ComputerName (Get-Content servers.txt) {}
#2 - serial execition. if one of executions takes along time, the whole thing stops
foreach ($s in (get-content servers.txt)) {Invoke-Command -ComputerName $s {}}

