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

# Return Section <section> as a hashtable
$Ini.Section("App")
$Ini.Section("Config")

# Add section at the beginning with one key value pair
$Ini.InsertSection("First", @{ First = "Some stuff"})

# Add an empty section at the end
$Ini.AddSection("Trailer")

# Add a key value pair to section "Trailer"
$Ini.Section('Trailer').Add("Nearly the End", "This is not yet the end")
$Ini.Section('Trailer').Add("End", "This is the end")

# Dump a representation of the parsed INI file
$Ini.Dump()
