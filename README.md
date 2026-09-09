# Intune Local Device Attributes

Configure 25 free-form local Windows device attributes through Microsoft Intune using an imported ADMX policy.

Current release: **v1.0.0**

Intune Local Device Attributes provides a simple device-wide context layer for scripts, applications and remediations. Your organization decides what every attribute means and which values are allowed.

## What it does

The administrative template exposes 25 independent machine policies:

- Custom Attribute 01
- Custom Attribute 02
- ...
- Custom Attribute 25

Each enabled policy accepts a free-form text value. Values are stored as `REG_SZ` under:

```text
HKEY_LOCAL_MACHINE\SOFTWARE\Policies\IntuneLocalDeviceAttributes
```

Example:

```text
Attribute01 = Contoso
Attribute02 = MultiUser
Attribute03 = FrontOffice
```

The names and examples are intentionally generic. You can use the attributes for customer codes, device roles, locations, environments, deployment variants or any other local decision your automation needs.

## Why

Some scripts need to know what a device is intended for before they run. Native Intune properties do not always provide that business context locally. These attributes make centrally managed context available in the Windows registry without requiring a script to query Microsoft Graph.

Typical use cases include:

- Scoping a Win32 app with a requirement script
- Selecting an application configuration variant
- Including or excluding a device from remediation logic
- Adding centrally managed context to local diagnostics
- Selecting a maintenance or deployment ring

## Import into Intune

For Microsoft's complete import procedure and current platform limitations, see
[Import custom ADMX and ADML administrative templates into Microsoft Intune](https://learn.microsoft.com/en-us/intune/device-configuration/settings-catalog/import-custom-admx-templates).
Microsoft currently documents this feature as public preview and supports only
`en-US` ADML language files.

1. Open the Microsoft Intune admin center.
2. Go to **Devices** > **Manage devices** > **Configuration**.
3. Open **Import ADMX**.
4. Import `PolicyDefinitions/IntuneLocalDeviceAttributes.admx`.
5. Upload `PolicyDefinitions/en-US/IntuneLocalDeviceAttributes.adml` when requested.
6. Create a configuration profile for **Windows 10 and later** using **Templates** > **Imported Administrative templates**.
7. Configure one or more attributes and assign the profile to a device group.

The settings are located under **Intune Local Device Attributes** > **Attributes**.

## Read an attribute

Directly from the registry:

```powershell
$customerCode = Get-ItemPropertyValue `
    -Path 'HKLM:\SOFTWARE\Policies\IntuneLocalDeviceAttributes' `
    -Name 'Attribute01'
```

Or use the included helper:

```powershell
. .\PowerShell\Get-IntuneLocalDeviceAttribute.ps1

Get-IntuneLocalDeviceAttribute -Number 1
Get-IntuneLocalDeviceAttribute
```

The second command returns all configured attributes.

## Behavior

- Policies apply in the device context.
- Enabling a policy writes its text value to the registry.
- Changing a configured value updates the existing registry value without requiring a restart.
- Setting a policy to **Disabled** or **Not configured** removes the corresponding registry value.
- Unconfigured attributes are not created.
- Empty values are rejected by the Intune configuration interface.
- Each attribute accepts up to 1,023 characters. Values of that length are written completely and unchanged.
- Spaces, punctuation and Unicode characters are preserved.
- The same attributes are visible from both 32-bit and 64-bit PowerShell.
- Removing a profile assignment or deleting the profile removes the values managed by that profile. If no values remain, Windows also removes the registry key.
- If two profiles configure the same attribute with different values, Intune reports a conflict and the conflicting registry value is removed. Other non-conflicting attributes remain applied.
- Attribute values are local data and are not automatically added to Intune inventory.
- Intune assignment filters and Microsoft Entra dynamic groups cannot directly evaluate these registry values.
- Do not store passwords, tokens or other secrets in these attributes.

## ESP and provisioning

Device-scoped attributes have been observed to become available during the Enrollment Status Page device setup phase and before tested device-targeted Win32 applications were installed. Intune does not document a guaranteed processing order between an imported ADMX profile and a Win32 app. Applications should therefore handle a temporarily missing attribute cleanly.

## FAQ

### Where are the attributes stored?

They are stored as `REG_SZ` values named `Attribute01` through `Attribute25` under:

```text
HKEY_LOCAL_MACHINE\SOFTWARE\Policies\IntuneLocalDeviceAttributes
```

### What happens when a value is changed?

The existing registry value is updated after the device processes the new policy. A restart is not required.

### Can an enabled attribute contain an empty value?

No. The Intune configuration interface requires a value and prevents saving an empty field.

### What happens when an attribute is set to Disabled or Not configured?

The corresponding registry value is removed. Other configured attributes under the same key remain present.

### What happens when the profile assignment is removed?

After the device processes the removal, the values managed by that profile are removed. If no values remain, the registry key is also removed.

### What happens when the configuration profile is deleted?

The cleanup behavior is the same as removing its assignment: its managed values are removed and an empty registry key is removed as well. Testing did not show policy tattooing during normal profile removal.

### What happens when two profiles configure the same attribute?

If the profiles specify different values, Intune reports a conflict and Windows removes the conflicting registry value. Other attributes without a conflict remain applied. Avoid assigning conflicting values because the local value must not be treated as available while the conflict exists.

### What is the maximum value length?

Each attribute accepts up to 1,023 characters. The Intune interface prevents saving a longer value. Testing confirmed that a 1,023-character value is stored completely and unchanged.

### Are spaces, punctuation and Unicode supported?

Yes. Testing confirmed that values containing spaces, punctuation and Unicode characters such as `ÄÖÜ` are preserved. Console encoding can affect how characters are displayed in a child process, but it does not change the registry value.

### Can 32-bit applications read the attributes?

Yes. Testing with both 32-bit and 64-bit Windows PowerShell returned the same values from the documented registry path.

### Are the attributes available during the Enrollment Status Page?

They have been observed during the ESP device setup phase before tested device-targeted Win32 applications were installed. Microsoft does not document a guaranteed processing order, so applications should handle a temporarily missing attribute.

### Can Intune filters or Entra dynamic groups use these values?

No. These are local registry values and are not automatically added to Intune inventory. They are intended for local scripts, applications, requirement rules, remediations and diagnostics.

### Can the attributes contain secrets?

They technically contain arbitrary text, but they must not be used for passwords, tokens or other secrets. Local processes and users with sufficient registry access can read them.

## Repository structure

```text
PolicyDefinitions/
  IntuneLocalDeviceAttributes.admx
  en-US/IntuneLocalDeviceAttributes.adml
PowerShell/
  Get-IntuneLocalDeviceAttribute.ps1
Examples/
  01-Win32AppRequirement.ps1
  02-SelectApplicationConfiguration.ps1
  03-RemediationScope.ps1
  04-SupportContext.ps1
  05-MaintenanceRing.ps1
```

## Compatibility

Designed for Windows 10 and Windows 11 devices managed with Microsoft Intune.

## License

This project is licensed under the [MIT License](LICENSE).

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release history.
