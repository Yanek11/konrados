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

#Region 2 Error handling
Get-Content -path c:\sdfs.sds -ErrorVariable BadThings
$BadThings
if($BadThings)
{
    Write-Host -ForegroundColor blue -BackgroundColor Yellow "Had an issue, $($BadThings.exception)"
}
#Endregion

#Region 3 Try-Catch 
<# Try-Catch is catching a TERMINATING ERROR #>

try {
    
    dsds -Path c:\sdfdfd
}
catch {
    Write-Output "something went wrong"
}
#Endregion

#Region 4 Try-Catch with ErrorAction
<# Try-Catch is catching a TERMINATING ERROR #>

try {
    
    Get-Content -Path c:\sdfdfd -ErrorAction Stop
}
catch {
    Write-Output "something went wrong"
}
#Endregion

#Region 5 Try-Catch Types of  ErrorAction
<# Try-Catch is catching a TERMINATING ERROR  -ErrorAction Stop or SilentlyContinue #>

Get-Content -Path c:\sdfdfd -ErrorAction SilentlyContinue
Get-Error
#Endregion

#Region 6 - Try-Catch Types of  ErrorAction
try
{    get-content -path c:\temp\adas.sdsd -ErrorAction stop  }
catch 
{
    $ErrorMessage=$_.Exception.Message
    Write-Output " something wrong - $ErrorMessage"
    Write-Host -ForegroundColor blue -BackgroundColor white $_.Exception
    $PSItem.InvocationInfo |Format-List * # $_. can also  be used instead of $PSItem

}

#Endregion

#Region 7 - Types of Catch
try
{
sdfsdfs
}
catch [System.Management.Automation.commandnotfoundexception]
{
    Write-Output "no idea what this command"   
}
catch 
{
    $_.Exception
}
#Endregion

#Region 8 - ErrorActionPreference Finally IS NOT WORKING
<# Finally IS NOT WORKING #>
try {
    $CurrenterroractionPreference=$ErrorActionPreference
    $ErrorActionPreference="stop"
    get-content -path r:\dsds
} 
catch
{
    write-output "sometyhing went wrong"
    write-host -ForegroundColor yellow -BackgroundColor white $_.Exception
}

# Finally - this code will always execute
Finally {
    $ErrorActionPreference=$CurrenterroractionPreference
}
#Endregion

#Region 9 - cmd.exe Errors handling. 

#cmd writes to its own stream
$executionoutput=Invoke-Expression "cmd.exe /c dir r:\dfdf"
$executionoutput
# $executionoutput shows NO RESULT

#cmd writes to STDOUT. STDERR (2) ->STDOUT (1)
$executionoutput=Invoke-Expression "cmd.exe /c dir r:\dfdf 2>&1"
$executionoutput
# $executionoutput output is : "The system cannot find the path specified."
#Endregion