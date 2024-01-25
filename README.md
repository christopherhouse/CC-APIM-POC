# Azure Bicep and PowerShell Repository

This repository contains Azure Bicep templates and PowerShell scripts creating resources needed to run an Azure API Management POC.  There are
two Bicep templates, one to create the Network Security Group required by vnet integrated API Management and one to create an API Management resource,
attached to a virtual network and several supporting resources.  There are also two supporting Powershell scripts.  The first deploys the NSG template and attaches the new NSG to an existing subnet.  The second script deploys the APIM template.

Note that the tempaltes in this repository DO NOT create a virtual network or a subnet, they assume you will provide an existing subnet that APIM will be
attached to.

## Bicep Templates

Here are the resources created by the Bicep templates:

- Network Security Group
- User-assigned Managed Identity
- Key Vault
- Log Analytics Workspace
- Application Insights
- API Management

## PowerShell Scripts

### Deploy-Nsg.ps1

#### Description

The [Deploy-Nsg.ps1](.infrastructure/bicep/scripts/Deploy-Nsg.ps1) script deploys a Network Security Group (NSG) to a specified Azure resource group. The NSG is defined using the Bicep template [main.nsg.bicep](.infrastructure/bicep/main.nsg.bicep).  After the Bicep template is deployed, the script attaches the NSG to an existing subnet.  API Management requires
this NSG to be attached to the subnet where the API Management instance is deployed, so this script must be run before running the script that deploys API Management.

**Ensure before running this script that you have the necessary role to update the configuration of the subnet you're using or it will fail to attach the NSG to the subnet.  API Management will not deploy to a subnet without the required NSG in place**

##### Parameters

The script takes the following parameters:

- `ResourceGroupName`: The name of the Azure resource group where the NSG will be deployed.
- `VnetName`: The name of the Azure virtual network that contains the subnet the NSG will be attached to.
- `SubnetName`: The name of the Azure subnet where the NSG will be attached.

#### Usage

To run the `Deploy-Nsg.ps1` script, use the following command:

```powershell
./Deploy-Nsg.ps1 -ResourceGroupName "myResourceGroup" -VnetName "myVnet" -SubnetName "mySubnet"
```

### Deploy-Apim.ps1

This PowerShell script is used to deploy an Azure API Management (APIM) instance to an Azure resource group using a Bicep template.

#### Description

The `Deploy-Apim.ps1` script deploys an Azure API Management (APIM) instance to a specified Azure resource group. The APIM instance is defined using a Bicep template, which is a declarative language for describing and deploying Azure resources.

The APIM instance created by this script provides a unified API gateway that makes it easy to publish, manage, secure, and analyze APIs in Azure.

#### Parameters

The script takes the following parameters:

- `ResourceGroupName`: The name of the Azure resource group where the APIM instance will be deployed.

#### Usage

To run the `Deploy-Apim.ps1` script, use the following command:

```powershell
./Deploy-Apim.ps1 -ResourceGroupName "myResourceGroup"
```

## Infrastructure Parameters
Both the NSG and APIM Bicep templates require a number of parameters.  The value for these parameters should be specified in the parameter files included
in this repository, [main.apim.bicepparam](.infrastructure/bicep/parameters/main.apim.bicepparam) and [main.nsg.bicepparam](.infrastructure/bicep/parameters/main.nsg.bicepparam).

### main.apim.bicepparam
| Parameter Name | Type | Description |
| -------------- | ---- | ----------- |
| workloadName | string | The name of this workload. Used for computing resource names. |
| environmentSuffix | string | The name or abbreviation of the environment. Used for computing resource names. |
| location | string | The region where resources will be provisioned. |
| skuName | string | The name of the SKU to provision. Allowed values are 'Developer', 'Premium', 'StandardV2'. |
| skuCapacity | int | The number of scale units to provision. Default is 1. |
| publisherEmailAddress | string | The email address associated with the publisher. Used as the send-from address for email notifications. |
| publisherOrganizationName | string | The name of the API publisher's organization. Used in the developer portal and for email notifications. |
| vnetIntegrationMode | string | The vnet integration mode. Allowed values are 'Internal', 'External'. |
| vnetSubnetResourceId | string | The resource id of the subnet to integrate with. |
| keyVaultAdminIdentities | array | An array of Entra Object IDs representing users that need administrative access to the Key Vault. |
| deploymentDateTime | string | Date/time of deployment. Optional parameter, defaults to utcNow(), used to compute a semi-unique deployment name. |

### main.nsg.bicepparam
| Parameter Name | Type | Description |
| -------------- | ---- | ----------- |
| workloadName | string | The name of this workload. This is used for computing resource names in the form of `<workloadName>-<environmentSuffix>-<resource type>`. |
| environmentSuffix | string | The name or abbreviation of the environment where resources will be provisioned. This is used for computing resource names in the form of `<workloadName>-<environmentSuffix>-<resource type>`. |
| location | string | The region where resources will be provisioned. |
| deploymentDateTime | string | Date/time of deployment. Optional parameter, defaults to `utcNow()`, used to compute a semi-unique deployment name. |

## Deploying
1. Clone this repository to your local machine.
2. Edit the parameter files to specify the values you want to use
3. Run the `Deploy-Nsg.ps1` script to deploy the NSG and attach it to a subnet.
4. Run the `Deploy-Apim.ps1` script to deploy the API Management instance.

**Note, Azure API Management can take 25+ minutes to deploy, so be patient on step #4.**

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.