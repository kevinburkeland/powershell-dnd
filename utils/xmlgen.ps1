
#build the object
Get-Content -Path C:\Users\kburkelands\Documents\Github\Powershell-dnd\utils\ondeck.txt|ForEach-Object {
    $herbs += New-Object psobject -Property @{
        Name = $_
        Rarity = "Legendary"
        Biome = "Arctic"
    }
}

