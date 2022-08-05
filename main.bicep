param location string = resourceGroup().location
var environment = 'dev'
var baseName = '${location}-agparpo-${environment}'


module vnet 'modules/vnet.bicep'={
  name: 'vnet'
  params: {
    baseName: baseName 
    location: location
  }
}

module vms 'modules/vms.bicep'={
  name: 'vms-${baseName}'
  params: {
    baseName: baseName
    location: location
    snetId: vnet.outputs.snetid
  }
}
