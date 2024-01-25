param publicIpAddressName string
param dnsLabel string
param location string

resource pip 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: publicIpAddressName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    dnsSettings: {
      domainNameLabel: dnsLabel
    }
    publicIPAllocationMethod: 'Static'
  }
}

output id string = pip.id
