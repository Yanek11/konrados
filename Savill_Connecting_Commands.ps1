<# 
- start notepad
- getting notepad object and killing it
#>
get-process | where-object {$_.name -like "*notepad*"}
(get-process | where-object {$_.name -like "*notepad*"})
(get-process | where-object {$_.name -like "*notepad*"}).path
