# Example: use Attribute04 as a locally available maintenance ring.

. "$PSScriptRoot\..\PowerShell\Get-IntuneLocalDeviceAttribute.ps1"

$maintenanceRing = Get-IntuneLocalDeviceAttribute -Number 4

$maintenanceWindow = switch ($maintenanceRing) {
    'Early'    { 'Saturday 20:00' }
    'Standard' { 'Sunday 02:00' }
    'Late'     { 'Sunday 05:00' }
    default    { 'Not configured' }
}

Write-Host "Maintenance ring: $maintenanceRing"
Write-Host "Maintenance window: $maintenanceWindow"
