<#
.SYNPOSIS
Example script for writing ini files

.PARAMETER File
Path to Ini File
#>

Using Module "..\lib\IniConfig.psm1"

Param(
  [Parameter(mandatory=$True)]
  [String] $File
)

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
$Config = @{
  App = @{
    Name = "TestApp"
    Path = "C:\Program Files\TestApp"
  }
}

# Initiate INI file for writing
$Ini = Write-IniFile -IniFile $File -Struct $Config

# List sections
$Ini.Sections()

# Access Sections
$Ini.Section("App")

# Add Key to existing section app
$Ini.Section("App").Add("Exe", "TestApp.exe")

# Add empty section Config
$Ini.AddSection("Config")
$Ini.Section("Config").Add("Theme", "Night")
$Ini.Section("Config").Add("Font", "Comic Sans")
$Ini.Section("Config").Add("Font Size", 12)

# Update item in Section Config
$Ini.Section("Config")["Theme"] = "Rainbow"

# Print content in INI format
$Ini.Dump()

# Write to to file
$Ini.Commit()
