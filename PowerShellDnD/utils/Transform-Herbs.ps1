$jsonPath = ".\Data\herbs.json"
$herbs = Get-Content -Path $jsonPath | ConvertFrom-Json

$newStructure = @{}

foreach ($herb in $herbs) {
    $biome = $herb.Biome
    $rarity = $herb.Rarity
    $name = $herb.Name

    if (-not $newStructure.ContainsKey($biome)) {
        $newStructure[$biome] = @{}
    }
    if (-not $newStructure[$biome].ContainsKey($rarity)) {
        $newStructure[$biome][$rarity] = @()
    }
    $newStructure[$biome][$rarity] += $name
}

$newStructure | ConvertTo-Json -Depth 10 | Set-Content -Path $jsonPath
