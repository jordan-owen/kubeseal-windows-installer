# Create the "C:\bin\kubeseal" directory if it doesn't exist
Write-Host "Creating the 'C:\bin\kubeseal' directory if it doesn't exist..."
New-Item -ItemType Directory -Path "C:\bin\kubeseal" -ErrorAction Ignore

# Get the latest release information from the GitHub API
Write-Host "Retrieving the latest release information from the GitHub API..."
$releaseInfo = Invoke-WebRequest -Uri https://api.github.com/repos/bitnami-labs/sealed-secrets/releases/latest

# Extract the download URL for the Windows kubeseal binary
Write-Host "Extracting the download URL for the Windows kubeseal binary..."
$downloadUrl = ($releaseInfo | ConvertFrom-Json).assets | Where-Object { $_.name -match "^kubeseal-.*-windows-amd64\.tar\.gz$" } | Select-Object -ExpandProperty "browser_download_url"

# Download the kubeseal binary
Write-Host "Downloading the kubeseal binary..."
$tempFile = [System.IO.Path]::GetTempFileName()
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile

# Uncompress the .tar.gz file
Write-Host "Uncompressing the .tar.gz file..."
Invoke-Expression "tar -xvzf $tempFile -C C:\bin\kubeseal"

# Add the "C:\bin\kubeseal" directory to the PATH environment variable
Write-Host "Adding the 'C:\bin\kubeseal' directory to the PATH environment variable..."
[System.Environment]::SetEnvironmentVariable("PATH", "$env:PATH;C:\bin\kubeseal", "User")

# Refresh the PATH
Write-Host "Refreshing the PATH..."
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Test that kubeseal is installed and working
Write-Host "Testing that kubeseal is installed and working..."
$kubesealOutput = Invoke-Expression "kubeseal --version"
Write-Output $kubesealOutput
