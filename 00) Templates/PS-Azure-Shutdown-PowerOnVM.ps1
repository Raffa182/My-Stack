# Define your Azure resource group and VM name
$vm_name = Read-Host -Prompt 'Input your VM name'
$rg_name = Read-Host -Prompt 'Input your Resource Group name'

# Shutdown the VM
Stop-AzVM -ResourceGroupName $rg_name -Name $vm_name -Force

# Wait for the VM to stop (optional, adjust the delay as needed)
Start-Sleep -Seconds 30

# Start the VM
Start-AzVM -ResourceGroupName $rg_name -Name $vm_name