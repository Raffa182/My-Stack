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

# Ask if you want to start the VMs again
$choice = Read-Host -Prompt 'Do you want to start the VMs again? (Y/N)'
if ($choice -eq 'Y' -or $choice -eq 'y') {
    foreach ($vm_name in $vm_name_array) {
        Start-AzVM -ResourceGroupName $rg_name -Name $vm_name.Trim()
    }
} else {
    Write-Host 'No VMs will be started.'
}
