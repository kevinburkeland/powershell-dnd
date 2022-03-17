using module ./dice.psm1
$dice = [Dice]::new()

$playerAttrib = [PSCustomObject]@{
    Strength = 0
    Dexterity = 0
    Constitution = 0
    Intelligence = 0
    Wisdom = 0
    Charisma = 0
}

Write-Host -Object ("Welcome to the D&D character roller written by Kevin Burkeland

Pick your stat gen style:
1. Generous: 4d6 drops the lowest and gives you one 18 to start with
2. Standard: roll 4d6 drops the lowest
3. Rough: 3d6, thats all you get
4. Old School: 3d6 Down the line, you don't get to choose")
[int]$Gen = Read-Host -Prompt "Enter your choice [1-4]"
switch ($Gen) {
    1 {        
        $rolls = @(18)
        1..5|ForEach-Object{
            $roll = @($dice.GetD6(4)|Sort-Object -Descending|Select-Object -first 3)
            $roll = $roll|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_} -End {$sum}
           $rolls += @($roll)
        }
    }
    2 {
        $rolls = @()
        1..6|ForEach-Object{
            $roll = @($dice.GetD6(4)|Sort-Object -Descending|Select-Object -first 3)
            $roll = $roll|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_} -End {$sum}
           $rolls += @($roll)
        }
    }
    3 {
        $rolls = @()
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
        $attributes = for ($i = 0; $i -lt 6; $i++) {
            
        }
    }
}
$playerAttrib