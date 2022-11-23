#imports dice class
using module ./modules/dice.psm1
$dice = [Dice]::new()
#imports herb data
$herbs = Import-Clixml -Path .\Data\herbs.xml
#creates gathered array
$gathered = @()

#writes out user info
$rolls = Read-Host "how many d100s to roll?"
$biome = Read-Host "what biome? (arctic, caves, river, forest)"
#rolls d100s
$results=$dice.GetD100($rolls)
#sorts results
$results|ForEach-Object {
    if ($_ -in 1..39) {
        $gathered += $herbs | Where-Object Biome -like $biome | Where-Object Rarity -like "common" | Get-Random
    }
    elseif ($_ -in 40..65) {
        $gathered += $herbs | Where-Object Biome -like $biome | Where-Object Rarity -like "uncommon" | Get-Random
    }
    elseif ($_ -in 66..80) {
        $gathered += $herbs | Where-Object Biome -like $biome | Where-Object Rarity -like "semirare" | Get-Random
    }
    elseif ($_ -in 81..94) {
        $gathered += $herbs | Where-Object Biome -like $biome | Where-Object Rarity -like "rare" | Get-Random
    }
    elseif ($_ -in 95..98) {
        $gathered += $herbs | Where-Object Biome -like $biome | Where-Object Rarity -like "ultrarare" | Get-Random
    }
    elseif ($_ -in 99..100) {
        $gathered += $herbs | Where-Object Biome -like $biome | Where-Object Rarity -like "legendary" | Get-Random
    }    
}
#displays results
$gathered|Sort-Object -Property Name|group-object -Property Name|Select-Object name,count