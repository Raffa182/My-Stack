# Install the Azure PowerShell module if not already installed
if (-not (Get-Module -Name Az -ListAvailable)) {
    Install-Module -Name Az -Scope CurrentUser -Force -AllowClobber
}

# Import the Azure PowerShell module
Import-Module -Name Az

# Sign in to Azure
Connect-AzAccount

# Get the available Azure subscriptions
$subscriptions = Get-AzSubscription

# Prompt the user to select a subscription
Write-Host "Available subscriptions:"
$subscriptions | ForEach-Object {
    Write-Host ("  {0}. {1}" -f $_.Id, $_.Name)
}
$selectedSubscriptionId = Read-Host "Enter the ID of the subscription to use"

# Set the selected subscription as the current subscription
Set-AzContext -SubscriptionId $selectedSubscriptionId

# Display information about the selected subscription
$selectedSubscription = Get-AzSubscription -SubscriptionId $selectedSubscriptionId
Write-Host "Selected subscription:"
$selectedSubscription
