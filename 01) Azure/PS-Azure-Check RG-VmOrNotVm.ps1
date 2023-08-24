<#
  .SYNOPSIS
  Check all RG in one subscription and see if they have or not VM assigned.

  .DESCRIPTION
  N/A

  .LINK
  https://github.com/Raffa182

#>
# Login to Subscription ID

Connect-AzAccount -SubscriptionId "Subscription ID Number"

# Get the list of all RG groups in current SID

$resourceGroups = Get-AzResourceGroup

# Array for the result

$resultList = @()

# Check RGs

foreach ($resourceGroup in $resourceGroups) {

    $groupName = $resourceGroup.ResourceGroupName
    $locationName = $resourceGroup.Location
    $vmList = Get-AzVM -ResourceGroupName $groupName -ErrorAction SilentlyContinue

    if ($vmList) {

        $vms = ($vmList | Select-Object -ExpandProperty Name) -join ', '

    } else {

        $vms = "N/A"

    }

    $resultObject = [PSCustomObject]@{

        "ResourceGroupName" = $groupName
        "Location" = $locationName
        "VirtualMachines" = $vms

    }

    $resultList += $resultObject

}

# Export result to Csv File

$resultList | Export-Csv -Path "C:\Path\AZ-RG-VMorNotVM.csv" -NoTypeInformation -Encoding utf8