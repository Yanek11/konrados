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
    
Get-CimInstance -ComputerName (Import-Csv C:\temp\computers.csv |select -ExpandProperty Computername) -ClassName win32_service |where name -EQ BITS
