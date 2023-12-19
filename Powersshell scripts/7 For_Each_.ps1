
$services=get-service -name b*
foreach ($s in $services) {
    $s.DisplayName
    }
# For Loop

for ($i=0;$i -lt 5;$i++) { 
    Write-Output "For Loop $i"
 }

 # Range operator
 1..30 | foreach-object -process { start calc
 }