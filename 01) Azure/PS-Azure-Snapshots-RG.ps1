# Get-Date para SnapshotName
$currentDate = Get-Date -Format "yyyyMMdd"

# Cambia el titulo de PS por PG-NA-Enterprise-Prod-05
$host.ui.RawUI.WindowTitle = "PG-NA-Enterprise-Prod-05"

# Login PG-NA-Enterprise-Prod-05
Connect-AzAccount -SubscriptionId "c94548cf-d314-4bd5-abd2-eee92de2aab7"

# Array de las VM dentro de la Subscripcion.
$vmList = Get-AzVM

# Aca arranca la magia
foreach ($vm in $vmList) {
    # Informacion de OS Disk / DataDisks
    $osDisk = $vm.StorageProfile.OsDisk
    $dataDisks = $vm.StorageProfile.DataDisks

    # Snapshot del OS Disk
    $snapshotName = "$($vm.Name)-Backup-OSDisk-$currentDate"
    New-AzSnapshotConfig -SourceUri $osDisk.ManagedDisk.Id -CreateOption Copy -Location $vm.Location -SnapshotName $snapshotName | New-AzSnapshot

    Write-Output "Snaptshot creado para $($vm.Name) - OSDisk"

    # Snapshot de los DataDisks
    foreach ($dataDisk in $dataDisks) {
        $snapshotName = "$($vm.Name)-Backup-DataDisk-$($dataDisk.Lun)-$currentDate"
        New-AzSnapshotConfig -SourceUri $dataDisk.ManagedDisk.Id -CreateOption Copy -Location $vm.Location -SnapshotName $snapshotName | New-AzSnapshot

        Write-Output "Snaptshot creado para $($vm.Name) - DataDisk $($dataDisk.Lun)"
    }
}

# See you later Azure!
Disconnect-AzAccount