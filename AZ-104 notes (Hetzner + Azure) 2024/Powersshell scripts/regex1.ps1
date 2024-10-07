<#
searching for a string in multiple files
great explanation of begin/Process/End
https://4sysops.com/archives/understanding-powershell-begin-process-and-end-blocks/

#>
function get-string1 {
    [CmdletBinding()]
    Param(
            
            # turn on logging
            [Switch[]]$Errorlog,
            [String]$HTMLLogFile='C:\TRAINING\Scripts\konrados\Logs\log.html',
            [String]$LogFile='c:\temp\errorlog.txt'
    )
    begin{
    $strings=@{}
    # getting all text files. PWD - Print Working Directory
    #$files1=Get-ChildItem "C:\windows\"
    #$files=Get-ChildItem C:\Users\adm1 -filter '*.txt' -recurse
    $files=Get-ChildItem $pwd\files -filter '*.txt'
            }

process {
# populate the hashtable
foreach ($file in $files) 
            {
                try {

                    $string=Select-String "provides(.*)" -Path $file.fullname  -ErrorAction stop -ErrorVariable CurrentError
                    $strings[$file.FullName]=$string.Matches.Groups[0].Value# +" "+ $string.Matches.Groups[0].Length
                    
                    }
                
                catch 
                {
                    #Write-Error " There is an issue witha file:  $file"
                    #Write-EventLog -LogName Application -Source MyApp -EntryType Error -Message "$CurrentError" -EventId 11
                    if ($Errorlog) {
                        #$serialnumber=$file.fullname 
                        $string="missing"
                    $strings[$file.fullName]=$string 
                    #$serialnumbers[$file.basename]
                        <# version 1 -  HTML created by joining two parts but format not great
                        get-date |select-object DateTime| convertto-html| Out-File $htmlLogFile -append
                        $file | select-object name, Directory| convertto-html| Out-File $htmlLogFile -append
                        #>
                        #$datehtml=get-date |select-object DateTime| convertto-html -Fragment 
                        #$filehtml=$file | select-object name, Directory| convertto-html -Fragment
                        

                    }          
                }

            }
             }
    end{
        $strings 
        #$file |gm
        #ConvertTo-Html -Body "$datehtml $filehtml" -Title "File with String Information" | Out-File $HTMLLogFile
        #$logfile.Length # ConvertTo-Html  # Out-File -FilePath $HTMLLogFile
    }
            }