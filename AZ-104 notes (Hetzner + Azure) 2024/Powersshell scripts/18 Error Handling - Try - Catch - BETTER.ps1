<#
logging errors to Event viewer logs
#>
function Get-Compinfo {
        [CmdletBinding()]
        Param(
                
                [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
                [String[]]$Computername,
                
                # turn on logging
                [Switch[]]$Errorlog,
                [String]$LogFile='c:\temp\errorlog.txt'
        )

                    begin {}
                    Process{
                        foreach($Computer in $Computername) {
                            Try {
                                $os=Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $Computername -ErrorAction Stop -ErrorVariable CurrentError
                                $disk=Get-CimInstance -ClassName Win32_Logicaldisk -ComputerName $Computername -filter "deviceid='c:'"
                                $bios=Get-CimInstance -ClassName win32_bios -ComputerName $Computername

                                $Prop=[ordered]@{
                                    'ComputerName'=$Computer;
                                    'OS Name'=$os.Caption;
                                    'OS Build'=$os.BuildNumber;
                                    'Bios version'=$bios.Version;
                                    'Freespace'=$disk.freespace /1gb -as [int]
                                }
                                $Obj=New-Object -TypeName PSObject -property $Prop
                                Write-Output $Obj
                            }
                            Catch { # it is ran when Try copmmand fails
                                
                                # simple message
                                Write-Warning " you made a mistake with $computer"
                                
                                # logging errors to event logs and a txt file
                                #1 to eventviewer with an error pulled off $currenterror variable
                                ## for this to work Source must be created using a copmmand below - not supported in Powershell 7
                                <# New-EventLog -LogName Application -Source MyApp #>
                                Write-EventLog -LogName Application -Source MyApp -EntryType Error -Message "$currenterror" -EventId 2
                                #2 logging to a file. works if -ErrorLog parameter was specified
                                if ($Errorlog) {
                                    get-date | Out-File $LogFile -Force
                                    $Computer | Out-File $LogFile -Append
                                    $Currenterror | Out-File $LogFile -Append
                                }
                            }
                        }


}
}