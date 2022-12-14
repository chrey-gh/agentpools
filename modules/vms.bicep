param location string
param baseName string
param snetId string

param adminUserName string = 'tdadmin'
var dnsLabel1 = 'vm1-${baseName}-${uniqueString(resourceGroup().id)}'

resource pubIp1 'Microsoft.Network/publicIPAddresses@2022-01-01'= {
  name: 'pubip1-${baseName}'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
       domainNameLabel: dnsLabel1
    }
    idleTimeoutInMinutes: 4
  }
}



resource nic1 'Microsoft.Network/networkInterfaces@2022-01-01'={
  name: 'nic1-${baseName}'
  location: location
  properties:{
    ipConfigurations: [
       {
        name: 'pip1'
        properties: {
           subnet:  {
             id: snetId
           }
           privateIPAllocationMethod: 'Dynamic'
           publicIPAddress: {
            id: pubIp1.id
           }
        }
       }
    ]
  }

}


resource vm 'Microsoft.Compute/virtualMachines@2022-03-01'={
  name: 'vm1-${baseName}'
  location: location
  properties:{
    hardwareProfile: {
       vmSize: 'Basic_A2'
    } 
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      imageReference: {
         publisher:'Canonical'
         offer: 'UbuntuServer'
         sku: '18.04-LTS'
         version: 'latest'
      }
      
    }
    networkProfile: {
       networkInterfaces: [
         {
           id: nic1.id
         }
       ]
    }
    osProfile: {
       adminPassword: 'Tested2222**'
       adminUsername: adminUserName
       computerName: 'vm1-${baseName}'
       }
    }
}

