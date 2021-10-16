<# 
.DESCRIPTION
Small script to set the default browser in HKCU to a browser of choice. `
This script was originally conceived in an virtual environment where each `
login spawned a new machine an the user settings were not kept across
sessions. 

.PARAMETER BrowserName
Currently these browsers are supported:
  * Firefox
  * Chrome 
#>

Param (
  [String] $BrowserName = "Firefox" 
)

# -----------------------------------------------------------------------------
# Classes
# -----------------------------------------------------------------------------
class Browser {
  [String] $AppPath
  [String] $DefaultIcon  = "{0},1" -f $This.AppPath
  [String] $ShellCommand = '"{0}" "%1"' -f $This.AppPath
}
  
class Firefox : Browser {
  [String] $AppPath      = "$env:ProgramFiles\Mozilla Firefox\firefox.exe" 
  [String] $ShellCommand = '"{0}" -osint -url "%1"' -f $This.AppPath
}

class Chrome : Browser {
  [String] $AppPath = "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
}

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------
Function Create-RegistryTree() {
  Param(
    [String] $Protocol,
    [Object] $WebBrowser
  )
  $RootKey = "HKCU:\Software\Classes\$Protocol"

  # First recursivly remove the key
  If (Test-Path $RootKey) {
    Remove-Item -Path $RootKey -Recurse
  }

  # 
  New-Item -Path "$RootKey"
  New-ItemProperty -Path $RootKey `
    -Name 'URL Protocol' -PropertyType String -Value ''
  New-ItemProperty -Path $RootKey `
    -Name 'EditFlags' -PropertyType Dword -Value '00000002'

  New-Item -Path "$RootKey\DefaultIcon"
  New-ItemProperty -Path "$RootKey\DefaultIcon" `
    -Name '(Default)' -PropertyType String -Value $WebBrowser.DefaultIcon

  New-Item -Path "$RootKey\shell"
  New-ItemProperty -Path "$RootKey\shell" `
    -Name '(Default)' -PropertyType String -Value 'open'

  New-Item -Path "$RootKey\shell\open"
  New-Item -Path "$RootKey\shell\open\command"
  New-ItemProperty -Path "$RootKey\shell\open\command" `
    -Name '(Default)' -PropertyType String -Value $WebBrowser.ShellCommand

  New-Item -Path "$RootKey\shell\open\command\ddeexec"
  New-ItemProperty -Path "$RootKey\shell\open\command\ddeexec" `
    -Name '(Default)' -PropertyType String -Value ''
}

Function DefaultBrowser() {
  Param(
    [String] $BrowserName
  )
  # This is pretty shitty but I haven't found a way
  # to initiate a class without litterally calling it
  $WebBrowser = Switch ($BrowserName) {
    'Chrome'  { [Chrome]::new(); Break; }
    Default { [Firefox]::new() }
  }

  ('ftp', 'http', 'https') | Foreach-Object {
    Create-RegistryTree -Protocol $_ -WebBrowser $WebBrowser
  }
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
DefaultBrowser -BrowserName $BrowserName
