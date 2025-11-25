# powershell-dnd

Scripts for D&D written in PowerShell.

## PowerShellDnD Module

The core functionality is now organized into a PowerShell module located in `PowerShellDnD`.

### Public Functions

*   `Start-CharacterGeneration.ps1`: Generates a character and calculates ability modifiers. Allows saving characters to JSON.
*   `Get-RandomHerb.ps1`: An updated and expanded herb gathering script. Uses `herbs.json` for data.
*   `Start-AnimatedObjectCombat.ps1`: A script for managing animated objects in combat.

### Usage

You can import the module using:
`Import-Module .\PowerShellDnD\PowerShellDnD.psd1`

Or run the scripts directly from the `PowerShellDnD\Public` directory.

## Utilities

*   `utils/Add-HerbData.ps1`: A utility script to add new herbs to `herbs.json`.
    *   Usage: `.\utils\Add-HerbData.ps1 -Biome "Forest" -Rarity "Common"` (reads from `utils/ondeck.txt`)

## Herb Sources

Current Source Materials Include:

*   Narcosa by Neoplastic Press
*   Plants & Fungi of the Realms by B. Simon Smith
*   Magical Plants and Where to Find Them by Jowgen on the Giant in the Playground Forums
*   The Herbalist’s Guide by Shawn Hately, 1997
*   Swordfish Islands: A System Neutral Hexcrawl for Table Top RPGs by Jacob Hurst
*   Mercator’s Guide to Herbs by Mercator
*   Herbalism & Alchemy Fan-Made Supplement by reddit user /u/dalagrath
*   A Collection of Poisons by Assassin Games
*   Poisons for 5th Edition by Matthew Eckart
*   Herbalism in Middle-Earth for D&D 5 by Zer0 Hit Points
*   Coins and Scrolls: OSR Plants, Forests, Gardens, and Dryads by Skerples
*   Plant Folklore: Myths, Magic, and Superstition by Sheila Muckle
*   Plant Myths and Legends by Rebecca Rose Leitten
*   Sacred Plants in Folklore, Religions, Myths and Magick from Annie’s Remedy
*   Mythology & Folklore by Trees for Life
*   Plant Meanings, Symbolism, Folklore and History by Power Flowers

With a lot of creative license and updating from ursablindness.tumblr.com reddit.com/user/NeurotoxicNihilist

Lists compiled by Max

Code by Kevin Burkeland
