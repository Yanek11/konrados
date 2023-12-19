<#
Adding event logs via PS/script
works ONLY in Powershell 5.1

#>
# creating source - one time
New-EventLog -LogName Application -Source MyApp
# creating test event
Write-EventLog -LogName Application -Source MyApp -EntryType Error -Message "Immunity to iocaine powder not detected, dying now" -EventId 2