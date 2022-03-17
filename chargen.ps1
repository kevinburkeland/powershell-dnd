using module ./dice.psm1
$dice = [Dice]::new()
[int]$sum
Write-Host -Object ("Welcome to the D&D character roller written by Kevin Burkeland

Pick your stat gen style:
1. Generous: 4d6 drops the lowest and gives you one 18 to start with
2. Standard: roll 4d6 drops the lowest
3. Rough: 3d6, thats all you get
4. Old School: 3d6 Down the line, you don't get to choose")
[int]$Gen = Read-Host -Prompt "Enter your choice [1-4]"
switch ($Gen) {
    1 {        
        $attributes = @(18)
        1..5|ForEach-Object{
            $rolls = @()
            1..4|ForEach-Object{
                $rolls += @($dice.GetD6())
            }
            $roll = @($rolls|Sort-Object -Descending|Select-Object -first 3)
            $roll = $roll|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_} -End {$sum}
           $attributes += @($roll)
        }
    }
    2 {
        $attributes = @()
        1..6|ForEach-Object{
            $rolls = @()
            1..4|ForEach-Object{
                $rolls += @($dice.GetD6())
            }
            $roll = @($rolls|Sort-Object -Descending|Select-Object -first 3)
            $roll = $roll|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_} -End {$sum}
           $attributes += @($roll)
        }
    }
    3 {
        $attributes = @()
        1..6|ForEach-Object{
            $rolls = @()
            1..3|ForEach-Object{
                $rolls += @($dice.GetD6())
            }
            $roll = $rolls|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_} -End {$sum}
           $attributes += @($roll)
        }
    }
    4 {"bonk 4"}
}
$attributes |Where-Object {$_}