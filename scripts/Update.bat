Powershell.exe -NoProfile -Command "Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false; Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser"
Powershell.exe -NoProfile -Command "Get-WindowsUpdate"
Powershell.exe -NoProfile -Command "Install-WindowsUpdate -AcceptAll -Confirm:$false"

winget settings --enable InstallerHashOverride
runas /trustlevel:0x20000 "winget upgrade --all  --include-unknown"