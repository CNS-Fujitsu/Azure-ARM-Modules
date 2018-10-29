# Azure-ARM-Modules
A respository for the creation of Micorosoft Azure Arm Modules to be used in Nested Arm Templates


## Modules

### Module Name: azVnet-2a.json
Description: Deploys an Azure Virtual Network with 2 subnets as a nested template in a master template when parameters are passed.
Usage Enablement in Master Deploy template:

User


#### Main Template Parameters:

`"requiredModuleAZVnet-2a" : {
      "type" : "string",
      "allowedValues": [
        "Yes",
        "No"
      ]
      },
    "module-azVnet2a" : {
      "type" : "object"
    }`

#### Main Template Resources:

`{
      "apiVersion": "2017-05-10",
      "name": "azVnet-2a",
      "comments": "Module to deploy a virtual network with 2 subnets",
      "type": "Microsoft.Resources/deployments",
      "condition": "[equals(parameters('requiredModuleAZVnet-2a'), 'Yes')]",
      "properties" : {
        "mode": "Incremental",
        "templateLink": {
          "uri": "[variables('Module-azVnet2a-URL')]",
          "contentVersion": "1.0.0.0"
        },
        "parameters": {
          "vnetName": { "value": "[parameters('module-azVnet2a').name]" },
          "vnetCIDR": { "value": "[parameters('module-azVnet2a').vnetCIDR]" },
          "subnetName1": { "value": "[parameters('module-azVnet2a').subnets[0].name]" },
          "subnetIPRange1": { "value": "[parameters('module-azVnet2a').subnets[0].addressPrefix]" },
          "subnetName2": { "value": "[parameters('module-azVnet2a').subnets[1].name]" },
          "subnetIPRange2": { "value": "[parameters('module-azVnet2a').subnets[1].addressPrefix]" }
        }
    }
}`

Main Template Output:

`"vnetResource": {
      "type": "string",
      "value": "[reference('azVnet-2a').outputs.vnetResourceId.value]"
    }`

Parameters Template:

`"requiredModuleAZVnet-2a" : {
      "value" : "Yes"} ,
    "module-azVnet2a":{
        "value":{
            "vnetName" : "prod-ne1-vnet",
            "vnetCIDR" : "10.0.0.0/16",
            "subnets":[
                {
                    "name": "prod-ne1-vnet-subnet1",
                    "addressPrefix": "10.0.0.0/24"
                },
                {
                    "name":"prod-ne1-vnet-subnet2",
                    "addressPrefix":"10.0.1.0/24"
                }
            ]
        }
    }`