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
                            Catch {
                                Write-Warning " you made a mistake with $computer"
                                if ($Errorlog) {
                                    get-date | Out-File $LogFile -Force
                                    $Computer | Out-File $LogFile -Append
                                    $Currenterror | Out-File $LogFile -Append
                                }
                            }
                        }


}
}