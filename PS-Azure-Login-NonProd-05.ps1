<#
  .SYNOPSIS
  Performs monthly data updates.

  .DESCRIPTION
  The .ps1 script .

  .LINK
  https://github.com/Raffa182

#>

# Change Title for PG-NA-Enterprise-NonProd-05
$host.ui.RawUI.WindowTitle = "PG-NA-Enterprise-NonProd-05"

# Login to PG-NA-Enterprise-NonProd-05
Connect-AzAccount -SubscriptionId "2aeadce5-5c3b-454c-8f9d-2cf54bbe04a5"
