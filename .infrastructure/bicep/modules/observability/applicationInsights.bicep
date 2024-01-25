@description('The name of the App Inisghts resource to create')
param appInsightsName string

@description('The region where the App Insights resource will be created')
param location string

@description('The resource ID of the Log Analytics workspace to attach to')
param logAnalyticsWorkspaceId string

resource ai 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Bluefield'
    WorkspaceResourceId: logAnalyticsWorkspaceId
  }
}

