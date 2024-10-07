#region FOREACH VS FOREACH-OBJECT - comparison
<#
https://devblogs.microsoft.com/scripting/getting-to-know-foreach-and-foreach-object/
    ForEach is perfect if you have plenty of memory, want the best performance, and do not care about passing the output to another command via the pipeline.
    ForEach-Object (with its aliases % and ForEach) take input from the pipeline. Although it is slower to process everything, it gives you the benefit of Begin, Process, and End blocks. In addition, it allows you to stream the objects to another command via the pipeline.
#>

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


#endregion

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

$ counting numbers of objects in the array
$names.Count

# FOREACH
ForEach-Object -InputObject (1..100000) {  $_ } |Measure-Object

## measuring time to execute the command
measure-command -expression {ForEach-Object -InputObject (1..10000000) {  $_ } |Measure-Object}

#region example loop and hash table
$array=@()
$processes=Get-Process
foreach($proc in $processes){
    if($proc.WorkingSet/1mb -gt 100)
    {
        #$array+=New-Object pscustomobject -Property @{'ProcessName'=$proc.Name;'WorkingSet (MB)'=$proc.WorkingSet/ 1MB -as [int]}
        $array+=New-Object pscustomobject -Property @{'ProcessName'=$proc.Name;'WorkingSet (MB)'="{0:N0}" -f($proc.WorkingSet/ 1MB -as [int32])}
    }

}
#endregion

#region Another way to filter - faster than a pipeline. COMPARING
# creating a large array
$bigarray2 = @()
Measure-Command -Expression {  @(0..100000).foreach({ $bigArray2 += $_ }) }

###1 pipeline way
## checking it it works
$bigarray |Where-Object {$_ -gt 400 -and $_ -lt 10000} |ForEach-Object {Write-Output "object $_ "} 
## measuring using pipeline 1 sec 750 ms / 1.74 sec
measure-command -Expression{ $bigarray |Where-Object {$_ -gt 400 -and $_ -lt 10000} |ForEach-Object {Write-Output "object $_ "}}
### filtering directly on the array - 21 ms / 0.02 secs - 80 times faster
measure-command -Expression{ $bigarray.({$_ -gt 400 -and $_ -lt 10000}).ForEach({Write-Output "object $_ "})}

#endregion

#region FOREACH example. calculating total value of a column
Import-Csv .\list.csv
$OurObjectArray=Import-Csv .\list.csv

<#
$OurObjectArray | ForEach-Object {
    #Cast properties
    $_.objectpropertynumber = [int]$_.objectpropertynumber
    #Output object
  $_
} 
#>
$totalofnumbercolumn="0"
## version with array filtering 
$OurObjectArray.foreach({write-host "name is "$_.Objectpropertyname ,"colour is "$_.Objectpropertycolour;[int]$totalofnumbercolumn=[int]$totalofnumbercolumn+$_.objectpropertynumber}) 
$totalofnumbercolumn.GetType()

## version with PIPING
$totalofnumbercolumn="0"
$OurObjectArray |ForEach-Object{write-host "name is "$_.objectpropertyname;$totalofnumbercolumn=$totalofnumbercolumn+$_.objectpropertynumber} 
$totalofnumbercolumn.GetType()
$totalofnumbercolumn
#endregion

#region FOREACH example with IF statement added
Import-Csv .\list.csv
$OurObjectArray=Import-Csv .\list.csv
$totalofnumbercolumn="0" # resetting the value
$OurObjectArray |ForEach-Object {
    write-host "name is "$_.objectpropertyname
    $totalofnumbercolumn=$totalofnumbercolumn+$_.objectpropertynumber
        if($_.objectpropertynumber -gt 1000) {
            write-host " this is bigger than 1000" $_.objectpropertyname
        }
                                } 
$totalofnumbercolumn
#endregion
