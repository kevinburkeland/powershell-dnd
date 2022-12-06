#imports herb data (run once at beginning of adding new biomes)
#$herbs = Import-Clixml -Path .\Data\herbs.xml
#build the object
Get-Content -Path .\ondeck.txt|ForEach-Object {
    $herbs += New-Object psobject -Property @{
        Name = $_
        Rarity = "Legendary"
        Biome = "Caves"
    }
}
#export the object (run once at end of adding new biomes)
#$herbs|Export-Clixml -Path .\Data\herbs.xml