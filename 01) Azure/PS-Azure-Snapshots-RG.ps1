# Cambia el titulo de PS por PG-NA-Enterprise-Prod-05
#$host.ui.RawUI.WindowTitle = "PG-NA-Enterprise-Prod-05"

# Login PG-NA-Enterprise-Prod-05
#Connect-AzAccount -SubscriptionId "c94548cf-d314-4bd5-abd2-eee92de2aab7"

# Backup RG Completo
$rg_name = "AZ-RG-SAP-LAB-EASTUS"
$vmList = Get-AzVM -ResourceGroupName $rg_name

#Backup VM Alone
#$vm_name = ""
#$vmList = Get-AzVM -Name $vm_name -ResourceGroupName $rg_name

# Get the current date
$currentDate = Get-Date -Format "yyyyMMdd"

# Aca arranca la magia
foreach ($vm in $vmList) {
    # Informacion de OS Disk / DataDisks
    $osDisk = $vm.StorageProfile.OsDisk
    $dataDisks = $vm.StorageProfile.DataDisks
    

    # Snapshot del OS Disk
    $osSnapshotName = "$($vm.Name)-Backup-OSDisk-$currentDate"
    $osSnapshotConfig = New-AzSnapshotConfig -SourceUri $osDisk.ManagedDisk.Id -CreateOption Copy -Location $vm.Location
    New-AzSnapshot -Snapshot $osSnapshotConfig -SnapshotName $osSnapshotName -ResourceGroupName $rg_name

    Write-Host "Snapshot creado para $($vm.Name) - OSDisk"

    # Snapshot de los DataDisks
    foreach ($dataDisk in $dataDisks) {
        $dataSnapshotName = "$($vm.Name)-Backup-DataDisk-$($dataDisk.Lun)-$currentDate"
        $dataSnapshotConfig = New-AzSnapshotConfig -SourceUri $dataDisk.ManagedDisk.Id -CreateOption Copy -Location $vm.Location
        New-AzSnapshot -Snapshot $dataSnapshotConfig -SnapshotName $dataSnapshotName -ResourceGroupName $rg_name

        Write-Host "Snapshot creado para $($vm.Name) - DataDisk $($dataDisk.Lun)"
    }
}

# See you later Azure!
#Disconnect-AzAccount