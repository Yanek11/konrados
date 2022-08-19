Get-CimInstance -ClassName win32_bios -ComputerName srv02,srv03

Get-CimInstance -ClassName Win32_LogicalDisk -Filter "deviceid='c:'" -ComputerName 'localhost','srv02','srv03'|select SystemName,DeviceID,@{n='Size(GB)';e={$_.Size / 1GB -as [int]}},@{n='Free(GB)';e={$_.Freespace / 1GB -as [int]}}


### PARAMETERS
param (
[string]$ComputerName='srv02',
[string]$Drive='c:'
)
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceId='$Drive'" -ComputerName $ComputerName |select SystemName,DeviceID,@{n='Size(GB)';e={$_.Size / 1GB -as [int]}},@{n='Free(GB)';e={$_.Freespace / 1GB -as [int]}}
