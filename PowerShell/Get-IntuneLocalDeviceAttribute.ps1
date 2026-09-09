function Get-IntuneLocalDeviceAttribute {
    <#
    .SYNOPSIS
        Reads one or all Intune Local Device Attributes.

    .DESCRIPTION
        Reads Attribute01 through Attribute25 from the machine-wide policy
        registry location used by Intune Local Device Attributes.

    .PARAMETER Number
        The attribute number to read. Valid values are 1 through 25.
        If omitted, all configured attributes are returned.

    .EXAMPLE
        Get-IntuneLocalDeviceAttribute -Number 1

    .EXAMPLE
        Get-IntuneLocalDeviceAttribute
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateRange(1, 25)]
        [int]$Number
    )

    $registryPath = 'HKLM:\SOFTWARE\Policies\IntuneLocalDeviceAttributes'

    if (-not (Test-Path -LiteralPath $registryPath)) {
        return
    }

    $properties = Get-ItemProperty -LiteralPath $registryPath

    if ($PSBoundParameters.ContainsKey('Number')) {
        $propertyName = 'Attribute{0:D2}' -f $Number
        return $properties.$propertyName
    }

    1..25 | ForEach-Object {
        $propertyName = 'Attribute{0:D2}' -f $_
        $value = $properties.$propertyName

        if ($null -ne $value) {
            [PSCustomObject]@{
                Number = $_
                Name   = $propertyName
                Value  = $value
            }
        }
    }
}

