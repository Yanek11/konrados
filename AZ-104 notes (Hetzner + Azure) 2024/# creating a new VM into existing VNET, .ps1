# creating a new VM into existing VNET, subnegt and RG
# WORKING OK

$VMLocalAdminUser = "kk-admin"
$VMLocalAdminSecurePassword = ConvertTo-SecureString -String "A241071z123!" -AsPlainText -Force
$LocationName = "north europe"
$ResourceGroupName = "ResourceGroup01"
$ComputerName = "azSRV01"
$VMName = "MyVM01"
$VMSize = "Standard_B2s"

$NetworkName = "VNET01"
$NICName = "$VMName.NIC"
$SubnetName = "Subnet01"
$SubnetAddressPrefix = "10.0.0.0/24"
$VnetAddressPrefix = "10.0.0.0/16"
$sku="2022-datacenter-azure-edition-core"
$ip = @{
    Name = "$VMName.PublicIP"
    ResourceGroupName = $ResourceGroupName
    Location = $LocationName
    Sku = "Standard"
    AllocationMethod = 'Static'
    IpAddressVersion = 'IPv4'
       
}
New-AzPublicIpAddress @ip

$Vnet = get-AzVirtualNetwork -Name $NetworkName -ResourceGroupName $ResourceGroupName 
$NIC = New-AzNetworkInterface -Name $NICName -ResourceGroupName $ResourceGroupName -Location $LocationName -SubnetId $Vnet.Subnets[0].Id -PublicIpAddressId $publicip.Id

$Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword);

$VirtualMachine = New-AzVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus $sku -Version latest

New-AzVM -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VirtualMachine  -Verbose 

############################################################################

# creating a new VM into existing VNET, subnet  and RG
# adding IP address

$VMLocalAdminUser = "kk-admin"
$VMLocalAdminSecurePassword = ConvertTo-SecureString -String "A241071z123!" -AsPlainText -Force
$LocationName = "north europe"
$ResourceGroupName = "ResourceGroup01"
$ComputerName = "azSRV02"
$VMName = "MyVM02"
$VMSize = "Standard_B2s"

$NetworkName = "VNET01"
$NICName = "$VMName.NIC"
$SubnetName = "Subnet01"
$SubnetAddressPrefix = "10.0.0.0/24"
$VnetAddressPrefix = "10.0.0.0/16"
$sku="2022-datacenter-azure-edition-core"
$ip = @{
    Name = "$VMName.PublicIP"
    ResourceGroupName = $ResourceGroupName
    Location = $LocationName
    Sku = "Standard"
    AllocationMethod = 'Static'
    IpAddressVersion = 'IPv4'
       
}
New-AzPublicIpAddress @ip
$publicip=Get-AzPublicIpAddress -Name $ip.Name
$Vnet = get-AzVirtualNetwork -Name $NetworkName -ResourceGroupName $ResourceGroupName 
$NIC = New-AzNetworkInterface -Name $NICName -ResourceGroupName $ResourceGroupName -Location $LocationName -SubnetId $Vnet.Subnets[0].Id -PublicIpAddressId $publicip.Id

$Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword);

$VirtualMachine = New-AzVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus $sku -Version latest

New-AzVM -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VirtualMachine  -Verbose 