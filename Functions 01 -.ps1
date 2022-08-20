function Get-Noun{
    [CmdletBinding()]
    Param(
        [parameter(ValueFromPipeline=$true)]
        [int]$x
        
            )

            Begin{<#code#> $total=0}
            Process{<#code#> $total+=$x}
            End{<#code#> "total=$total"}

}

# execute the script
# 1..3 | get-noun -> result 6