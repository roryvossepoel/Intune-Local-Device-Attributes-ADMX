# Example: use Attribute01 as an application deployment ring.
# Configure the Intune requirement rule to expect the string "True".

. "$PSScriptRoot\..\PowerShell\Get-IntuneLocalDeviceAttribute.ps1"

$requiredValue = 'Pilot'
$actualValue = Get-IntuneLocalDeviceAttribute -Number 1

Write-Output ($actualValue -eq $requiredValue)
exit 0
