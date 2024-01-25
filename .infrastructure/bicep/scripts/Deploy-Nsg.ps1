param (
    [Parameter(Mandatory = $true)]
    [string]
    $ResourceGroupName,
    [Parameter(Mandatory = $true)]
    [string]
    $SubnetName,
    [Parameter(Mandatory = $true)]
    [string]
    $VnetName
)

Write-Host "** Begining deployment and vnet update with the following parameters:"
Write-Host "** Resource Group Name: $ResourceGroupName"
Write-Host "** Subnet Name: $SubnetName"
Write-Host "** Vnet Name: $VnetName"

# Use Az Powershell to deploy the template ../main.nsg.bicep with the parameter file
# ../parameters/main.nsg.bicepparam to the resource group named $ResourceGroupName.
# The Bicep template includes an output parameter named nsgResourceId.  This value
# should be captured in a variable named $nsgResourceId.
$deploymentOutput = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName `
    -TemplateFile ../main.nsg.bicep `
    -TemplateParameterFile ../parameters/main.nsg.bicepparam `
    -Verbose `
    -Force `
    -ErrorAction Stop `
    -OutVariable nsgResourceId

Write-Host "** Deployment complete, attaching NSG to subnet $SubnetName"
$nsgName = $deploymentOutput.Outputs.nsgName.Value

# Get the virtual network specified by the name $VnetName in the resource group $ResourceGroupName.
$vnet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name $VnetName

# Get the subnet configuration for the subnet named $SubnetName on the virtual network specified by
# $vnet
$subnetConfig = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subneName

# get the nsg resource specified by $nsgName in Resource Group $ResourceGroupName
$nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Name $nsgName

# Update the subnetconfig named $subnetName on the vnet specified by $vnet.  The address space is the address
# space of the subnet.  The network security group to attach is represented by $nsg
Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet `
    -Name $SubnetName `
    -AddressPrefix $subnetConfig.AddressPrefix[0] `
    -NetworkSecurityGroupId $nsg.Id

$vnet | Set-AzVirtualNetwork

Write-Host "** NSG attached to subnet $SubnetName"
