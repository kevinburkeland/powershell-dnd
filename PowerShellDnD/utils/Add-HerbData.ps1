param(
    [Parameter(Mandatory = $true)]
    [string]$Biome,

    [Parameter(Mandatory = $true)]
    [string]$Rarity
)

$jsonPath = Join-Path -Path $PSScriptRoot -ChildPath "../PowerShellDnD/Data/herbs.json"
$ondeckPath = Join-Path -Path $PSScriptRoot -ChildPath "ondeck.txt"

# Load existing herbs
if (Test-Path $jsonPath) {
    $herbs = Get-Content -Path $jsonPath | ConvertFrom-Json
}
else {
    Write-Error "herbs.json not found at $jsonPath"
    exit
}

# Ensure the structure exists
if (-not $herbs.PSObject.Properties[$Biome]) {
    $herbs | Add-Member -MemberType NoteProperty -Name $Biome -Value @{}
}
if (-not $herbs.$Biome.PSObject.Properties[$Rarity]) {
    $herbs.$Biome | Add-Member -MemberType NoteProperty -Name $Rarity -Value @()
}

# Read new herbs from ondeck.txt
if (Test-Path $ondeckPath) {
    $newHerbs = Get-Content -Path $ondeckPath
    
    foreach ($herb in $newHerbs) {
        if (-not [string]::IsNullOrWhiteSpace($herb)) {
            # Add if not already present to avoid duplicates
            if ($herbs.$Biome.$Rarity -notcontains $herb) {
                $herbs.$Biome.$Rarity += $herb
                Write-Host "Added '$herb' to $Biome - $Rarity"
            }
            else {
                Write-Warning "'$herb' already exists in $Biome - $Rarity"
            }
        }
    }
}
else {
    Write-Error "ondeck.txt not found at $ondeckPath"
    exit
}

# Save back to JSON
$herbs | ConvertTo-Json -Depth 10 | Set-Content -Path $jsonPath
Write-Host "Successfully updated herbs.json"
