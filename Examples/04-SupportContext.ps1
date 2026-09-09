# Example: include all configured attributes in local diagnostic output.

. "$PSScriptRoot\..\PowerShell\Get-IntuneLocalDeviceAttribute.ps1"

$attributes = Get-IntuneLocalDeviceAttribute

if (-not $attributes) {
    Write-Host 'No local device attributes are configured.'
    exit 0
}

$attributes | Format-Table -AutoSize
