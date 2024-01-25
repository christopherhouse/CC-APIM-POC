@description('The name of the Log Analytics Workspace to create')
param logAnalyticsWorkspaceName string

@description('The region where the Log Analytics Workspace will be created')
param location string

resource laws 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    retentionInDays: 30
    sku: {
      name: 'PerGB2018'
    }
  }
}

output id string = laws.id
