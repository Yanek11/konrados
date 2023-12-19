
############  SII Scripts ############
<# GOALS - monitoring scripts

1.
- disk space - low
    - warning if disk space below 30%
    - check every hour 
2.    
- services with "Automated Start" - failing
    - if rebooted/restarted wait 30 minutes before checking the status
    - warning if any "Automated Start" services fails
3.
- CPU / RAM - maxing out 
    -  CPU: 75% or more usage for more than 5 mins - WARNING
    -  CPU: 90% or more usage for more than 5 mins - CRITICAL

    -  RAM: 75% or more usage for more than 5 mins - WARNING
    -  RAM: 90% or more usage for more than 5 mins - CRITICAL
4.
- PS backup scripts - if files were copied
    - check if files (?) were created during recent schedule run
        - 
#>
<# DETAILS / NOTES
scripts will be ran on a virtual desktop

TBC
schedule: ran automatically or triggered manually by engineer 
ran as service? 
scripts reports to be uploaded to a folder on share accessible by Patryk and me


#>
#region Disk Space Reports
<# notes
- servers: 8 x Windows 2016 servers
- 1 report file per server created daily (@ 00:00 hrs) "DiskReport_SERVERNAME_CURRENTDATE"
- script executes every 1H - 00:00, 01:00, 02:00 ... 23:00
- connect to server
- list volumes C and D
- if free disk space < 25% - WARNING
- if free disk space < 15% - CRITICAL
- append results to file "DiskReport_SERVERNAME_CURRENTDATE"

#>
#endregion

#region Services "Automated Start" check 
<# NOTES / DETAILS
- 1 report file per server created daily (@ 00:00 hrs) "ServicesReport_SERVERNAME_CURRENTDATE"
- script executes every 1H - 00:00, 01:00, 02:00 ... 23:00
- connect to server
- check "Automated Start" services status
- if status "not Running" once in 24 hours - WARNING
- if status "not Running" more than once per 24 hours - CRITICAL
- append results to file "ServicesReport_SERVERNAME_CURRENTDATE"

#>

#endregion
