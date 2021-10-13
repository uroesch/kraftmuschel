Param(
  [String] $Method,
  [String] $Path,
  [String] $Destination
)

Function Decode-B64() {
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
    Write-Host 'Error converting file'
  }
}

Function Encode-B64() {
  Param(
    [String] $Path,
    [String] $Destination
  )

  #Try {
    $Bytes   = [System.IO.File]::ReadAllBytes($Path)
    $Encoded = [System.Convert]::ToBase64String($Bytes)
    Set-Content -Path $Destination -Value $Encoded
    #[IO.File]::WriteAllBytes($Destination, $Encoded)
  #}
  #Catch {
  #  Write-Host 'Error converting file'
  #}
}

Switch ($Method) {
  "Decode" { Decode-B64 -Path $Path -Destination $Destination }
  Default  { Encode-B64 -Path $Path -Destination $Destination }
}
