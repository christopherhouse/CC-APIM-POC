@description('The name of the API Management resource that will be created')
param apiManagementServiceName string

@description('The region where the new API Management resource will be created')
param location string

@description('The name of the SKU to provision')
@allowed(['Developer', 'Premium', 'StandardV2']) // Only allow SKUs that support vnet integration
param skuName string

@description('The number of scale units to provision')
param skuCapacity int

@description('The email address associated with the publisher.  This value can be used as the send-from address for email notifications')
param publisherEmailAddress string

@description('THe name of that API publisher\'s organization.  This value is used in the developer portal and for email notifications')
param publisherOrganizationName string

@description('The vnet integration mode, internal for no public gateway endpoint, external to include a public gateway endpoint')
@allowed(['External', 'Internal'])
param vnetIntegrationMode string

@description('The resource id of the subnet to integrate with')
param vnetSubnetResourceId string

@description('The resource id of the public IP address that will be attached to APIM')
param publicIpResourceId string

@description('The resource id of the user assigned managed identity that will be used to access the key vault')
param userAssignedManagedIdentityResourceId string

resource apiManagementService 'Microsoft.ApiManagement/service@2023-03-01-preview' = {
  name: apiManagementServiceName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedManagedIdentityResourceId}': {}
    }
  }
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  properties: {
    publisherEmail: publisherEmailAddress
    publisherName: publisherOrganizationName
    virtualNetworkType: vnetIntegrationMode
    virtualNetworkConfiguration: {
      subnetResourceId: vnetSubnetResourceId
    }
    publicIpAddressId: publicIpResourceId
  }
}
