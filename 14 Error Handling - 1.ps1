<#
.SYNOPSIS
this is synopsis
#>
$ErrorActionPreference
$ComputerName='srv01','srv02','vdc01'
#1
Get-CimInstance -ClassName Win32_BIOS -ComputerName $ComputerName
#2
Get-CimInstance -ClassName Win32_BIOS -ComputerName $ComputerName -ErrorAction SilentlyContinue -ErrorVariable MyError
$MyError
#3
Get-CimInstance -ClassName Win32_BIOS -ComputerName $ComputerName -ErrorAction Stop

<#4 - Script is asking to confirm execution

Confirm
WinRM cannot process the request. The following error occurred while using Kerberos authentication: Cannot find the computer dc01. Verify that the computer
exists on the network and that the name provided is spelled correctly.
[Y] Yes  [A] Yes to All  [H] Halt Command  [S] Suspend  [?] Help (default is "Y"):
#>
Get-CimInstance -ClassName Win32_BIOS -ComputerName $ComputerName -ErrorAction Inquire