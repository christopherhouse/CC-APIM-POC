using '../main.apim.bicep'

param workloadName = 'cmh-cc-apim-poc'
param environmentSuffix = 'dev'
param location = 'eastus'
param skuName = 'Developer'
param publisherEmailAddress = 'bogus.email@totallymadeup.com'
param publisherOrganizationName = 'My Awesome APIs'
param vnetIntegrationMode = 'Internal'
param vnetSubnetResourceId = '/subscriptions/e1f57a36-4892-4716-9a3f-661432b39dbe/resourcegroups/CC-APIM-POC/providers/Microsoft.Network/virtualNetworks/cc-apim-poc-vnet/subnets/apim'
param keyVaultAdminIdentities = ['c9be89aa-0783-4310-b73a-f81f4c3f5407']
