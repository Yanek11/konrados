function t {
    [CmdletBinding()]
Param(
    [Parameter(Mandatory,ValueFromPipelineByPropertyName=$true,position=0)]
    [ValidateScript({test-path $_ })]
    $path
    
)
    begin{}
    process{Get-ChildItem $path} 
    End{}

}