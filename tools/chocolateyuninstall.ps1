$packageArgs = @{
    packageName = $env:ChocolateyPackageName
    zipFileName = "$($env:ChocolateyPackageVersion).zip"    
}
Write-Verbose "Uninstall zip: $($packageArgs.zipFileName)"

# different fonts path in the registry depending on os architecture
$regPath = @( 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Fonts', 
    'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
)

# remove the fonts data from the registry path
ForEach ($path in $regPath) {
    (Get-Item -Path $path).property | Where-Object { $_ -like 'Gen Shin Gothic*' } | ForEach-Object { 
        Remove-ItemProperty -Name $_ -Path $path -ErrorAction SilentlyContinue
    }
}

Get-ChildItem -Path "$([Environment]::GetFolderPath('Fonts'))" -Filter 'GenShinGothic-*.otf' | Remove-Item -Force

Write-Warning 'If you receive any errors uninstalling, please reboot and try again to release the font files.'
