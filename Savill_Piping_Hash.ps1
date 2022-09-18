<# 
- start notepad
- getting notepad object and killing it
#>
get-process | where-object {$_.name -like "*notepad*"}
(get-process | where-object {$_.name -like "*notepad*"})
(get-process | where-object {$_.name -like "*notepad*"}).path
(get-process | where-object {$_.name -like "*notepad*"}).Kill()
<# BAD wastefull method.
 getting all processes then sorting them then selecting only one
#>
get-process | sort-object -Property name |where-object {$_.name -like "*notepad*"}
<# more EFFICIENT method
 selecting process first then sorting 
 #>
get-process -Name notepad,notepad++ |Sort-Object -Property CPU

<# killing notepad processes #>
get-process -name notepad,notepad++ |Stop-Process -WhatIf
<# output
What if: Performing the operation "Stop-Process" on target "notepad (3836)".
What if: Performing the operation "Stop-Process" on target "notepad (6088)".
What if: Performing the operation "Stop-Process" on target "notepad++ (6160)".
#>
<# working with normal commands using SELECT-STRING 
IPCONFIG
#>
ipconfig |gm
ipconfig |select-string -Pattern ipv4

# using variables
$procs=get-process
$procs[0..2] # showing first 3 in the array
$procs[0] # showing first one

# formatting the output
$procs |fl #list
$procs | format-wide
$procs | ft | ConvertTo-Html -Property | Out-File -FilePath t1.html
$procs |gm
# creating new properties by using hash tables
get-process | select-object -Property name, @{name='procID';expression={$_.id}} |more
# piping and sorting
Get-Process | Where-Object {$_.Handle -gt 5000} | sort-object -Property Handle | ft name,Handle -AutoSize
