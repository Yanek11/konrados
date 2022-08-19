Get-CimInstance -ClassName win32_bios -ComputerName srv02,srv03

Get-CimInstance -ClassName Win32_LogicalDisk -Filter "deviceid='c:'" -ComputerName 'localhost'|select SystemName,DeviceID,@