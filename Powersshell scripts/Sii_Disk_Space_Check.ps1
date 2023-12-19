#region Disk Space Reports
<# notes
- servers: 8 x Windows 2016 servers
- 1 report file per server created daily (@ 00:00 hrs) "DiskReport_SERVERNAME_CURRENTDATE"
- script executes every 1H - 00:00, 01:00, 02:00 ... 23:00
- connect to server
- list volumes C and D
- if free disk space < 25% - WARNING
- if free disk space < 15% - CRITICAL
- append results to file "DiskReport_SERVERNAME_CURRENTDATE"

#>
#endregion
# RESULT
# Computername OS Name                                             OS Build FreeSpace
#------------ -------                                             -------- ---------
#srv01        Microsoft Windows Server 2019 Datacenter Evaluation 17763           25
#srv02        Microsoft Windows Server 2019 Datacenter Evaluation 17763           28
#srv03        Microsoft Windows Server 2019 Datacenter Evaluation 17763           28
<# OLD script
function get-diskspace1 {
    [CmdletBinding()]
    param(
        [String[]]$ComputerName , # [String[]] indicates multiple arguments/computers
        [Switch]$Errorlog,
        [String]$logfile='C:\temp\getdiskspace1log.txt'
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
            $diskC=Get-CimInstance -ComputerName $c -ClassName win32_logicaldisk -filter "DeviceId='c:'"
            $diskD=Get-CimInstance -ComputerName $c -ClassName win32_logicaldisk -filter "DeviceId='d:'"

                $Prop=[ordered]@{ # [ordered] added to a hash table
                    'Computername'=$c
                    'OS Name'=$os.Caption
                    'OS Build'=$os.BuildNumber
                    'FreeSpace'=$diskC.FreeSpace / 1GB -as [int]
                    
                        }
                        $obj=New-Object -TypeName pscustomobject -Property $Prop 
                        Write-Output $obj
    
        } 
    }
    End{}
    
    }
    #>
#region new script
$Machine = @("srv01", "srv02", "srv03")
Get-CimInstance Win32_LogicalDisk -ComputerName $Machine -Filter "DriveType = '3'" -ErrorAction SilentlyContinue | 
Select-Object @{N = 'PSComputerName'; E = { $_.PSComputerName + " : Description" }}, 
    DeviceID, 
    @{N="Disk Size (GB) ";e={[math]::Round($($_.Size) / 1073741824,0)}}, 
    @{N="Free Space (GB)";e={[math]::Round($($_.FreeSpace) / 1073741824,0)}}, 
    @{N="Free Space (%)";e={[math]::Round($($_.FreeSpace) / $_.Size * 100,1)}} | 
Sort-Object -Property 'Free Space (%)' <# | 
ConvertTo-Html -Head $Head -Title "$Title" -PreContent "<p><font size=`"6`">$Title</font><p>Generated on $date</font></p>" > $HTML
#>

