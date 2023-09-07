# Define your Azure resource group and VM names
$rg_name = Read-Host -Prompt 'Input your Resource Group name'

# Ask if you want to stop one or more VMs
$choice = Read-Host -Prompt 'Do you want to stop one or more VMs? (Y/N)'
if ($choice -eq 'Y' -or $choice -eq 'y') {
    $vm_names = Read-Host -Prompt 'Input VM names (comma-separated for multiple VMs)'

    # Convert the input string to an array of VM names
    $vm_name_array = $vm_names -split ','

    # Stop each VM
    foreach ($vm_name in $vm_name_array) {
        Stop-AzVM -ResourceGroupName $rg_name -Name $vm_name.Trim() -Force

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
        $vmList = Get-AzVM -Name $vm_name.Trim() -ResourceGroupName $rg_name
        $currentDate = Get-Date -Format "yyyyMMdd"

        foreach ($vm in $vmList) {
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
    }
} else {
    Write-Host 'No snapshots will be created.'
}

# Ask if you want to start the VMs again
$choice = Read-Host -Prompt 'Do you want to start the VMs again? (Y/N)'
if ($choice -eq 'Y' -or $choice -eq 'y') {
    foreach ($vm_name in $vm_name_array) {
        Start-AzVM -ResourceGroupName $rg_name -Name $vm_name.Trim()
    }
} else {
    Write-Host 'No VMs will be started.'
}
