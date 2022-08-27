<#
searching for a string in multiple files
#>
function get-string1
{
# hashtable holding all found strings
$serialnumbers=@{}

# getting all text files. PWD - Print Working Directory
$files=Get-ChildItem "$pwd\Files\"

# populate the hashtable
foreach ($file in $files) {

    $serialnumber=Select-String "provides(.*)" -Path $file.fullname
    $serialnumbers[$file.basename]=$serialnumber.Matches.Groups[0].Value

}
$serialnumbers|ft -AutoSize

}