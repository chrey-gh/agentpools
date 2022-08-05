param baseName string
param location string




resource vnet 'Microsoft.Network/virtualNetworks@2022-01-01'={
  name: 'vnet-${baseName}'
  location: location
  properties: {
    addressSpace:{
      addressPrefixes:[
        '192.168.44.0/24'
      ]
    }

  }
}


resource snet1 'Microsoft.Network/virtualNetworks/subnets@2022-01-01'={
  name: 'snet1-${baseName}'
  parent: vnet
  properties:{
   addressPrefix: '192.168.44.0/26' 
   networkSecurityGroup: {
    id:nsg.id
   }
  }
}

output snetid string = snet1.id


resource nsg 'Microsoft.Network/networkSecurityGroups@2021-08-01'={
  name: 'nsg1-${baseName}'
  location:location
  properties:{
    securityRules:[
      {
        name: 'SSH'
        properties:{
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRange:'*'
          sourceAddressPrefix:'*'
          destinationPortRange:'22'
          destinationAddressPrefix: '*'
          priority: 500

        }
      }
    ]
  }
}
