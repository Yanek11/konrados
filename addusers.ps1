Import-Module ActiveDirectory

$Domain="@kk1.fun"

$NewUsersList=Import-CSV "aduser.csv"

ForEach ($User in $NewUsersList) {

$fullname="$User.Display name"

$givenname="$User.first name"

$samaccountname="$User.User name"

$sn="$User.Last name"

$userprincipalname=$User.sAMAccountName+$Domain

$useremail="$User.User name"

New-ADUser -PassThru -Path "OU=Users,OU=US,DC=kk1,DC=fun" -AccountPassword (ConvertTo-SecureString test@1234562 -AsPlainText -Force) -CannotChangePassword $False -DisplayName $fullname -GivenName $givenname -Name $fullname -SamAccountName $samaccountname -Surname $sn -email $useremail -UserPrincipalName $userprincipalname

}

                                            