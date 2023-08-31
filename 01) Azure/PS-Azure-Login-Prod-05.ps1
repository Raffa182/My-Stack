<#
  .SYNOPSIS
  Performs monthly data updates.

  .DESCRIPTION
  The .ps1 script .

  .LINK
  https://github.com/Raffa182

#>

# Change Title for PG-NA-Enterprise-Prod-05
$host.ui.RawUI.WindowTitle = "PG-NA-Enterprise-Prod-05"

# Login to PG-NA-Enterprise-Prod-05
Connect-AzAccount -SubscriptionId "c94548cf-d314-4bd5-abd2-eee92de2aab7" -DeviceCode
