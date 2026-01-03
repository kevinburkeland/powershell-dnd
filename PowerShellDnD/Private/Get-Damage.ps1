

function Get-Damage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateRange(1, 100)]
        [int]$Sides,

        [Parameter(Mandatory)]
        [ValidateRange(1, 100)]
        [int]$NumDice,

        [int]$Bonus = 0,
        [ValidateRange(0, 200)]
        [int]$Hits = 0,
        [ValidateRange(0, 200)]
        [int]$Crit = 0
    )
    
    $totalDiceToRoll = ($Hits * $NumDice) + ($Crit * $NumDice)
    
    if ($totalDiceToRoll -gt 0) {
        $diceRolls = Invoke-DiceRoll -Dice "d$Sides" -Count $totalDiceToRoll
        # Ensure $diceRolls is an array for Measure-Object
        $totalDamage = (@($diceRolls) | Measure-Object -Sum).Sum + ($Hits * $Bonus)
        
        if ($totalDamage -lt 0) {
            $totalDamage = 0
        }
    }
    else {
        $totalDamage = 0
    }
    
    return $totalDamage
}