########## VARIOUS COMMANDS and TIPS

<# 
- start notepad
- getting notepad object and killing it
#>
get-process | where-object {$_.name -like "*notepad*"}
(get-process | where-object {$_.name -like "*notepad*"})
(get-process | where-object {$_.name -like "*notepad*"}).path
(get-process | where-object {$_.name -like "*notepad*"}).Kill()
<# BAD wastefull method.
 getting all processes then sorting them then selecting only one
#>
get-process | sort-object -Property name |where-object {$_.name -like "*notepad*"}
<# more EFFICIENT method
 selecting process first then sorting 
 #>
get-process -Name notepad,notepad++ |Sort-Object -Property CPU

<# killing notepad processes #>
get-process -name notepad,notepad++ |Stop-Process -WhatIf
<# output
What if: Performing the operation "Stop-Process" on target "notepad (3836)".
What if: Performing the operation "Stop-Process" on target "notepad (6088)".
What if: Performing the operation "Stop-Process" on target "notepad++ (6160)".
#>
<# working with normal commands using SELECT-STRING 
IPCONFIG
#>
ipconfig |gm
ipconfig |select-string -Pattern ipv4

# using variables
$procs=get-process
$procs[0..2] # showing first 3 in the array
$procs[0] # showing first one

# formatting the output
$procs |fl #list
$procs | format-wide
$procs | ft | ConvertTo-Html -Property | Out-File -FilePath t1.html
$procs |gm
# creating new properties by using hash tables
get-process | select-object -Property name, @{name='procID';expression={$_.id}} |more
# piping and sorting
Get-Process | Where-Object {$_.Handle -gt 5000} | sort-object -Property Handle | ft name,Handle -AutoSize

# redirecting output to files/clipboard
get-process w* | clip
get-alias del
get-process | Out-File procs.txt
get-process | Out-GridView # kind of GUI version
get-process | Out-GridView -PassThru |Stop-Process # using GUI to kill the process

Get-Content -Path .\procs.txt |gm
cat .\procs.txt
Remove-Item .\procs.txt

#region DATA Exporting and Importing
### CSV ###
get-process |where-object {$_.name -like "m*"} |export-csv -Path test_csv.csv 
get-process |where-object {$_.name -like "m*"} |Export-Clixml -Path test_xml.xml
Import-Csv -Path test_csv.csv # imports as a Custom PS Object System.Management.Automation.PSCustomObject
# how can we use export/import
get-process |export-csv -Path test_csv.csv 
$procs=Import-Csv -Path test_csv.csv

$procs |where-object {$_.name -like "*note*"} |stop-process -PassThru #kills notepad process and shows status -passthru
<# COMMENTS
Stop-Process accepts ID, Name and Object
what happens if there is a notepad process with different ID / new instance?!
$procs |where-object {$_.name -like "*note*"} |stop-process -PassThru 
command works as Stop-Process took name of the process as input
#> 
#endregion

### XML
get-process |Where-Object {$_.name -like "*run*"} |Export-Clixml -Path test_xml.xml
Import-Clixml -Path test_xml.xml 
$procs=Import-Clixml -Path test_xml.xml 
$procs |gm
# output is Deserialized object
TypeName: Deserialized.System.Diagnostics.Process

get-process |Measure-Object
get-process | gm |more
get-process | sort ws -Descending |select -First 2
Get-WinEvent -LogName security -MaxEvents 1
ping srv02
invoke-command -ComputerName srv02,SRV03 -ScriptBlock {Get-WinEvent -LogName application -MaxEvents 1}

# Ethernet adapters
Get-NetAdapter
## disabling 
invoke-command -ComputerName srv02 -ScriptBlock {get-netadapter |Disable-NetAdapter }
# VM1 update
LAPTOP update



