<# Using SWITCHES
used code below to display RAm size in GBs
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceId='$Drive'" -ComputerName $ComputerName |select SystemName,DeviceID,@{n='Size(GB)';e={$_.Size / 1GB -as [int]}},@{n='Free(GB)';e={$_.Freespace / 1GB -as [int]}

#>
param(
    [Parameter(Mandatory=$true)][String]$computername,
    [switch]$showlogprocs)
    if($showlogprocs)
    {
        Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName srv01 | select-object @{n='Logical Processors';e={$_.numberoflogicalprocessors}},@{n='Total RAM';e={$_.TotalPhysicalMemory /1gb -as [int]}}
               
    }
    else {
                <# Action when all if and elseif conditions are false #>
                Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName srv01 | select-object @{n='Processors';e={$_.numberofprocessors}},@{n='Total RAM (GB)';e={$_.TotalPhysicalMemory /1gb -as [int]}}
    }