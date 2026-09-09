# Example: use Attribute02 to select an application configuration variant.

. "$PSScriptRoot\..\PowerShell\Get-IntuneLocalDeviceAttribute.ps1"

$configurationVariant = Get-IntuneLocalDeviceAttribute -Number 2

$configurationFile = switch ($configurationVariant) {
    'Standard' { 'configuration-standard.json' }
    'Kiosk'    { 'configuration-kiosk.json' }
    'Shared'   { 'configuration-shared.json' }
    default    { throw "Unsupported configuration variant: $configurationVariant" }
}

Write-Host "Selected configuration: $configurationFile"
