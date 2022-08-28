#region Synopsis template 
<# HASH TABLES
.SYNOPSIS

.DESCRIPTION

.PARAMETER computer

.EXAMPLE

#>
#endregion

#region example code for hash tables
<# adopted code below
@{n='Size(GB)';e={$_.Size / 1GB -as [int]}},@{n='Free(GB)';e={$_.Freespace / 1GB -as [int]}
 Expression={[math]::Round($_.Freespace/1GB,2)}

 'Total RAM' ="{0:N2} GB" -f ($win32CSOut.totalphysicalmemory/1GB -as [Int32]);
 0:N2  (0) - placeholder, colon (:) - formatting style, 2 - decimal places to retain
 letter N lets PowerShell know we want this to be formatted as a numeric value, and to include commas to separate the numbers.
 https://stackoverflow.com/questions/24616806/powershell-display-files-size-as-kb-mb-or-gb
 https://ss64.com/ps/syntax-f-operator.html
 https://www.tachytelic.net/2019/10/thousands-separators-powershell/
 https://devblogs.microsoft.com/scripting/use-powershell-and-conditional-formatting-to-format-numbers/
 #>
 #endregion
#region function template
<# Function template
 function CompInfo {
 [cmdletbinding()]
Param(
[Parameter(ValuefromPipeline=$true,Mandatory=$true)][string[]]$computers)
#>
#endregion

# simple hash table
$favthings=@{"Julie"="Sushi";"Ben"="Trains";"Abby"="Princess";"Kevin"="Minecraft"}
$favthings.add("John","Crab cakes")
$favthings.set_item("John","chips")

# creating CustomObject 
$cusobj=New-object PSObject 
Add-Member -InputObject $cusobj -MemberType NoteProperty -Name greeting -value "hello"

# creating CustomObject from a hashtable
## old way
$favobj=New-Object psobject -Property $favthings
## new way PS 3 or newer
$favobj2=[PSCustomObject]@{"Julie"="Sushi";"Ben"="Trains";"Abby"="Princess";"Kevin"="Minecraft"}


# FOREACH and ARRAY
$names=@("Julie","Abby","ben","Kevin")

## expressions below give the same result ##
###1
$names | ForEach-Object -process {Write-Output $_}
###2
$names | ForEach-Object -process {Write-Output $PSItem}
###3
$names | ForEach {Write-Output $_}
###4
$names | % {Write-Output $_}