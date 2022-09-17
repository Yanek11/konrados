
############  SII Scripts ############
<#
GOAL:
- disk space - low
    - warning if disk space below 30%
    - check every hour 
    
- services with "Automated Start" - failing
    - if rebooted/restarted wait 30 minutes before checking the status
    - warning if any "Automated Start" services fails

- CPU / RAM - maxing out 
    -  CPU: 75% or more usage for more than 5 mins - WARNING
    -  CPU: 90% or more usage for more than 5 mins - CRITICAL

    -  RAM: 75% or more usage for more than 5 mins - WARNING
    -  RAM: 90% or more usage for more than 5 mins - CRITICAL

scripts will be ran on a virtual desktop
script 1 
getting disk space data
- servers: 8 x Windows 2016 servers

- list volumes 
#>
#region

#endregion

