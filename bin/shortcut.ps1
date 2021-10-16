<# 
.DESCRIPTION
A script adding shortcuts to the Windows Menu for programs and apps
outside of the installation path.

There are two modi. One for shortcuts of Windows executables and a
wrapper function for Powershell scripts.
#>

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
$MenuDir = "$env:AppData\Microsoft\Windows\Start Menu\Programs"

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------
Function Create-Shortcut() {
  Param(
    [String] $Path, 
    [String] $Command,
    [String] $Arguments = $Null,
    [Int]    $WindowStyle = 4  # 4 = Normal
  )

  If (!($Path -like "*.lnk")) {
    $Path = $Path + ".lnk"
  }

  Write-Host "Creating shortcut '$Path'"
  $WScriptShell         = New-Object -ComObject WScript.Shell
  $Shortcut             = $WScriptShell.CreateShortcut($Path)
  $Shortcut.Targetpath  = $Command
  $Shortcut.Arguments   = $Arguments
  $Shortcut.WindowStyle = $WindowStyle
  $Shortcut.Save()
}

Function Create-PowershellShortcut() {
  Param(
    [String] $Path,
    [String] $Script,
    [String] $Arguments = $Null
  )

  Create-Shortcut `
    -Path $Path `
    -Command (Get-Command Powershell).Source `
    -Arguments "-ExecutionPolicy ByPass -File ""$Script"" $Arguments"
} 

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
Create-PowershellShortcut `
  -Path "$MenuDir\Startup\00_default-browser.lnk" `
  -Script "$PSScriptRoot\default-browser.ps1" `
  -Arguments "-BrowserName Firefox"

Create-PowershellShortcut `
  -Path "$MenuDir\Startup\01_shortcuts.lnk" `
  -Script "$PSScriptRoot\shortcuts.ps1"

# Create-Shortcut `
#  -Path "$MenuDir\Notepad++.lnk" `
#  -Command "C:\AppDir\Notepad++\NotepadPortable.exe"
