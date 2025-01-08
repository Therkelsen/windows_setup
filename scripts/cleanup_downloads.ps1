$start_path = Write-Output (Get-Location).Path

Set-Location -Path "D:\Downloads"

Write-Output "Cleaning Downloads folder:"
Write-Output $(Get-Location).Path

Write-Output ""

# FINDING FILES TO MOVE

$filesToMove = Get-ChildItem -File | 
Where-Object { 
    $_.Name -match "setup|install|download" `
    -or $_.Name -match "\.(msi|exe)$" `
    -or $_.Name -match "\.(torrent)$" `
    -or $_.Name -match "image|photo" `
    -or $_.Name -match "\.(jpg|jpeg|png|gif|bmp|tiff|webp|raw|heif|svg|ico)$" `
    -or $_.Name -match "video" `
    -or $_.Name -match "\.(mp4|avi|mkv|mov|webm|flv|wmv|mpeg|mpg|3gp|m4v)" `
    -or $_.Name -match "\.(pdf|doc|docx|xls|xlsx|ppt|pptx|txt|md|markdown|m|mlx|slx)"
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

Write-Output ""

# MOVING FILES TO DESTINATION FOLDERS

# Ensure the $destinations dictionary has the correct values.
$destinations = @{
    "Installers" = "Installers"
    "Torrents"   = "Torrent"
    "Images"     = "Images"
    "Videos"     = "Videos"
    "Documents"  = "Documents"
}

# Move files to respective folders based on their extension
$filesToMove | ForEach-Object {
    # Define the destination folder based on the file
    if ($_ -match ".torrent$") {
        $destination = $destinations["Torrents"]
    }
    elseif ($_.Name -match "setup|install|download" -or $_.Name -match "\.(msi|exe)$") {
        $destination = $destinations["Installers"]
    }
    elseif ($_.Name -match "image|photo" -or $_.Name -match "\.(jpg|jpeg|png|gif|bmp|tiff|webp|raw|heif|svg|ico)$") {
        $destination = $destinations["Images"]
    }
    elseif ($_.Name -match "video" -or $_.Name -match "\.(mp4|avi|mkv|mov|webm|flv|wmv|mpeg|mpg|3gp|m4v)") {
        $destination = $destinations["Videos"]
    }
    elseif ($_.Name -match "\.(pdf|doc|docx|xls|xlsx|ppt|pptx|txt|md|markdown|m|mlx|slx)") {
        $destination = $destinations["Documents"]
    }
    else {
        $destination = $null
    }

    # Ensure that a valid destination is assigned
    if ($destination) {
        # Check if the destination directory exists, if not, create it
        if (-not (Test-Path $destination)) {
            try {
                New-Item -ItemType Directory -Path $destination -Force
                Write-Output "Created directory: $destination"
            } catch {
                Write-Error "Failed to create directory $(destination): $_"
                return
            }
        }
        
        # Use `-Force` to move the file and ensure paths with special characters are handled
        try {
            Move-Item -LiteralPath $_.FullName -Destination $destination -Force
            Write-Output "Moved: $($_.Name) to $destination"
        } catch {
            Write-Error "Failed to move $($_.Name): $_"
        }
    } else {
        Write-Warning "No valid destination found for $($_.Name)"
    }
}

Set-Location -Path $start_path