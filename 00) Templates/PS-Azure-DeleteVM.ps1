$resourceGroupName = "YourResourceGroupName"
$vmName = "VMNameToDelete"

# Get the virtual machine and its disks
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName
$osDisk = Get-AzDisk -ResourceGroupName $resourceGroupName -DiskName $vm.StorageProfile.OsDisk.Name
$dataDisks = $vm.StorageProfile.DataDisks

# Delete the virtual machine
Remove-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Force

# Delete the OS disk
Remove-AzDisk -ResourceGroupName $resourceGroupName -DiskName $osDisk.Name -Force

# Delete data disks
foreach ($dataDisk in $dataDisks) {
    $diskName = $dataDisk.Name
    Remove-AzDisk -ResourceGroupName $resourceGroupName -DiskName $diskName -Force
}
