<# 
.SYNPOSIS
Example script for reading ini files

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
$Ini = Read-IniFile -IniFile $File

# Print all Sections found in INI file
$Ini.Sections()

# Dump a representation of the parsed INI file
$Ini.Dump()

# Return Section <section> as a hashtable
$Ini.Section("App")
$Ini.Section("Config")
