### PARAMETERS and commandlet binding
function get-DiskInfo{
[cmdletbinding()]
param (
    [parameter(Mandatory=$true) ]
[string]$ComputerName,
[string]$Drive='c:'
)
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceId='$Drive'" -ComputerName $ComputerName |select SystemName,DeviceID,@{n='Size(GB)';e={$_.Size / 1GB -as [int]}},@{n='Free(GB)';e={$_.Freespace / 1GB -as [int]}}
}

function get-konrad1{ Write-Output " Fun 1" }
function get-konrad2{ Write-Output " Fun 2" }