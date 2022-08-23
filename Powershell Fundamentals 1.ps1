##### FUNDAMENTALS #####

dir | Sort-Object -descending -Property LastWriteTime

# configuring VS Code to use PS CORE
# C:\Program Files\PowerShell\7
Install-Module az
Get-Process | gm |more

notepad
get-process | Where-Object {$_.name -eq "notepad"}

# as an object
(get-process | Where-Object {$_.name -eq "notepad"}).Kill()
get-process -name notepad
get-process -name notepad |Sort-Object -property name
$procs=Get-Process
$procs[0]
$procs|gm
$procs[0] |gm
get-process | Out-GridView

# sending to clipboard
get-process w* |clip    

# CSV Export
## for is a table
GET-process |Export-Csv proc.csv

## format is a list. PS Custom Object
$procs =import-csv .\proc.csv
$procs | gm

# searching for notepad process and counting number of notepad processes
$procs | where name -eq notepad |measure

# XML export
get-process | Export-Clixml proc.xml
$procs =import-clixml .\proc.xml
$procs|gm ## getting    (TypeName: Deserialized.System.Diagnostics.Process) no kill or other live process methods

# operating on DATA / sorting
get-process | Sort-Object pm -Descending | select-object -first 5
get-process | measure
get-process | gm

# Powershell Core - event logs
Get-WinEvent -LogName Application -MaxEvents 10

# comparing two sets of objects
$procs1=Get-Process
$procs2=Get-Process
Compare-Object -ReferenceObject $procs1 -DifferenceObject $procs2 -Property name
get-process -name *acr* |stop-process

# getting confirmation prompt
$ConfirmPreference="medium"
get-process -Name notepad | stop-process 

## ? is an alias for WHERE-OBJECT
get-process |where name -ne notepad
get-process |? name -ne notepad

## % alias for FOREACH-OBJECT
### import AD module via PSSession on DC
## Session and Enter-Session. 
$password = ConvertTo-SecureString "A241071z123!" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ("kk", $password )
$winrmPort = "8888" # HTTP
$hostname="vm1kk1kk1.uksouth.cloudapp.azure.com"
$soptions = New-PSSessionOption -SkipCACheck

$sess=New-PSSession -ComputerName $hostName -Credential $cred -Port $winrmPort
Get-PSSession # shows the session created and stored in $sess

# Securely propmpt for password. converting password to a plaing text
$name=Read-host "Who are you?"
$pass=Read-Host "What's your password?" -AsSecureString 

### compatible with Powershell 5.1 and 7
[System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))

### Powershell 7 and above
ConvertFrom-SecureString -SecureString $pass -AsPlainText

