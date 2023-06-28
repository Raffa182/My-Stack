# Install the Azure PowerShell module if not already installed
if (-not (Get-Module -Name Az -ListAvailable)) {
    Install-Module -Name Az -Scope CurrentUser -Force -AllowClobber
}

# Import the Azure PowerShell module
Import-Module -Name Az

# Sign in to Azure
Connect-AzAccount

# Subscription IDs
$subscription1 = Select-AzSubscription -SubscriptionName "PG-NA-External-Prod-05"
$subscription2 = Select-AzSubscription -SubscriptionName "PG-NA-External-NonProd-05"

# Subscription Option
Write-Host "Seleccione una suscripción:"
Write-Host "1. $($subscription1.Name)"
Write-Host "2. $($subscription2.Name)"

# Choose one
$choice = Read-Host "Ingrese el número de la suscripción (1 o 2)"

# Validation
if ($choice -eq "1") {
    $subscriptionId1
    Write-Host "La suscripción $($subscription1) ha sido seleccionada."
}
elseif ($choice -eq "2") {
    $subscriptionId2
    Write-Host "La suscripción $($subscription2) ha sido seleccionada."
}
else {
    Write-Host "Opción inválida. No se ha seleccionado ninguna suscripción."
}
