#Region 1 Parameters
param(
[Parameter(Mandatory=$true)]
[String[]]$computers
)

foreach ($computername in $computers)
{
    $win32CSOut=Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $computers
    $win32OSOut=Get-CimInstance -ClassName win32_operatingsystem -ComputerName $computers

    $paramout=@{'Computername'=$computername;
                'Memory'=$win32CSOut.TotalPhysicalMemory;
                'Free Memory'=$win32OSOut.FreePhysicalMemory;
                'Procs'=$win32CSOut.NumberOfProcessors;
                'Version'=$win32OSOut.Version
               }
        
                $outobj=New-Object -TypeName PSobject -Property $paramout
                Write-Output $outobj
}
#Endregion

