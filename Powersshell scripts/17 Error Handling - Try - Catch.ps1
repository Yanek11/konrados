<#
try something and stop if there is an error
then Catch { some commands } will kick in
#>
$computer='asas'
try {
    
    $os=Get-CimInstance -ComputerName $computer -classname Win32_OperatingSystem -ErrorAction stop -ErrorVariable CurrentError
}
catch {
    Test-netConnection -ComputerName $computer;    ($currenterror)
}
<# RESULT

WARNING: Name resolution of asas failed

ComputerName   : asas
RemoteAddress  : 
InterfaceAlias : 
SourceAddress  : 
PingSucceeded  : False


ErrorRecord                 : WinRM cannot process the request. The following error occurred while using Kerberos authentication: Cannot find the computer
                              asas. Verify that the computer exists on the network and that the name provided is spelled correctly.
WasThrownFromThrowStatement : False
TargetSite                  : Void CheckActionPreference(System.Management.Automation.Language.FunctionContext, System.Exception)
Message                     : The running command stopped because the preference variable "ErrorActionPreference" or common parameter is set to Stop: WinRM
                              cannot process the request. The following error occurred while using Kerberos authentication: Cannot find the computer asas.
                              Verify that the computer exists on the network and that the name provided is spelled correctly.
Data                        : {System.Management.Automation.Interpreter.InterpretedFrameInfo}
InnerException              : 
HelpLink                    : 
Source                      : System.Management.Automation
HResult                     : -2146233087
StackTrace                  :    at System.Management.Automation.ExceptionHandlingOps.CheckActionPreference(FunctionContext funcContext, Exception exception)
                                 at System.Management.Automation.Interpreter.ActionCallInstruction`2.Run(InterpretedFrame frame)
                                 at System.Management.Automation.Interpreter.EnterTryCatchFinallyInstruction.Run(InterpretedFrame frame)
                                 at System.Management.Automation.Interpreter.EnterTryCatchFinallyInstruction.Run(InterpretedFrame frame)

#>