New-AzureRmResourceGroup -ResourceGroupName AUE-Assets -Location "Australia East"

# Create the virtual network resources

$GWsubnet = New-AzureRmVirtualNetworkSubnetConfig `
  -Name "GatewaySubnet" `
  -AddressPrefix 10.101.0.128/25
$Subnet = New-AzureRmVirtualNetworkSubnetConfig `
  -Name "AUE-VNet01A-SN01" `
  -AddressPrefix 10.101.1.0/24


  $AUEVNet01A = New-AzureRmVirtualNetwork `
  -ResourceGroupName "AUE-Assets" `
  -Name "AUE-VNet01A" `
  -Location "Australia East" `
  -AddressPrefix 10.101.0.0/16 `
  -Subnet $GWsubnet, $Subnet

  
  
$RG = "AUE-Assets"
$Location = "Australia East"
$GWName = "AUEGW-A"
$GWIPName = "AUEGW-APiP"
$GWIPconfName = "AUEGW-Aipconf"
$VNetName = "AUE-VNet01A"


#Store the virtual network object as a variable.
$AUEVNet01A= Get-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $RG

#Store the gateway subnet as a variable.
$GWsubnet = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $AUEVNet01A 

#Request a public IP address.
$pip = New-AzureRmPublicIpAddress -Name $GWIPName  -ResourceGroupName $RG -Location $Location -AllocationMethod Dynamic

#Create the configuration for your gateway
$ipconf = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName -Subnet $GWsubnet -PublicIpAddress $pip

#Create the gateway
New-AzureRmVirtualNetworkGateway -Name $GWName -ResourceGroupName $RG -Location $Location -IpConfigurations $ipconf -GatewayType Vpn -VpnType RouteBased -GatewaySku Standard 
