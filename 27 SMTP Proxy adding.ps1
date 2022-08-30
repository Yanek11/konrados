<#  
  .Synopsis  
   Add smtp id to existing active directory user proxyaddress.
  .Description  
   Run this script on domain controller. It will add addition record to proxy addresses in user properties, and keep the existing as it is.
  .Example  
   Add-UserProxyAddress -CSVFile c:\tenp\users.csv
     
   It takes input from CSV file and add the smtp records in respective user proxy address attributes.
  .Example
   CSV file data format and example
   ----------------------------------------------
   | user      | emailid                        |
   | --------------------------------------------
   | ku0f1999  | kunal@vcloud-lab.com           |
   | md0f2011  | mahesh@vcloud-lab.com          |
   ----------------------------------------------
  .OutPuts  
   username ProxyAddresses
   -------- --------------
   {}       {sip:ku0f1999@vcloud-lab.com, SMTP:ku0e1123@testaccount.com, smtp:Kunal@vcloud-lab.com, }
   {}       {sip:md0f2011@vcloud-lab.com, SMTP:md0f2011@testaccount.com, smtp:mahesh@vcloud-lab.com}
   
  .Notes  
   NAME: Add-UserProxyAddress
   AUTHOR: 
   CREATIONDATE: 
   LASTEDIT: 3 February 2017  
   KEYWORDS: Add or update proxyaddress smtp on active directory user account  
  .Link  
   
   #Requires -Version 3.0  
  #>  
#requires -Version 3   
[CmdletBinding()]
param(  
    [Parameter(Mandatory=$true,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$true)]
    [alias('FilePath','File','CSV','CSVPath')]
    [String]$Path,
    [String]$Protocol='SMTP'
)
    #param
Begin {  
    
    
} #Begin

Process {
    $users = Import-Csv -Path $Path -Header 
    #$users = Get-ADUser -Filter * -SearchBase "OU=TestOu,DC=Rageframeworks,DC=com" -Properties ProxyAddresses
    $temp = [System.IO.Path]::GetTempFileName()
    Foreach ($u in $users) {
        #$smtpid = "smtp: {0}.{1}@kumarthegreat.com" -f $u.givenName, $u.Surname
        Try {
            $user = Get-ADUser -Identity $u.user -SearchBase 'OU=Users Disabled,OU=Users,OU=Company,DC=kk1,DC=fun' -ErrorAction Stop
            Write-Host "$($user.SamAccountName) exists, Processing it..." -BackgroundColor DarkGray -NoNewline 
            $emailid = "{1}:{0}" -f $u.emailid, $Protocol
            Set-ADUser -Identity $u.user -Add @{Proxyaddresses=$emailid} 
            Write-Host "...ProxyAddress added" -BackgroundColor DarkGreen
        } #Try
        catch {
            Write-Host "$($user.SamAccountName) does not exists" -BackgroundColor DarkRed
        }
    } 
    #Get-ADUser -Filter * -SearchBase "OU=TestOu,DC=Rageframeworks,DC=com" -Properties ProxyAddresses | select username, ProxyAddresses
    $users | foreach {
        $user = $_.user
        Try {
            Get-ADUser -Identity $_.user -Properties ProxyAddresses -ErrorAction Stop | select SamAccountName, Name, ProxyAddresses
        } #try
        catch {
            Write-Host "$user does not exists" -BackgroundColor DarkRed
        }
    } | Out-File $temp
} #Process
end {
    Notepad $temp
}