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
            [String]$HTMLLogFile='c:\temp\errorlog.html',
            [String]$LogFile='c:\temp\errorlog.txt'
    )
    begin{
    $serialnumbers=@{}
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

                    $serialnumber=Select-String "provides(.*)" -Path $file.fullname  -ErrorAction stop -ErrorVariable CurrentError
                    $serialnumbers[$file.basename]=$serialnumber.Matches.Groups[0].Value 
                    
                    }
                
                catch 
                {
                    #Write-Error " There is an issue witha file:  $file"
                    #Write-EventLog -LogName Application -Source MyApp -EntryType Error -Message "$CurrentError" -EventId 11
                    if ($Errorlog) {
                        #$serialnumber=$file.fullname 
                        $serialnumber="missing"
                    $serialnumbers[$file.basename]=$serialnumber 
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
        $serialnumbers|ft -AutoSize
        #$file |gm
        #ConvertTo-Html -Body "$datehtml $filehtml" -Title "File with String Information" | Out-File $HTMLLogFile
        #$logfile.Length # ConvertTo-Html  # Out-File -FilePath $HTMLLogFile
    }
            }