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
    Exe  = "TestApp.exe" 
  }
  Config = @{ 
    Theme       = "Rainbow"
    Font        = "Comic Sans"
    "Font Size" = "12"
  }
}

# Initiate INI file for writing 
$Ini = Write-IniFile -IniFile $File -Struct $Config

# Print content in INI format
$Ini.Dump()

# List sections
$Ini.Sections()

# Access Sections
$Ini.Section("App")
$Ini.Section("Config")

# Write to to file
$Ini.Commit()
