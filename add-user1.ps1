 <#
 WORKING SCRIPT
 adding users to AD from CSV
 changing email address
 #>
 ################### ADDING USERS ###################
 $NewUsersList=Import-CSV "Import_User_Sample_en.csv"
 $NewUsersList.foreach({New-ADUser -PassThru -Path "CN=Users,DC=kk1,DC=fun" -AccountPassword (ConvertTo-SecureString test@1234562 -AsPlainText -Force) -CannotChangePassword $False -DisplayName $_.'Display Name' -GivenName $_.'First name'-Name $_.'Display Name' -SamAccountName $_.'User Name' -Surname $_.'Last Name' -email ($_.'User Name'+'@kk1.fun') -UserPrincipalName ($_.'User Name'+'@kk1.fun') })

# checking if OK
 $NewUsersList.foreach({get-ADUser -fil -SamAccountName $_.'User Name' -Surname $_.'Last Name' -email ($_.'User Name'+'@kk1.fun') -UserPrincipalName ($_.'User Name'+'@kk1.fun') })

 ################### FINDING INCORRECT UserPrincipalName ###################
#region REGEX finding incorrect values - "@kk1.fun@kk1.fun"
## 1st try
$testtext='sds@kk1.fun@kk1.fun'
$pattern='(?<=\@).+?(?=\@)'
[regex]::Matches($testtext,$pattern).success
[regex]::Matches($testtext,$pattern).value
# result kk1.fun

## 2nd try - finds duplicate @ characters but skips correct email format 
$testtext='sds@kk1.fun@fff@'
$pattern='(?i)\b([A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4})\b+@'
[regex]::Matches($testtext,$pattern).value

# it is not possible to use Regex withing -Filter in Get-ADUser. 
#So we need to pipe the result of Get-ADUser to ForEach/%
$pattern='(?i)\b([A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4})\b+@'
$users = Get-ADUser -filter *  -properties UserPrincipalName | ?{$_.UserPrincipalName -match $pattern}
$users # shows a list of accounts with incorrect UserPrincipalName 



