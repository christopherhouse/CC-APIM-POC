
@description('The name of this workload.  This is used for computing resource names in the form of <workloadName>-<environmentSuffix>-<resource type>')
param workloadName string

@description('The name or abbreviation of the environment where resources will be provisioned.  This is used for computing resource names in the form of <workloadName>-<environmentSuffix>-<resource type>')
param enviroinmentSuffix string

@description('The region resources will be provisioned in')
param location string

@description('THe name of the SKU to provision')
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
