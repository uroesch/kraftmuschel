<#
.SYNOPSIS
Small script to en- and decode base64 with powershell

.DESCRIPTION
A script written as a bootstrap helper for getting base64 content on
a windows box.

.PARAMETER Method
Either Encode (default) or Decode.

.PARAMETER Path
Path to file to en- or decode.

.PARAMETER Destination
Path to the output file.

.EXAMPLE
PS> base64.ps1 `
  -Method Encode `
  -Path C:\Putty\putty.exe `
  -Destination  putty.exe.b64

.EXAMPLE
PS> base64.ps1 `
  -Method Decode `
  -Path  putty.exe.b64 `
  -Destination C:\Putty\putty.exe

#>

Param(
  [String] $Method,
  [Parameter(Mandatory=$True)]
    [String] $Path,
  [Parameter(Mandatory=$True)]
    [String] $Destination
)

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------
Function Decode-Base64() {
  Param(
    [String] $Path,
    [String] $Destination
  )
  
  Try {
    $Content = Get-Content -Path $Path -Raw
    $Decoded = [System.Convert]::FromBase64String($Content)
    [IO.File]::WriteAllBytes($Destination, $Decoded)
  }
  Catch {
    Write-Host $_
  }
}

Function Encode-Base64() {
  Param(
    [String] $Path,
    [String] $Destination
  )

  Try {
    $Bytes   = [System.IO.File]::ReadAllBytes($Path)
    $Encoded = [System.Convert]::ToBase64String($Bytes)
    Set-Content -Path $Destination -Value $Encoded
  }
  Catch {
    Write-Host $_
  }
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
Switch ($Method) {
  "Decode" { Decode-Base64 -Path $Path -Destination $Destination }
  Default  { Encode-Base64 -Path $Path -Destination $Destination }
}
