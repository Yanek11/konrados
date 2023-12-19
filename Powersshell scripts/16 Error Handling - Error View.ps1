<#
.SYNOPSIS
this is synopsis
#>
dir variable:
dir Variable:\? 
dir Variable:\ErrorView
dir Variable:*error*
<# result
Name                           Value
----                           -----
Error                          {Cannot find path 'ErrorView\parameter' because it does not exist., Cannot call method. The provider does not support the use…
ErrorActionPreference          Continue
ErrorView                      ConciseView
Errorlog                       False
MyError                        {HRESULT 0x80070035,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand}
#>

### changing way the errors are shown
$ErrorView="categoryview" # changing to categoty view
Sesdgsdfgdsf # some command causing error
<# RESULT
PS C:\TRAINING\Scripts\konrados> Sesdgsdfgdsf
ObjectNotFound: (Sesdgsdfgdsf:String) [], CommandNotFoundException
#>
stop-process -Id 11111

$ErrorView="normalview" # changing back to normal
<#
stop-process -Id 11111
stop-process : Cannot find a process with the process identifier 11111.
At line:1 char:1
+ stop-process -Id 11111
+ ~~~~~~~~~~~~~~~~~~~~~~
+ CategoryInfo          : ObjectNotFound: (11111:Int32) [Stop-Process], ProcessCommandException
+ FullyQualifiedErrorId : NoProcessFoundForGivenId,Microsoft.PowerShell.Commands.StopProcessCommand
#>