<#
  .SYNOPSIS
  Performs monthly data updates.

  .DESCRIPTION
  The .ps1 script .

  .LINK
  https://github.com/Raffa182

#>
# Install the Azure PowerShell module if not already installed
#if (-not (Get-Module -Name Az -ListAvailable)) {
#    Install-Module -Name Az -Scope CurrentUser -Force -AllowClobber
#}

# Import the Azure PowerShell module
#Import-Module -Name Az

# Subscription Option
Write-Host "Please select a subscription:"
Write-Host "1. PG-NA-External-Prod-05"
Write-Host "2. PG-NA-External-NonProd-05"

# Choose one
$choice = Read-Host "(1 o 2)"

# Validation
if ($choice -eq "1") {
    # Change Title for PG-NA-Enterprise-Prod-05
    $host.ui.RawUI.WindowTitle = "PG-NA-Enterprise-Prod-05"

    # Login to PG-NA-Enterprise-Prod-05
    Connect-AzAccount -SubscriptionId "c94548cf-d314-4bd5-abd2-eee92de2aab7"
}
elseif ($choice -eq "2") {
    # Change Title for PG-NA-Enterprise-NonProd-05
    $host.ui.RawUI.WindowTitle = "PG-NA-Enterprise-NonProd-05"

    # Login to PG-NA-Enterprise-NonProd-05
    Connect-AzAccount -SubscriptionId "2aeadce5-5c3b-454c-8f9d-2cf54bbe04a5"
}
else {
    Write-Host "Invalid option"
}
