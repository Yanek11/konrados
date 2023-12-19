### PARAMETERS and commandlet binding
function t{
[cmdletbinding()]
param (
[string]$ComputerName='srv02',
[string]$Drive='c:'
)
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceId='$Drive'" -ComputerName $ComputerName |select SystemName,DeviceID,@{n='Size(GB)';e={$_.Size / 1GB -as [int]}},@{n='Free(GB)';e={$_.Freespace / 1GB -as [int]}}
}