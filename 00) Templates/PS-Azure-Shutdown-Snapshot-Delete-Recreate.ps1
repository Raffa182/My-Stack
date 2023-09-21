# Define your Azure resource group and VM names
$rg_name = Read-Host -Prompt 'Input your Resource Group name'

# Initialize the $vm_name_array outside of the "Stop VMs" section
$vm_name_array = @()

# Ask if you want to stop one or more VMs
$choice = Read-Host -Prompt 'Do you want to stop one or more VMs? (Y/N)'
if ($choice -eq 'Y' -or $choice -eq 'y') {
    $vm_names = Read-Host -Prompt 'Input VM names (comma-separated for multiple VMs)'

    # Convert the input string to an array of VM names
    $vm_name_array = $vm_names -split ','

    # Create a dictionary to store the VM configurations before deletion
    $vmConfigs = @{}

    # Stop each VM and store its configuration
    foreach ($vm_name in $vm_name_array) {
        $vm = Get-AzVM -ResourceGroupName $rg_name -Name $vm_name.Trim()
        $vmConfigs[$vm.Name] = $vm
        Stop-AzVM -ResourceGroupName $rg_name -Name $vm.Name -Force

        # Wait for each VM to stop (optional, adjust the delay as needed)
        Start-Sleep -Seconds 30
    }
} else {
    Write-Host 'No VMs will be stopped.'
}

# Ask if you want to create snapshots
$choice = Read-Host -Prompt 'Do you want to create snapshots for the stopped VMs? (Y/N)'
if ($choice -eq 'Y' -or $choice -eq 'y') {
    foreach ($vm_name in $vm_name_array) {
        $vm = $vmConfigs[$vm_name.Trim()]
        $currentDate = Get-Date -Format "yyyyMMdd"

        $osDisk = $vm.StorageProfile.OsDisk
        $dataDisks = $vm.StorageProfile.DataDisks
            
        $osSnapshotName = "$($osDisk.Name)-$currentDate"
        $osSnapshotConfig = New-AzSnapshotConfig -SourceUri $osDisk.ManagedDisk.Id -CreateOption Copy -Location $vm.Location
        New-AzSnapshot -Snapshot $osSnapshotConfig -SnapshotName $osSnapshotName -ResourceGroupName $rg_name

        Write-Host "Snapshot created for $($vm.Name) - OSDisk"

        foreach ($dataDisk in $dataDisks) {
            $dataSnapshotName = "$($dataDisk.Name)-Lun-$($dataDisk.Lun)-$currentDate"
            $dataSnapshotConfig = New-AzSnapshotConfig -SourceUri $dataDisk.ManagedDisk.Id -CreateOption Copy -Location $vm.Location
            New-AzSnapshot -Snapshot $dataSnapshotConfig -SnapshotName $dataSnapshotName -ResourceGroupName $rg_name

            Write-Host "Snapshot created for $($vm.Name) - DataDisk $($dataDisk.Lun)"
        }
    }
} else {
    Write-Host 'No snapshots will be created.'
}

# Ask if you want to delete the original VMs
$choice = Read-Host -Prompt 'Do you want to delete the original VMs? (Y/N)'
if ($choice -eq 'Y' -or $choice -eq 'y') {
    foreach ($vm_name in $vm_name_array) {
        Remove-AzVM -ResourceGroupName $rg_name -Name $vm_name.Trim() -Force
    }
} else {
    Write-Host 'No VMs will be deleted.'
}

# Ask for the zone for the new VMs
$zone = Read-Host -Prompt 'Input the zone for the new VMs (e.g., 1, 2, 3)'

# Ask if you want to create new VMs in a different or same zone using the snapshots
$choice = Read-Host -Prompt 'Do you want to create new VMs in a different zone using the snapshots? (Y/N)'
if ($choice -eq 'Y' -or $choice -eq 'y') {
    foreach ($vm_name in $vm_name_array) {
        $vm = $vmConfigs[$vm_name.Trim()]
        
        # Define snapshot names based on the original VM names
        $osSnapshotName = "$($vm_name.Trim())-OSDisk-Lun$($osDisk.Lun)-$currentDate"
        $dataSnapshotName = "$($vm_name.Trim())-DataDisk-Lun$($dataDisk.Lun)-$currentDate"

        # Create a new VM configuration based on the snapshots in the target region
        $newVMConfig = New-AzVMConfig -VMName $vm_name.Trim() -VMSize $vm.HardwareProfile.VmSize
        $newVMConfig = Set-AzVMOSDisk -VM $newVMConfig -ManagedDiskId (Get-AzSnapshot -ResourceGroupName $rg_name -SnapshotName $osSnapshotName).Id -CreateOption Attach -Windows
        $newVMConfig = Add-AzVMDataDisk -VM $newVMConfig -Name $vm.StorageProfile.DataDisks.Name -ManagedDiskId (Get-AzSnapshot -ResourceGroupName $rg_name -SnapshotName $dataSnapshotName).Id -Lun $vm.StorageProfile.DataDisks.Lun

        # Set the zone
        $newVMConfig = Set-AzVMZone -VM $newVMConfig -Zone $zone

        # Confirmation prompt
        $confirmChoice = Read-Host -Prompt "Create a new VM named $($vm_name.Trim()) in the same region with the same NIC and snapshots? (Y/N)"
        if ($confirmChoice -eq 'Y' -or $confirmChoice -eq 'y') {
            # Create the new VM in the same region
            $newVM = New-AzVM -ResourceGroupName $rg_name -Location $vm.Location -VM $newVMConfig -Verbose

            # Get the NIC from the original VM
            $originalNIC = Get-AzNetworkInterface -ResourceGroupName $rg_name -Name $vm.NetworkProfile.NetworkInterfaces[0].Id.Split("/")[-1]

            # Attach the original NIC to the new VM
            $newVM.NetworkProfile.NetworkInterfaces[0].Id = $originalNIC.Id
            Update-AzVM -ResourceGroupName $rg_name -VM $newVM -Name $newVM.Name

            Write-Host "New VM $($vm_name.Trim()) created successfully."
        } else {
            Write-Host "Skipping the creation of a new VM for $($vm_name.Trim())."
        }
    }
} else {
    Write-Host 'No new VMs will be created.'
}
