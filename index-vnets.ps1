$reportName = "vnet-index.csv"
$report = @()
$subs =  Get-AzureRmSubscription | where State -eq Enabled 
foreach ($sub in $subs) {
	$cntxt = Set-AzContext -SubscriptionObject $sub
	$vnets = Get-AzureRmVirtualNetwork | where VirtualNetworkPeerings -ne null
	$info = "" | Select SubscriptionName, SubscriptionId, VirtualNetworkName, SubnetName, AddressPrefix
	$info.SubscriptionName = $sub.Name
        $info.SubscriptionId = $sub.Id
	foreach ($vnet in $vnets) { 
	        $info.VirtualNetworkName = $vnet.Name 
		foreach ($subnet in $vnet.Subnets) {
			$subnetInfo = $info.PSObject.Copy()
			$subnetInfo.SubnetName = $subnet.Name
			$subnetInfo.AddressPrefix = $subnet.AddressPrefix[0]
			$report += $subnetInfo
		}
	} 
} 

$report | ft SubscriptionName, SubscriptionId, VirtualNetworkName, SubnetName, AddressPrefix
$report | Export-CSV "$home/$reportName"
