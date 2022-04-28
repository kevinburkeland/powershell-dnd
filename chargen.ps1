using module ./dice.psm1
$dice = [Dice]::new()

$playerAttrib = @(
    [pscustomobject]@{Attribute='Strength';Value='0';Modifier='0'}
    [pscustomobject]@{Attribute='Dexterity';Value='0';Modifier='0'}
    [pscustomobject]@{Attribute='Constitution';Value='0';Modifier='0'}
    [pscustomobject]@{Attribute='Intelligence';Value='0';Modifier='0'}
    [pscustomobject]@{Attribute='Wisdom';Value='0';Modifier='0'}
    [pscustomobject]@{Attribute='Charisma';Value='0';Modifier='0'}
)

Write-Host -Object ("Welcome to the D&D character roller written by Kevin Burkeland

Pick your stat gen style:
1. Generous: 4d6 drops the lowest and gives you one 18 to start with
2. Standard: roll 4d6 drops the lowest
3. Rough: 3d6, thats all you get
4. Old School: 3d6 Down the line, you don't get to choose
5. Silly: 1d20 for each stat, you get to choose")
[int]$Gen = Read-Host -Prompt "Enter your choice [1-5]"
switch ($Gen) {
    1 {        
        [System.Collections.ArrayList]$rolls = @(18)
        1..5|ForEach-Object{
            $roll = @($dice.GetD6(4)|Sort-Object -Descending|Select-Object -first 3)
            $roll = $roll|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_} -End {$sum}
            $rolls += @($roll)
        }
    }
    2 {
        [System.Collections.ArrayList]$rolls = @()
        1..6|ForEach-Object{
            $roll = @($dice.GetD6(4)|Sort-Object -Descending|Select-Object -first 3)
            $roll = $roll|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_} -End {$sum}
            $rolls += @($roll)
        }
    }
    3 {
        [System.Collections.ArrayList]$rolls = @()
        1..6|ForEach-Object{
            $roll = $dice.GetD6(3)
            $roll = $roll|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_} -End {$sum}
            $rolls += @($roll)
        }
    }
    4 {
        1..6|ForEach-Object{
            $roll = $dice.GetD6(3)
            $roll = $roll|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_} -End {$sum}
           $rolls += @($roll)
        }
        for ($i = 0; $i -lt $playerAttrib.Attributes.Count; $i++) {
            $playerAttrib[$i].Value = $rolls[$i]
        }
    }
    5   {
        $rolls = $dice.GetD20(6)
        }
}
if (!($playerAttrib[1].Value -gt 0)) {
    for ($i = 0; $i -lt $playerAttrib.Attributes.Count; $i++) {
        write-host -ForegroundColor Green "Attribute you are choosing:" $playerAttrib[$i].Attribute
        Write-host -ForegroundColor Yellow "Your Options:" $rolls
        [int]$userSelection = Read-Host -Prompt "Enter your choice"
        if ($rolls -contains $userSelection) {
            $playerAttrib[$i].Value = $userSelection
            $rolls.Remove($userSelection)
        } else {
            write-host -ForegroundColor Red "invalid selection"
            $i--
        }
    }
}
for ($i = 0; $i -lt $playerAttrib.Attributes.Count; $i++) {
    [decimal]$mod=($playerAttrib[$i].Value -10)/ 2
    $playerAttrib[$i].Modifier = [math]::Floor($mod)
}
$playerAttrib