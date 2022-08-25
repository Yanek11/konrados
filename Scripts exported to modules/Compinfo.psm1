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
 https://stackoverflow.com/questions/24616806/powershell-display-files-size-as-kb-mb-or-gb
 https://ss64.com/ps/syntax-f-operator.html
 https://www.tachytelic.net/2019/10/thousands-separators-powershell/
 https://devblogs.microsoft.com/scripting/use-powershell-and-conditional-formatting-to-format-numbers/
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
        
        'Procs'=$win32CSOut.numberofprocessors;
        'Version'=$win32OSOut.version;
        'Free RAM' ="{0:N0} MB" -f ($win32OSOut.freephysicalmemory) ;
        
        # not working correctly
        #'Free RAM 2' =( Format-Bytes $win32OSOut.freephysicalmemory) 
        #'Memory (GB)'=$win32CSOut.totalphysicalmemory/1GB -as [Int32];
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


<#
Function Format-Bytes {
    Param
    (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [float]$number
    )
    Begin{
        $sizes = 'KB','MB','GB','TB','PB'
    }
    Process {
        # New for loop
        for($x = 0;$x -lt $sizes.count; $x++){
            if ($number -lt [int64]"1$($sizes[$x])"){
                if ($x -eq 0){
                    return "$number B"
                } else {
                    $num = $number / [int64]"1$($sizes[$x-1])"
                    $num = "{0:N0}" -f $num
                    return "$num $($sizes[$x-1])"
                }
            }
        }
        <# Original way
        if ($number -lt 1KB) {
            return "$number B"
        } elseif ($number -lt 1MB) {
            $number = $number / 1KB
            $number = "{0:N2}" -f $number
            return "$number KB"
        } elseif ($number -lt 1GB) {
            $number = $number / 1MB
            $number = "{0:N2}" -f $number
            return "$number MB"
        } elseif ($number -lt 1TB) {
            $number = $number / 1GB
            $number = "{0:N2}" -f $number
            return "$number GB"
        } elseif ($number -lt 1PB) {
            $number = $number / 1TB
            $number = "{0:N2}" -f $number
            return "$number TB"
        } else {
            $number = $number / 1PB
            $number = "{0:N2}" -f $number
            return "$number PB"
        }
        #>
 #   }
  #  End{}
#}
#>