# Example: use Attribute03 to determine whether a remediation should run.

. "$PSScriptRoot\..\PowerShell\Get-IntuneLocalDeviceAttribute.ps1"

$remediationScope = Get-IntuneLocalDeviceAttribute -Number 3

if ($remediationScope -ne 'Enabled') {
    Write-Host 'This device is outside the remediation scope.'
    exit 0
}

Write-Host 'This device is in scope. Start remediation here.'
