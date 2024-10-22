
#region creating RG, VNET, subnets, IPs, IPconfigurations, privateDNSZone from scratch ###
New-AzResourceGroup -name test01ResourceGroup -Location northeurope
$rg=get-AzResourceGroup -name test01ResourceGroup -Location northeurope

# Preparing networking 

New-AzPublicIpAddress -Name vm01publicipaddress -ResourceGroupName test01resourcegroup -Location northeurope -AllocationMethod static
$publicip=Get-AzPublicIpAddress -Name vm01publicipaddress -ResourceGroupName $rg.ResourceGroupName

New-AzVirtualNetwork -Name vnet01VirtualNetwork -ResourceGroupName test01Resourcegroup -location northeurope -AddressPrefix 10.0.0.0/16
$vnet=Get-AzVirtualNetwork -name vnet01VirtualNetwork -ResourceGroupName test01Resourcegroup

New-AzVirtualNetworkSubnetConfig -name backendSubnet -AddressPrefix 10.0.1.0/24
add-AzVirtualNetworkSubnetConfig -name backendSubnet -VirtualNetwork $vnet -AddressPrefix 10.0.1.0/24
$backendSubnet=get-AzVirtualNetworkSubnetConfig -name backendSubnet -VirtualNetwork $vnet

New-AzVirtualNetworkSubnetConfig -name frontendSubnet -AddressPrefix 10.0.2.0/24
add-AzVirtualNetworkSubnetConfig -name frontendSubnet -VirtualNetwork $vnet -AddressPrefix 10.0.2.0/24
$frontendSubnet=get-AzVirtualNetworkSubnetConfig -name frontendSubnet -VirtualNetwork $vnet

# DNS zones and links

$zone=New-azPrivateDnsZone -Name private.kk1kk.store -ResourceGroupName test01Resourcegroup
$link=New-AzPrivateDnsVirtualNetworkLink -ZoneName private.kk1kk.store -ResourceGroupName test01Resourcegroup -name "link01" -VirtualNetworkId $vnet.Id

# checking
get-azPrivateDnsZone
get-AzPrivateDnsVirtualNetworkLink -ZoneName private.kk1kk.store 

#creating 2x test VMs
# very insecure !!!!!!!
$password = ConvertTo-SecureString "A241071z123!" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ("kk", $password )

# finding the right image
https://ilovepowershell.com/azure/every-step-you-need-to-create-an-azure-virtual-machine-with-powershell/
# commands need to nbe executed in sequence to find the right image
#  Get-AzVMSize -Location northeurope 
# "Standard_B2s"
#Get-AzVMImagePublisher
# Get-AzVMImageOffer
# Get-AzVMImageSku
# Get-AzVMImage -Location northeurope -PublisherName MicrosoftWindowsServer -offer WindowsServer -Skus "2016-datacenter" -Version "14393.7428.241004"

### Windows 2022, no public IP
# creating new RG,VNET,VNIC,VM
 New-AzResourceGroup -Name "ResourceGroup02" -location "northeurope"
$VMLocalAdminUser = "kk-admin"
$VMLocalAdminSecurePassword = ConvertTo-SecureString -String "A241071z123!" -AsPlainText -Force
$LocationName = "north europe"
$ResourceGroupName = "ResourceGroup02"
$ComputerName = "azSRV01"
$VMName = "MyVM01"
$VMSize = "Standard_B2s"

$NetworkName = "MyNet1"
$NICName = "MyNIC"
$SubnetName = "MySubnet"
$SubnetAddressPrefix = "10.0.0.0/24"
$VnetAddressPrefix = "10.0.0.0/16"
$sku="2022-datacenter-azure-edition-core"

$SingleSubnet = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddressPrefix
$Vnet = New-AzVirtualNetwork -Name $NetworkName -ResourceGroupName $ResourceGroupName -Location $LocationName -AddressPrefix $VnetAddressPrefix -Subnet $SingleSubnet
$NIC = New-AzNetworkInterface -Name $NICName -ResourceGroupName $ResourceGroupName -Location $LocationName -SubnetId $Vnet.Subnets[0].Id

$Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword);

$VirtualMachine = New-AzVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus $sku -Version latest

New-AzVM -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VirtualMachine -Verbose

### Windows 2022, with a public IP
# creating new RG,VNET,VNIC,VM
New-AzResourceGroup -Name "ResourceGroup03" -location "northeurope"
$VMLocalAdminUser = "kk-admin"
$VMLocalAdminSecurePassword = ConvertTo-SecureString -String "A241071z123!" -AsPlainText -Force
$LocationName = "north europe"
$ResourceGroupName = "ResourceGroup03"
$ComputerName = "azSRV01"
$VMName = "MyVM01"
$VMSize = "Standard_B2s"

$NetworkName = "MyNet1"
$NICName = "MyNIC"
$SubnetName = "MySubnet"
$SubnetAddressPrefix = "10.0.0.0/24"
$VnetAddressPrefix = "10.0.0.0/16"
$sku="2022-datacenter-azure-edition-core"

$SingleSubnet = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddressPrefix
$Vnet = New-AzVirtualNetwork -Name $NetworkName -ResourceGroupName $ResourceGroupName -Location $LocationName -AddressPrefix $VnetAddressPrefix -Subnet $SingleSubnet
$NIC = New-AzNetworkInterface -Name $NICName -ResourceGroupName $ResourceGroupName -Location $LocationName -SubnetId $Vnet.Subnets[0].Id

$Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword);

$VirtualMachine = New-AzVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus $sku -Version latest

New-AzVM -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VirtualMachine -Verbose




#creating private DNS sets
    New-AzPrivateDnsRecordSet -Name myvm01 -RecordType A -ZoneName private.kk1kk.store -ResourceGroupName test01ResourceGroup -Ttl 3600 -PrivateDnsRecords (New-AzPrivateDnsRecordConfig -IPv4Address "10.0.1.11")
    
    New-AzPrivateDnsRecordSet -Name myvm02 -RecordType A -ZoneName private.kk1kk.store -ResourceGroupName test01ResourceGroup -Ttl 3600 -PrivateDnsRecords (New-AzPrivateDnsRecordConfig -IPv4Address "10.0.1.12")

    #viewing DNS records
    get-AzPrivateDnsRecordSet -ResourceGroupName test01resourcegroup -ZoneName private.kk1kk.store




New-AzVm -ResourceGroupName "ResourceGroupName" -Name "VMName" -Location "Region Name" -VirtualNetworkName "VNetName" -SubnetName "SubnetName" -SecurityGroupName "NSGName" -PublicIpAddressName "PublicIPName" -OpenPorts 80,3389 -Size "VMSize" -Credential (New-Object System.Management.Automation.PSCredential ("username", (ConvertTo-SecureString "password0!" -AsPlainText -Force))) -Image "OperatingSystemName"