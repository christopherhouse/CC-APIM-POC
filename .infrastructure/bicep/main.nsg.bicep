@description('The name of this workload.  This is used for computing resource names in the form of <workloadName>-<environmentSuffix>-<resource type>')
param workloadName string

@description('The name or abbreviation of the environment where resources will be provisioned.  This is used for computing resource names in the form of <workloadName>-<environmentSuffix>-<resource type>')
param environmentSuffix string

@description('The region resources will be provisioned in')
param location string

@description('Date/time of deployment.  Optional param, defaults to utcNow(), used to compute a semi-unique deployment name')
param deploymentDateTime string = utcNow()

var deploymentSuffix = uniqueString(deploymentDateTime)

var nsgName = '${workloadName}-${environmentSuffix}-nsg'

var nsgDeploymentName = '${nsgName}-${deploymentSuffix}'

module nsg './modules/networkSecurityGroup/apimNetworkSecurityGroup.bicep' = {
  name: nsgDeploymentName
  params: {
    nsgName: nsgName
    location: location
  }
}

output nsgResourceId string = nsg.outputs.id
