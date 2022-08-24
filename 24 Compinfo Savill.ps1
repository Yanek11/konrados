<#
.SYNOPSIS
Gets information about passed servers
.DESCRIPTION
Gets information about passed servers using WMI
.PARAMETER computer
Names of computers to scan
.EXAMPLE
CompInfo.ps1 host1, host2
Not very interesting
#>
<# adopted code below
@{n='Size(GB)';e={$_.Size / 1GB -as [int]}},@{n='Free(GB)';e={$_.Freespace / 1GB -as [int]}
 Expression={[math]::Round($_.Freespace/1GB,2)}

 'Total RAM' ="{0:N2} GB" -f ($win32CSOut.totalphysicalmemory/1GB -as [Int32]);
 0:N2  (0) - placeholder, colon (:) - formatting style, 2 - decimal places to retain
 letter N lets PowerShell know we want this to be formatted as a numeric value, and to include commas to separate the numbers.
 #>
function CompInfo {
 [cmdletbinding()]
Param(
[Parameter(ValuefromPipeline=$true,Mandatory=$true)][string[]]$computers)
foreach ($computername in $computers)
{
    Write-Verbose "Querying $computername"
    $lookinggood = $true
    try
    {
        $win32CSOut = Get-CimInstance -ClassName win32_computersystem -ComputerName $computername -ErrorAction Stop
    }
    catch
    {
        "Something bad: $_"
        $lookinggood = $false
    }
    if($lookinggood)
    {
        $win32OSOut = Get-CimInstance -ClassName win32_operatingsystem -ComputerName $computername
        Write-Debug "Finished querying $computername"
        $paramout = [ordered]@{'ComputerName'=$computername;
        'Total RAM' ="{0:N2} GB" -f ($win32CSOut.totalphysicalmemory/1GB -as [Int32]);
        #'Memory (GB)'=$win32CSOut.totalphysicalmemory/1GB -as [Int32];
        'Procs'=$win32CSOut.numberofprocessors;
        'Version'=$win32OSOut.version;
        'Free RAM' ="{0:N0} MB" -f ($win32OSOut.freephysicalmemory) 
        #'Free Memory (mb)'=$win32OSOut.freephysicalmemory;
        
    }

        $outobj = New-Object -TypeName PSObject -Property $paramout
        Write-Output $outobj
    }
    else
    {
        Write-Output "Failed for $computername"
    }
}
}