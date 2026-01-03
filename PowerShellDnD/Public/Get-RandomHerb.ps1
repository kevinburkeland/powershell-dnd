function Get-RandomHerb {
    param (
        [int]$Count,
        [string]$Biome
    )

    #imports dice function
    . "$PSScriptRoot/../Private/Invoke-DiceRoll.ps1"
    #imports herb data
    $herbs = Get-Content -Path "$PSScriptRoot/../Data/herbs.json" | ConvertFrom-Json
    #creates gathered array
    $gathered = @()

    #writes out user info
    if (-not $PsBoundParameters.ContainsKey('Count')) {
        $rolls = Read-Host "how many d100s to roll?"
    }
    else {
        $rolls = $Count
    }
    
    if (-not $PsBoundParameters.ContainsKey('Biome')) {
        $biome = Read-Host "what biome? (arctic, caves, river, forest)"
    }
    
    # Capitalize first letter for consistency with JSON keys if it was passed in lowercase
    if ($biome) {
        $textInfo = (Get-Culture).TextInfo
        $biome = $textInfo.ToTitleCase($biome.ToLower())
    }
    #rolls d100s
    $results = Invoke-DiceRoll -Dice d100 -Count $rolls
    #sorts results
    $results | ForEach-Object {
        if ($_ -in 1..39) {
            $gathered += $herbs.$biome.Common | Get-Random
        }
        elseif ($_ -in 40..65) {
            $gathered += $herbs.$biome.Uncommon | Get-Random
        }
        elseif ($_ -in 66..80) {
            $gathered += $herbs.$biome.SemiRare | Get-Random
        }
        elseif ($_ -in 81..94) {
            $gathered += $herbs.$biome.Rare | Get-Random
        }
        elseif ($_ -in 95..98) {
            $gathered += $herbs.$biome.UltraRare | Get-Random
        }
        elseif ($_ -in 99..100) {
            $gathered += $herbs.$biome.Legendary | Get-Random
        }    
    }
    #displays results
    $gathered | Sort-Object | group-object | Select-Object name, count
}