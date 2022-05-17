
#build the object
Get-Content -Path C:\Users\kburkelands\Documents\GitHub\gatheringdiceroller\river\legendary.txt|ForEach-Object {
    $herbs += New-Object psobject -Property @{
        Name = $_
        Rarity = "Legendary"
        Biome = "River"
    }
}

