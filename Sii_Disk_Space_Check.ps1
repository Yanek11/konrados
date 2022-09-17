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