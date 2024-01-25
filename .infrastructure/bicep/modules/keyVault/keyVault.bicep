@description('The name of the Key Vault resource to create')
param keyVaultName string

@description('The region where the Key Vault resource will be created')
param location string

@description('An array of Entra Object IDs that represent users requiring administrative access to the Key Vault')
param adminIdentities array

@description('An array of Entra Object IDs that represent application princiapals requiring access to the Key Vault for secret and certificate get/list')
param applicationIdentities array

var adminPolicies = [for id in adminIdentities: {
  tenantId: subscription().tenantId
  objectId: id
  permissions: {
    keys: ['all']
    secrets: ['all']
    certificates: ['all']
  }
}]

var appPolicies = [for id in applicationIdentities: {
  tenantId: subscription().tenantId
  objectId: id
  permissions: {
    secrets: [
      'Get'
      'List'
  ]
  certificates: [
    'Get'
    'List'
  ]
  }
}]

var policies = union(adminPolicies, appPolicies)

resource kv 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
    accessPolicies: policies
    softDeleteRetentionInDays: 7
    enableRbacAuthorization: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      ipRules: []
      virtualNetworkRules: []
    }
  }
}
