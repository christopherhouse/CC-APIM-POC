param (
    [Parameter(Mandatory = $true)]
    [string]
    $ResourceGroupName
)

Write-Host "** Begining deployment with the following parameters:"
Write-Host "** Resource Group Name: $ResourceGroupName"
Write-Host ""

# Use Az Powershell to deploy the template ../main.apim.bicep with the parameter file
# ../parameters/main.apim.bicepparam to the resource group named $ResourceGroupName.
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName `
    -TemplateFile ../main.apim.bicep `
    -TemplateParameterFile ../parameters/main.apim.bicepparam `
    -Verbose `
    -Force `
    -ErrorAction Stop

Write-Host ""
Write-Host "** Deployment complete"