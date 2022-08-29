 <#
 WORKING SCRIPT
 adding users to AD from CSV
 changing email address
Issues:
- 'SamAccountName' format must match DOMAIN\USER(firstname.surname)  format. - DONE
- 'UserPrincipalName' format must match SamAccountName@DOMAIN format. - DONE
- 'EmailAddress' value must be equal to 'UserPrincipalName@kk1.fun

 #>
#region AD objects - user related
DisplayName=GivenName Surname
DistinguishedName=CN....
EmailAddress= same as UserPrincipalName
GivenName (First Name)
Name=GivenName Surname
SamAccountName = DOMAIN\GivenName.Surname
Surname
UserPrincipalName
 #endregion

################## ADDING USERS ###################
#region
 distinguishedName OU=Users New,OU=Users,OU=Company,DC=kk1,DC=fun

 $NewUsersList=Import-CSV "Import_User_Sample_en.csv"
 $NewUsersList.foreach({New-ADUser -PassThru -Path "CN=Users,DC=kk1,DC=fun" -AccountPassword (ConvertTo-SecureString test@1234562 -AsPlainText -Force) -CannotChangePassword $False -DisplayName $_.'Display Name' -GivenName $_.'First name'-Name $_.'Display Name' -SamAccountName $_.'User Name' -Surname $_.'Last Name' -email ($_.'User Name'+'@kk1.fun') -UserPrincipalName ($_.'User Name'+'@kk1.fun') })

# checking if OK
 $NewUsersList.foreach({get-ADUser -fil -SamAccountName $_.'User Name' -Surname $_.'Last Name' -email ($_.'User Name'+'@kk1.fun') -UserPrincipalName ($_.'User Name'+'@kk1.fun') })
#endregion

################## FIXING INCORRECT UserPrincipalName ###################
#region REGEX finding incorrect values with multiple @s - "@kk1.fun@kk1.fun"
## 1st try - testing
$testtext='sds@kk1.fun@kk1.fun'
$pattern='(?<=\@).+?(?=\@)'
[regex]::Matches($testtext,$pattern).success
[regex]::Matches($testtext,$pattern).value
# result kk1.fun

## 2nd try - finds duplicate @ characters but skips correct email format 
    <#testing 
    $testtext='sds@kk1.fun'
    $pattern='(?<=\@).+?'
    [regex]::Matches($testtext,$pattern).success
    #>
## it is not possible to use Regex withing -Filter in Get-ADUser. 
#So we need to pipe the result of Get-ADUser to ForEach/%
#$pattern='(?i)\b([A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4})\b+@'

# command fixes the UserPrincipalName problem :)
$pattern='(?<=\@).+?'
$users = Get-ADUser -filter *  -SearchBase 'OU=Users Disabled,OU=Users,OU=Company,DC=kk1,DC=fun'
$users |ForEach-Object { if($_.UserPrincipalName -match $pattern) { set-aduser $_ -UserPrincipalName ($_.GivenName+'.'+$_.Surname)  } }
#endregion

#region ################### FIXING INCORRECT SamAccountName ###################
# some accounts have @kk1.fun in SamAccountName
# selecting accounts
$testtext='sds@kk1.fun'
$pattern='(?<=\@).+?'
[regex]::Matches($testtext,$pattern).success
[regex]::Matches($testtext,$pattern).value

# filtering disabled users 
distinguishedName OU=Users Disabled,OU=Users,OU=Company,DC=kk1,DC=fun
#1
$users = Get-ADUser -filter *  -SearchBase 'OU=Users Disabled,OU=Users,OU=Company,DC=kk1,DC=fun'
$pattern='(?i)\b([A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4})\b+@'  #finds duplicate @ characters but skips correct email format 
# testing on one user
$users | ?{$_.SamAccountName -match $pattern -and $_.SamAccountName -eq 't@kk1.fun' }
$users # shows a list of accounts with incorrect values
$users.foreach({    set-aduser $_ -SamAccountName ($_.name+'.'+$_.Surname) })

$NewUsersList.foreach({New-ADUser -PassThru -Path "CN=Users,DC=kk1,DC=fun" -AccountPassword (ConvertTo-SecureString test@1234562 -AsPlainText -Force) -CannotChangePassword $False -DisplayName $_.'Display Name' -GivenName $_.'First name'-Name $_.'Display Name' -SamAccountName $_.'User Name' -Surname $_.'Last Name' -email ($_.'User Name'+'@kk1.fun') -UserPrincipalName ($_.'User Name'+'@kk1.fun') })

# filtering disabled users 
distinguishedName OU=Users Disabled,OU=Users,OU=Company,DC=kk1,DC=fun
#1
$users = Get-ADUser -filter *  -SearchBase 'OU=Users Disabled,OU=Users,OU=Company,DC=kk1,DC=fun'
#optional - searching for just one test user
$users | ?{$_.SamAccountName -match $pattern -and $_.SamAccountName -eq 't@kk1.fun' }
# filtering users where SamAccountName contains '@'
#2
$pattern='(?<=\@).+?' # contains @
#3
$users | ?{$_.SamAccountName -match $pattern } 
# optional
$users | ?{$_.SamAccountName -match $pattern } |measure # returns 4
# fixed all users to correct format of SamAccountName
#4
$users |ForEach-Object { if($_.SamAccountName -match $pattern) { set-aduser $_ -SamAccountName ($_.GivenName+'.'+$_.Surname)  } }
#endregion

################### UDPATING EMAIL ###################