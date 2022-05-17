using module ./dice.psm1
$dice = [Dice]::new()
$herbs = Import-Clixml -Path .\Data\herbs.xml

$rolls = Read-Host "how many rolls?"
$biome = Read-Host "what biome? (river, forest)"
$results=$dice.GetD100($rolls)
$results|ForEach-Object {
    if ($_ -in 1..39) {
        $herbs | Where-Object Biome -like $biome | Where-Object Rarity -like "common" | Get-Random
    }
    elseif ($_ -in 40..65) {
        $herbs | Where-Object Biome -like $biome | Where-Object Rarity -like "uncommon" | Get-Random
    }
    elseif ($_ -in 66..80) {
        $herbs | Where-Object Biome -like $biome | Where-Object Rarity -like "semirare" | Get-Random
    }
    elseif ($_ -in 81..94) {
        $herbs | Where-Object Biome -like $biome | Where-Object Rarity -like "rare" | Get-Random
    }
    elseif ($_ -in 95..98) {
        $herbs | Where-Object Biome -like $biome | Where-Object Rarity -like "ultrarare" | Get-Random
    }
    elseif ($_ -in 99..100) {
        $herbs | Where-Object Biome -like $biome | Where-Object Rarity -like "legendary" | Get-Random
    }    
}
