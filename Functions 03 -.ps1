function get-compinfo1 {
[CmdletBinding()]
param(
    [String[]]$ComputerName , # [String[]] indicates multiple arguments/computers
    [Switch]$Errorlog,
    [String]$logfile='C:\temp\errorlog.txt'
)
begin{

if($Errorlog) {
            Write-Verbose 'Error log is turned on'
            } else { Write-Verbose 'Error log is turned OFF'
            }
            ForEach($c in $ComputerName) {
                Write-Verbose "Computer: $c"
            }


}
process{
    foreach($c in $ComputerName){
$os=Get-CimInstance -ComputerName $c -ClassName  Win32_SystemOperatingSystem |select @{n='OS';e={$_.Pscomputername}};
$disk=Get-CimInstance -ComputerName $c -ClassName win32_logicaldisk -filter "DeviceId='c:'" |select DeviceID,@{n='Size(GB)';e={$_.Size / 1GB -as [int]}},@{n='Free(GB)';e={$_.Freespace / 1GB -as [int]}};
$os, $disk


#@{n='OS';e={($os).pscomputername}}, @{n='Disk Size';e={($disk).Size / 1GB -as [int]}},@{n='Free space';e=(($disk).Freespace / 1GB -as [int])}

    }
}
End{}

}