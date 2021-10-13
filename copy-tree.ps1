$MenuDir        = "$env:AppData\Microsoft\Windows\Start Menu\Programs"
$ProfileDir     = "$env:HomeDrive\profile"
$PASourceDir    = "$env:HomeDrive\PortableApps"
$PADestDir      = "$env:UserProfile\PortableApps"

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

Function Copy-Tree() {
  Param(
    [String] $Path,
    [String] $Destination
  )
  
  If (!(Test-Path $Destination)) {
    New-Item -Path $Destination -ItemType directory
  }

  $Exclude = Get-ChildItem -Recurse -Depth 0 $Destination
  Write-Host "Copy tree from $Path to $Destination"
  Copy-Item `
    -Verbose `
    -Force ` 
    -Recurse `
    -Path $Path `
    -Destination $Destination `
    -Exclude $Exclude
}

Create-PowershellShortcut `
  -Path "$MenuDir\Startup\00_default-browser.lnk" `
  -Script "$PSScriptRoot\default-browser.ps1" `
  -Arguments "-BrowserName Firefox"

Create-PowershellShortcut `
  -Path "$MenuDir\Startup\01_shortcuts.lnk" `
  -Script "$PSScriptRoot\shortcuts.ps1"

# Create-Shortcut `
#  -Path "$MenuDir\Notepad++.lnk" `
#  -Command "c:\AppDir\Notepad++\NotepadPortable.exe"
