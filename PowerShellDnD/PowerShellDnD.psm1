# Define paths to the Public and Private folders
$PublicFolderPath = Join-Path -Path $PSScriptRoot -ChildPath "Public"
$PrivateFolderPath = Join-Path -Path $PSScriptRoot -ChildPath "Private"

# Load all private functions first, so public functions can use them
if (Test-Path $PrivateFolderPath) {
    Get-ChildItem -Path $PrivateFolderPath -Filter "*.ps1" -Recurse | ForEach-Object {
        try {
            . $_.FullName
        }
        catch {
            Write-Error "Failed to load private function: $($_.FullName) - $_"
        }
    }
}

# Load all public functions
if (Test-Path $PublicFolderPath) {
    Get-ChildItem -Path $PublicFolderPath -Filter "*.ps1" -Recurse | ForEach-Object {
        try {
            . $_.FullName
        }
        catch {
            Write-Error "Failed to load public function: $($_.FullName) - $_"
        }
    }
}

# Explicitly export only the functions from the Public folder
# This ensures your Private functions stay private
$PublicFunctions = Get-ChildItem -Path $PublicFolderPath -Filter "*.ps1" -Recurse | ForEach-Object {
    $_.BaseName
}
Export-ModuleMember -Function $PublicFunctions