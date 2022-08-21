## Example
# $d=(get-date).AddDays(-1)
# t -EventDate $d - returns FALSE
# $d=(get-date).AddDays(+2)
# t -EventDate $d - returns TRUE

# (get-date).add(-1) - substract one day
function t {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName=$true,position=0)]
    [ValidateScript({$_ -ge (Get-Date)})]
        [DateTime]
        $EventDate
    )
begin {}
process {}
end {}

}
