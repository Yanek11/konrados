#1 OWA - Outlook Web App
Get-OwaVirtualDirectory -Server exch11  |select InternalUrl # checking
Get-OwaVirtualDirectory -Server exch11 | Set-OwaVirtualDirectory -InternalUrl https://mail.kakaka.store/owa -ExternalUrl https://mail.kakaka.store/owa


Get-OwaVirtualDirectory -Server exch12 | Set-OwaVirtualDirectory -InternalUrl https://mail.kakaka.store/owa -ExternalUrl https://mail.kakaka.store/owa
Get-OwaVirtualDirectory -Server exch12  |select InternalUrl # checking

#2 Autodiscover

Set-Clientaccessservice -identity exch11 -autodiscoverserviceinternaluri https://mail.kakaka.store/Autodiscover/Autodiscover.xml 
Get-ClientAccessService |select name, autodiscoverserviceinternaluri

Set-Clientaccessservice -identity exch12 -autodiscoverserviceinternaluri https://mail.kakaka.store/Autodiscover/Autodiscover.xml 
Get-ClientAccessService |select name, autodiscoverserviceinternaluri

#3 ECP - Exchange COntrol Panel
Get-EcpVirtualDirectory -Server exch11 |select InternalUrl, -ExternalUrl
Get-EcpVirtualDirectory -Server exch11 | Set-EcpVirtualDirectory -ExternalUrl $null -InternalUrl https://mail.kakaka.store/ecp


Get-EcpVirtualDirectory -Server exch12 | Set-EcpVirtualDirectory -ExternalUrl $null -InternalUrl https://mail.kakaka.store/ecp
Get-EcpVirtualDirectory -Server exch12 |select InternalUrl, -ExternalUrl

#4 EWS - Exchange Web Services

Get-WebServicesVirtualDirectory -Server exch11
Get-WebServicesVirtualDirectory -Server exch11 | Set-WebServicesVirtualDirectory -ExternalUrl https://mail.kakaka.store/EWS/ -InternalUrl https://mail.kakaka.store/EWS/Exchange.asmx 


Get-WebServicesVirtualDirectory -Server exch12 | Set-WebServicesVirtualDirectory -ExternalUrl https://mail.kakaka.store/EWS/ -InternalUrl https://mail.kakaka.store/EWS/Exchange.asmx 
Get-WebServicesVirtualDirectory -Server exch12


#5 MAPI 
Get-MapiVirtualDirectory | FL ServerName, *url*, *auth* # checking
Get-MapiVirtualDirectory -Server exch11 | Set-MapiVirtualDirectory -ExternalUrl https://mail.kakaka.store/mapi -InternalUrl https://mail.kakaka.store/mapi



Get-MapiVirtualDirectory -Server exch12 | Set-MapiVirtualDirectory -ExternalUrl https://mail.kakaka.store/mapi -InternalUrl https://mail.kakaka.store/mapi
Get-MapiVirtualDirectory | FL ServerName, *url*, *auth* # checking

#6 ActiveSync
Get-ActiveSyncVirtualDirectory -Server exch11 | Set-ActiveSyncVirtualDirectory -ExternalUrl https://mail.kakaka.store/Microsoft-Server-ActiveSync -InternalUrl https://mail.kakaka.store/Microsoft-Server-ActiveSync

Get-ActiveSyncVirtualDirectory -Server exch12 | Set-ActiveSyncVirtualDirectory -ExternalUrl https://mail.kakaka.store/Microsoft-Server-ActiveSync -InternalUrl https://mail.kakaka.store/Microsoft-Server-ActiveSync
Get-ActiveSyncVirtualDirectory -Server exch12

#7 OAB - Offline Address Book
Get-OabVirtualDirectory -Server exch11 | Set-OabVirtualDirectory -ExternalUrl https://mail.kakaka.store/OAB -InternalUrl https://mail.kakaka.store/OAB

Get-OabVirtualDirectory -Server exch12 | Set-OabVirtualDirectory -ExternalUrl https://mail.kakaka.store/OAB -InternalUrl https://mail.kakaka.store/OAB


#8 Powershell - OPTIONAL ?!

Get-powershellVirtualDirectory -Server exch11 | Set-powershellVirtualDirectory -ExternalUrl $null -InternalUrl https://mail.kakaka.store/powershell
Get-powershellVirtualDirectory -Server exch12 | Set-powershellVirtualDirectory -ExternalUrl $null -InternalUrl https://mail.kakaka.store/powershell
