<#
.SYNOPSIS
this is synopsis
#>
$ErrorActionPreference
$ComputerName='srv01','srv02','vdc01','dsds','sdsad'

# example 1
Get-CimInstance -ClassName Win32_BIOS -ComputerName $ComputerName -ErrorVariable e

# example 2 - get-process does not support -ComputerName parameter so using get-CimInstance
get-ciminstance -ClassName Win32_Process -ComputerName $ComputerName -ErrorVariable e
$MyError

$e.TargetObject # shows which objects are failing which is helpful if lots of objects are involved

# working on error objects "TargetObject" and "OriginInfo" 
foreach ($t in $e.TargetObject) {$t}
foreach ($t in $e.OriginInfo) {$t.pscomputername} # hostname
foreach ($t in $e) {$t.origininfo.pscomputername,$t.TargetObject} # shows hostname and process failing

#1
# Running variable "$e" containing error message gives standard  error 
$e
<# RESULT 
Get-CimInstance: WinRM cannot process the request. The following error occurred while using Kerberos authentication: Cannot find the computer vdc01. Verify that the computer exists on the network and that the name provided is spelled correctly.
#>

#2
# Running variable with selecting first object in an array and using -Force --> shows lots of details
$e[0] |fl * -Force
<# RESULT
PSMessageDetails      : 
OriginInfo            : vdc01
Exception             : Microsoft.Management.Infrastructure.CimException: WinRM cannot process the request. The following error occurred while using
                        Kerberos authentication: Cannot find the computer vdc01. Verify that the computer exists on the network and that the name provided
                        is spelled correctly.
                           at Microsoft.Management.Infrastructure.Internal.Operations.CimAsyncObserverProxyBase`1.ProcessNativeCallback(OperationCallbackProc
                        essingContext callbackProcessingContext, T currentItem, Boolean moreResults, MiResult operationResult, String errorMessage,
                        InstanceHandle errorDetailsHandle)
TargetObject          : root\cimv2:Win32_BIOS
CategoryInfo          : NotSpecified: (root\cimv2:Win32_BIOS:String) [Get-CimInstance], CimException
FullyQualifiedErrorId : HRESULT 0x80070035,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand
ErrorDetails          : 
InvocationInfo        : System.Management.Automation.InvocationInfo
ScriptStackTrace      : at <ScriptBlock>, <No file>: line 1
PipelineIterationInfo : {0, 1}
#>
