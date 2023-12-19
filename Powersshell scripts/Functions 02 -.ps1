function get-compinfo {
[CmdletBinding()]
param(
    [String[]]$ComputerName , # [String[]] indicates multiple arguments/computers
    [Switch]$Errorlog,
    [String]$logfile='C:\temp\errorlog.txt'
)
begin{}
process{get-process}
End{}

}