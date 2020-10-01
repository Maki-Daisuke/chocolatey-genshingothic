# This code is derived from https://chocolatey.org/packages/source-han-code-jp
 
# create temp directory
do {
  $tempPath = Join-Path -Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString())
} while (Test-Path $tempPath)
New-Item -ItemType Directory -Path $tempPath | Out-Null

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $tempPath

  url            = 'https://ja.osdn.net/frs/chamber_redir.php?m=ymu&f=%2Fusers%2F8%2F8637%2Fgenshingothic-20150607.zip'
  checksum       = 'B8E00F00A6E2517BFE75CEB2A732B596FE002457B89C05C181D6B71373AADA58'
  checksumType   = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

# Obtain system font folder for extraction
$shell = New-Object -ComObject Shell.Application
$fontsFolder = $shell.Namespace(0x14)

# Loop the extracted files and install them
  Get-ChildItem -Path $tempPath -Recurse -Filter '*.ttf' | ForEach-Object { 
  Write-Verbose "Registering font '$($_.Name)'."
  $fontsFolder.CopyHere($_.FullName)  # copying to fonts folder ignores a second param on CopyHere
}

# Remove our temporary files
Remove-Item $tempPath -Recurse -ErrorAction SilentlyContinue

Write-Warning 'If the fonts are not available in your applications or receive any errors installing or upgrading, please reboot to release the font files.'
