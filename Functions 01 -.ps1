function Get-Noun{
    [CmdletBinding()]
    Param(
        [parameter(ValueFromPipeline=$true)]
        [String]$MyString
        
            )

            Begin{<#code#> "Begin $mystring"}
            Process{<#code#> "process $mystring"}
            End{<#code#> "end $mystring"}

}