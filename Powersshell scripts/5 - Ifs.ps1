# IFs
if ($this -eq $that) {
    #commands 1
} elseif ($those -ne $them) {
    <# Action when this condition is true #>
} elseif ( $we -gt $they) {
    <# Action when this condition is true #>
} else {
# commands
}



# SWITCH 
## ver 1
$status=2
switch ($status) {
0 {$status_text='OK'}
1 {$status_text='NOT OK'}
2 {$status_text='ALWAYS  OK'}
3 {$status_text='blasted'}
4 {$status_text='NULL'}
default {$status_text='UNKNOWN'}
}
$status_text

## ver 2 - simpler and more concise
$status=3
$status_text= switch ($status) {
0 {'OK'}
1 {'NOT OK'}
2 {'ALWAYS  OK'}
3 {'blasted'}
4 {'NULL'}
default {'UNKNOWN'}
}
$status_text

  