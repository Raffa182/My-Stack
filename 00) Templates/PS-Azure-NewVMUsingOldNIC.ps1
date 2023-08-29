$resourceGroupName = "YourResourceGroupName"
$location = "East US"  # Update with your desired location
$vmName = "NewVMName"  # Update with your desired VM name
$existingDiskId = "/subscriptions/subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Compute/disks/ExistingDiskName"
$existingNICId = "/subscriptions/subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Network/networkInterfaces/ExistingNICName"

# Create VM configuration
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize "Standard_D2s_v3"

# Attach existing disk to VM
$disk = Get-AzDisk -ResourceGroupName $resourceGroupName -DiskName "ExistingDiskName"
$osDisk = New-AzDiskUpdateConfig -DiskId $disk.Id -CreateOption Attach -Windows

$vmConfig = Set-AzVMOSDisk -VM $vmConfig -ManagedDiskId $disk.Id -CreateOption Attach -Windows

# Attach existing NIC to VM
$nic = Get-AzNetworkInterface -ResourceGroupName $resourceGroupName -Name "ExistingNICName"
$vmConfig = Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id

# Create the virtual machine
New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig
