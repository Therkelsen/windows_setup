$start_path = Write-Output (Get-Location).Path

Set-Location -Path "D:\Downloads"

Write-Output "Cleaning Downloads folder:"
Write-Output $(Get-Location).Path

Write-Output ""

$filesToMove = Get-ChildItem -File | 
Where-Object { 
    $_.Name -match "setup" `
    -or $_.Name -match "install" `
    -or $_.Name -match "download" `
    -or $_.Name -match "\.(msi|exe)$"
} |
Where-Object { 
    $_.Name -notmatch "drive-download" `
    -and $_.Name -notmatch "\.(jpg|jpeg|png|gif|bmp|tiff|webp|raw|heif|svg|ico)" `
    -and $_.Name -notmatch "\.(mp4|avi|mkv|mov|webm|flv|wmv|mpeg|mpg|3gp|m4v)"
}

if($filesToMove.Count -eq 0) {
    Write-Output "No files to move."
    Set-Location -Path $start_path
    exit
}
Write-Output "Moving:"

$filesToMove |
Group-Object Extension | 
Sort-Object Name | 
ForEach-Object {
    Write-Output " = $($_.Name) files"
    $_.Group | Sort-Object Name | ForEach-Object {
        Write-Output "   * $($_.Name)"
    }
}

Write-Host "Are you sure? (Y/N)"
# prompt the user for input, execute the command if the user enters 'Y or nothing', otherwise exit
$answer = Read-Host
if ($answer -eq "Y" -or $answer -eq "y" -or $answer -eq "") {
    Write-Output "Moving files..."
} else {
    Write-Output "Exiting..."
    Set-Location -Path $start_path
    exit
}

$destination = "Installers"
if (-not (Test-Path $destination)) {
    New-Item -ItemType Directory -Name $destination
}

$filesToMove | ForEach-Object {
    Move-Item -Path $_.FullName -Destination $destination
    Write-Output "Moved: $($_.Name) to $destination"
}

Set-Location -Path $start_path