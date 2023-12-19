function get-compinfo1 {
[CmdletBinding()]
param(
        # support for multiple computers
        [Parameter(Mandatory=$true)]
        [String]$ComputerName , 
        # switch - turn on Error Logging
        [Switch]$Errorlog,
        [String]$LogFile='C:\temp\errorlog.txt'
    
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
        $os=Get-CimInstance -ComputerName $c -ClassName  Win32_OperatingSystem 
        $disk=Get-CimInstance -ComputerName $c -ClassName win32_logicaldisk -filter "DeviceId='c:'"

            $Prop=[ordered]@{ # [ordered] added to odred a hash table
                'Computername'=$c
                'OS Name'=$os.Caption
                'OS Build'=$os.BuildNumber
                'FreeSpace'=$disk.FreeSpace / 1GB -as [int]
                    }
                    $obj=New-Object -TypeName pscustomobject -Property $Prop 
                    Write-Output $obj

    } 
}
End{}

}