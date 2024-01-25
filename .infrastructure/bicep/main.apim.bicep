@description('The name of this workload.  This is used for computing resource names in the form of <workloadName>-<environmentSuffix>-<resource type>')
param workloadName string

@description('The name or abbreviation of the environment where resources will be provisioned.  This is used for computing resource names in the form of <workloadName>-<environmentSuffix>-<resource type>')
param environmentSuffix string

@description('The region resources will be provisioned in')
param location string

@description('The name of the SKU to provision')
@allowed(['Developer', 'Premium', 'StandardV2'])
param skuName string

@description('The number of scale units to provision')
param skuCapacity int = 1

@description('The email address associated with the publisher.  This value can be used as the send-from address for email notifications')
param publisherEmailAddress string

@description('THe name of that API publisher\'s organization.  This value is used in the developer portal and for email notifications')
param publisherOrganizationName string

@description('The vnet integration mode, internal for no public gateway endpoint, external to include a public gateway endpoint')
@allowed(['Internal', 'External'])
param vnetIntegrationMode string

@description('The resource id of the subnet to integrate with')
param vnetSubnetResourceId string

@description('An array of Entra Object IDs representing users that need administrative access to the Key Vault')
param keyVaultAdminIdentities array

@description('Date/time of deployment.  Optional param, defaults to utcNow(), used to compute a semi-unique deployment name')
param deploymentDateTime string = utcNow()

var apiManagementName = '${workloadName}-${environmentSuffix}-apim'
var keyVaultName = '${workloadName}-${environmentSuffix}-kv'
var logAnalyticsWorkspaceName = '${workloadName}-${environmentSuffix}-laws'
var applicationInsightsName = '${workloadName}-${environmentSuffix}-ai'
var publicIpAddressName = '${workloadName}-${environmentSuffix}-pip'
var userAssignedManagedIdentiyName = '${workloadName}-${environmentSuffix}-uami'

var deploymentSuffix = uniqueString(deploymentDateTime)

var apiManagementDeploymentName = '${apiManagementName}-${deploymentSuffix}'
var keyVaultDeploymentName = '${keyVaultName}-${deploymentSuffix}'
var logAnalyticsWorkspaceDeploymentName = '${logAnalyticsWorkspaceName}-${deploymentSuffix}'
var applicationInsightsDeploymentName = '${applicationInsightsName}-${deploymentSuffix}'
var publicIpAddressDeploymentName = '${publicIpAddressName}-${deploymentSuffix}'
var userAssignedManagedIdentiyDeploymentName = '${userAssignedManagedIdentiyName}-${deploymentSuffix}'

module umami './modules/managedIdentity/userAssignedManagedIdentity.bicep' = {
  name: userAssignedManagedIdentiyDeploymentName
  params: {
    managedIdentityName: userAssignedManagedIdentiyName
    location: location
  }
}

module laws './modules/observability/logAnalyticsWorkspace.bicep' = {
  name: logAnalyticsWorkspaceDeploymentName
  params: {
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    location: location
  }
}

module appInsights './modules/observability/applicationInsights.bicep' = {
  name: applicationInsightsDeploymentName
  params: {
    appInsightsName: applicationInsightsName
    logAnalyticsWorkspaceId: laws.outputs.id
    location: location
  }
}

module kv './modules/keyVault/keyVault.bicep' = {
  name: keyVaultDeploymentName
  params: {
    keyVaultName: keyVaultName
    location: location
    adminIdentities: keyVaultAdminIdentities
    applicationIdentities: [ umami.outputs.principalId ]
  }
}

module pip './modules/publicIpAddress/publicIpAddress.bicep' = {
  name: publicIpAddressDeploymentName
  params: {
    publicIpAddressName: publicIpAddressName
    location: location
    dnsLabel: apiManagementName
  }
}

module apim './modules/apiManagement/apiManagementService.bicep' = {
  name: apiManagementDeploymentName
  params: {
    apiManagementServiceName: apiManagementName
    location: location
    skuName: skuName
    skuCapacity: skuCapacity
    publisherEmailAddress: publisherEmailAddress
    publisherOrganizationName: publisherOrganizationName
    vnetIntegrationMode: vnetIntegrationMode
    vnetSubnetResourceId: vnetSubnetResourceId
    publicIpResourceId: pip.outputs.id
    userAssignedManagedIdentityResourceId: umami.outputs.id
  }
}
