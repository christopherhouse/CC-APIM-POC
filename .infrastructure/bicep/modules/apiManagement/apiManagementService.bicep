param apiManagementServiceName string
param location string
param skuName string
param skuCapacity int
param publisherEmailAddress string
param publisherName string
@allowed(['External', 'Internal', 'None'])
param vnetIntegrationMode string
param vnetSubnetResourceId string
param publicIpResourceId string

resource apiManagementService 'Microsoft.ApiManagement/service@2023-03-01-preview' = {
  name: apiManagementServiceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  properties: {
    publisherEmail: publisherEmailAddress
    publisherName: publisherName
    virtualNetworkType: vnetIntegrationMode
    virtualNetworkConfiguration: {
      subnetResourceId: vnetSubnetResourceId
    }
    publicIpAddressId: publicIpResourceId
  }
}
