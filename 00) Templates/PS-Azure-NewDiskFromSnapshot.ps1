$resourceGroupName = "YourResourceGroupName"
$location = "East US"  # Update with your desired location
$targetZone = "1"  # Update with your desired target availability zone

# Iterate through the snapshots and create new disks
$snapshots = Get-AzSnapshot -ResourceGroupName $resourceGroupName

foreach ($snapshot in $snapshots) {
    $diskName = "RestoredDisk-" + $snapshot.Name.Replace("-", "")  # Adjust the naming as needed
    $diskConfig = New-AzDiskConfig -SourceResourceId $snapshot.Id -CreateOption Copy -Location $location
    $disk = New-AzDisk -Disk $diskConfig -ResourceGroupName $resourceGroupName -DiskName $diskName -Zone $targetZone
    
    Write-Host "Created new disk $diskName based on snapshot $($snapshot.Name) in Zone $targetZone"
}
