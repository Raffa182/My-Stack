# Define your Azure resource group and VM name
$resourceGroupName = "YourResourceGroupName"
$vmName = "YourVMName"

# Shutdown the VM
Stop-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Force

# Wait for the VM to stop (optional, adjust the delay as needed)
Start-Sleep -Seconds 30

# Start the VM
Start-AzVM -ResourceGroupName $resourceGroupName -Name $vmName