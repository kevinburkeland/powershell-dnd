using module ./dice.psm1

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
    $dice = [Dice]::new()
    $totalDiceToRoll = ($Hits * $NumDice) + ($Crit * $NumDice)
    $diceRolls = $dice.roll($Sides, $totalDiceToRoll)
    $totalDamage = ($diceRolls | Measure-Object -Sum).Sum + ($Hits * $Bonus)
    return $totalDamage
}