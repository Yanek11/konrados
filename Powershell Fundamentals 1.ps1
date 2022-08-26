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

#Region ## VAR TYPES ### 
$number=42
$boolset=$true
$stringval="hello"
$charval='a'
$number.GetType

$charval='a'
$charval.GetType() # returns String instead of Char
[char]$charval='a' # casting type of Char on $ charval
$charval.GetType() # returns 
<#
IsPublic IsSerial Name                                     BaseType
-------- -------- ----                                     --------
True     True     Char                                     System.ValueType
#>
#endregion

#Region STRINGS

$str1="word1"
$str2="word2"
$str3=$str1 +" "+ $str2
<#
$match=Select-String "This (is)" -InputObject "This is a string"
 $match.Matches.Groups[0].value # shows" This is"
 $match.Matches.Groups[1].value # shows first capture group "is"
#> 

<# example file computer.txt
BiosCharacteristics={7,11,12,15,16,19,20,21,22,23,24,25,27,30,32,33,39,40,42,43}
 BIOSVersion={"ACRSYS - 2","V1.15","INSYDE Corp. - 59040115"}
 BuildNumber=
 Caption=V1.15
 CodeSet=
 CurrentLanguage=
 Description=V1.15
 EmbeddedControllerMajorVersion=1
 EmbeddedControllerMinorVersion=15
 IdentificationCode=
 InstallableLanguages=
 InstallDate=
 LanguageEdition=
 ListOfLanguages=
 Manufacturer=Insyde Corp.
 Name=V1.15
 OtherTargetOS=
 PrimaryBIOS=TRUE
 ReleaseDate=20200826000000.000000+000
 SerialNumber=NXHHYSA4241943017724S00
 SMBIOSBIOSVersion=V1.15
 SMBIOSMajorVersion=3
 SMBIOSMinorVersion=2
 SMBIOSPresent=TRUE
 SoftwareElementID=V1.15
 SoftwareElementState=3
 Status=OK
 SystemBiosMajorVersion=1
 SystemBiosMinorVersion=15
 TargetOperatingSystem=0
 Version=ACRSYS - 2


#>
#endregion

