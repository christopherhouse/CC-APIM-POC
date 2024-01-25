@description('The name of the User Assigned Managed Identity resource to create')
param managedIdentityName string

@description('The region where the User Assigned Managed Identity resource will be created')
param location string

resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
}

output id string = uami.id
output name string = uami.name
output principalId string = uami.properties.principalId
output clientId string = uami.properties.clientId
