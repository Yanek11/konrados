<#
example changing volume label
using SupportsShouldProcess, adds -WhatIf and -Confirm parameters
users can confirm their choice before executing. USER ARE RESPONSIBLE
#>
<# example of changing label code
$Drive = Get-CimInstance -ClassName Win32_Volume -Filter "DriveLetter = 'c:'"
$Drive | Set-CimInstance -Property @{Label='New label'}
Get-CimInstance -ClassName Win32_Volume -Filter "DriveLetter = 'c:'" |
  Select-Object -Property SystemName, Label, DriveLetter
#>
function Set-VolLabel {
        [CmdletBinding(SupportsShouldProcess=$true,
        ConfirmImpact='Medium')]

        Param(
                
                [Parameter(Mandatory=$true)]
                [String]$Computername,
                [Parameter(Mandatory=$true)]
                [String]$Label
         )
            Process{
                        if ($PSCmdlet.ShouldProcess("$Computername - label change to $Label")) 
                        { 
                             $VolName=Get-CimInstance -ClassName Win32_Volume -filter "Driveletter='c:'" -ComputerName $Computername
                             $Volname | Set-CimInstance -Property @{Label=$Label}
                             # $VolName.Put() | Out-Null <# this method is not working #>
                        }
                    }
                }
