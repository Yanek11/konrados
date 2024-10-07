<# Using
Aliases and positions 
#>
param(
    [Parameter(Mandatory=$true,Position=2)][Alias("Friend")][String]$Name,
    [Parameter(Mandatory=$true,position=1)][String]$Greeting)
    Write-Host $Greeting $Name