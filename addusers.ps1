Import-Module ActiveDirectory

$Domain="@kk1.fun"
$NewUsersList=Import-CSV "Import_User_Sample_en.csv"
ForEach ($User in $NewUsersList) {
$fullname=$User.'Display Name'
$givenname=$User.'First Name'
$samaccountname=$User.'User Name'
$sn=$User.'Last Name'
$userprincipalname=$User.sAMAccountName+$Domain
$useremail=$User.'User Name'

New-ADUser -PassThru -Path "CN=Users,DC=kk1,DC=fun" -AccountPassword (ConvertTo-SecureString test@1234562 -AsPlainText -Force) -CannotChangePassword $False -DisplayName $fullname -GivenName $givenname -Name $fullname -SamAccountName $samaccountname -Surname $sn -email $useremail -UserPrincipalName $userprincipalname

}

$NewUsersList.foreach({New-ADUser -PassThru -Path "CN=Users,DC=kk1,DC=fun" -AccountPassword (ConvertTo-SecureString test@1234562 -AsPlainText -Force) -CannotChangePassword $False -DisplayName $_.'Display Name' -GivenName $_.'First name'-Name $_.'Display Name' -SamAccountName $_.'User Name' -Surname $_.'Last Name' -email $_.'User Name'+'@kk1.fun' -UserPrincipalName $_.'User Name'+'@kk1.fun'})                             