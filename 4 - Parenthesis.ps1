'srv02','srv03' |Out-File C:\temp\computers.txt
"Computername,IPAdress" |Out-File C:\temp\computers.csv
"srv02,192.168.3.10" |Out-File C:\temp\computers.csv -Append
"srv03,192.168.3.100" |Out-File C:\temp\computers.csv -Append
Import-Csv C:\temp\computers.csv
cat C:\temp\computers.txt

#1 Getting names from a TXT file

###### OBSOLETE #######
# command below not working on new Powershell 
get-service -name BITS -computername (get-content C:\temp\computers.txt) ### OBSOLETE COmputernaqme rem oved from ###### OBSOLETE #######

###### IT IS WORKING #######
Get-CimInstance  -ClassName win32_service |where name -EQ BITS # just for local machine
Get-CimInstance -ComputerName (get-content C:\temp\computers.txt) -ClassName win32_service |where name -EQ BITS

#2 Getting names from CSV file. "Select -ExpandProperty" is needed to extract/expand values of ComputerName Column from CSV
## ver.1
Get-CimInstance -ComputerName (Import-Csv C:\temp\computers.csv |select -ExpandProperty Computername) -ClassName win32_service |where name -EQ BITS
## ver.2 - betterest
Get-CimInstance -ComputerName (Import-Csv C:\temp\computers.csv).ComputerName -ClassName win32_service |where name -EQ BITS

# getting service BITS status using AD-Computer / Invoke-Command
invoke-command -ComputerName (Get-ADComputer -filter "name -like '*srv*'" |select -ExpandProperty name) -ScriptBlock {Get-CimInstance  -ClassName win32_service |where name -EQ BITS}