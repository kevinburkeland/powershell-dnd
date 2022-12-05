using module ./dice.psm1
$dice = [Dice]::new()
function Get-Damage {
    param (
        [int]$Sides,
        [int]$NumDice,
        [int]$Bonus,
        [int]$Hits,
        [int]$Crit
    )
    $damage = 0
    $damage = ($dice.roll($sides, ($hits*$numDice)) + ($hits*$bonus)) + ($dice.roll($sides, ($crit*$numDice)))
    $damage = $damage|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_} -End {$sum}
    $damage
}