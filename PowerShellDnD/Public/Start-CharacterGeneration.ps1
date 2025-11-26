function Start-CharacterGeneration {
    #load the dice module
    . "$PSScriptRoot/../Private/Invoke-DiceRoll.ps1"
    #import player attribute object
    $playerAttrib = Get-Content -Path "$PSScriptRoot/../template/PlayerAttributes.json" | ConvertFrom-Json
    #display user input info
    Write-Host -Object ("Welcome to the D&D character roller written by Kevin Burkeland

    Pick your stat gen style:
    1. Generous: 4d6 drops the lowest and gives you one 18 to start with
    2. Standard: roll 4d6 drops the lowest
    3. Rough: 3d6, thats all you get
    4. Old School: 3d6 Down the line, you don't get to choose
    5. Silly: 1d20 for each stat, you get to choose")
    #get user input
    [int]$Gen = Read-Host -Prompt "Enter your choice [1-5]"
    #switch through the user input
    switch ($Gen) {
        1 {        
            #Generous
            #roll 4d6 and drop the lowest with a free 18
            [System.Collections.ArrayList]$rolls = @(18)
            1..5 | ForEach-Object {
                $roll = @(Invoke-DiceRoll -Dice d6 -Count 4 | Sort-Object -Descending | Select-Object -first 3)
                $roll = $roll | ForEach-Object -Begin { $sum = 0 } -Process { $sum += $_ } -End { $sum }
                $rolls += @($roll)
            }
        }
        2 {
            #Standard
            #roll 4d6 and drop the lowest
            [System.Collections.ArrayList]$rolls = @()
            1..6 | ForEach-Object {
                $roll = @(Invoke-DiceRoll -Dice d6 -Count 4 | Sort-Object -Descending | Select-Object -first 3)
                $roll = $roll | ForEach-Object -Begin { $sum = 0 } -Process { $sum += $_ } -End { $sum }
                $rolls += @($roll)
            }
        }
        3 {
            #Rough
            #roll 3d6
            [System.Collections.ArrayList]$rolls = @()
            1..6 | ForEach-Object {
                $roll = Invoke-DiceRoll -Dice d6 -Count 3
                $roll = $roll | ForEach-Object -Begin { $sum = 0 } -Process { $sum += $_ } -End { $sum }
                $rolls += @($roll)
            }
        }
        4 {
            #Old School
            #roll 3d6 down the line
            1..6 | ForEach-Object {
                $roll = Invoke-DiceRoll -Dice d6 -Count 3
                $roll = $roll | ForEach-Object -Begin { $sum = 0 } -Process { $sum += $_ } -End { $sum }
                $rolls += @($roll)
            }
            for ($i = 0; $i -lt $playerAttrib.Count; $i++) {
                $playerAttrib[$i].Value = $rolls[$i]
            }
        }
        5 {
            #Silly
            #roll 1d20 for each stat
            [System.Collections.ArrayList]$rolls = Invoke-DiceRoll -Dice d20 -Count 6
        }
    }
    #checks to see if there are still attributes to assign
    if (!($playerAttrib[1].Value -gt 0)) {
        #assigns the rolls to the attributes
        for ($i = 0; $i -lt $playerAttrib.Count; $i++) {
            write-host -ForegroundColor Green "Attribute you are choosing:" $playerAttrib[$i].Attribute
            Write-host -ForegroundColor Yellow "Your Options:" $rolls
            [int]$userSelection = Read-Host -Prompt "Enter your choice"
            if ($rolls -contains $userSelection) {
                $playerAttrib[$i].Value = $userSelection
                $rolls.Remove($userSelection)
            }
            else {
                write-host -ForegroundColor Red "invalid selection"
                $i--
            }
        }
    }
    #computes the modifiers
    for ($i = 0; $i -lt $playerAttrib.Count; $i++) {
        [decimal]$mod = ($playerAttrib[$i].Value - 10) / 2
        $playerAttrib[$i].Modifier = [math]::Floor($mod)
    }
    #displays attributes
    $playerAttrib
    #asks if you want to save the character
    $prompt = Read-Host -Prompt "do you want to save this character? [y/n]"
    if ($prompt -eq 'y') {
        #asks for a name
        $charactername = Read-Host -Prompt "Enter your character name"
        $charactername = $charactername -replace " ", "_"
        if (test-path -Path Characters\$charactername) {
            write-host -ForegroundColor Red "Character already exists"
            $overwrite = Read-Host -Prompt "overwrite? [y/n]"
            if ($overwrite -eq 'y') {
                $playerAttrib | ConvertTo-Json -Depth 10 | Set-Content -Path Characters\$charactername\"$charactername"_attributes.json
            }
        }
        else {
            mkdir Characters\$charactername
            $playerAttrib | ConvertTo-Json -Depth 10 | Set-Content -Path Characters\$charactername\"$charactername"_attributes.json
        }
    }
}