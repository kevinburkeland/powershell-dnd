using module ./dice.psm1

function Get-ToHit {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateRange(1, 200)]
        [int]$Attacks,

        [Parameter(Mandatory)]
        [ValidateRange(1, 40)]
        [int]$AC,

        [Parameter(Mandatory)]
        [ValidateRange(0, 20)]
        [int]$Bonus,

        [bool]$Advantage = $false,
        [bool]$Disadvantage = $false
    )

    $dice = [Dice]::new()
    $attackRolls = @()

    if (!(($Advantage) -xor ($Disadvantage))) {
        $attackRolls = $dice.GetD20($Attacks)
    }
    else {
        # Roll two sets of dice for all attacks
        $rolls1 = $dice.GetD20($Attacks)
        $rolls2 = $dice.GetD20($Attacks)

        # Determine which roll to take for each attack
        $comparisonOperator = if ($Advantage) { '-gt' } else { '-lt' }
        for ($i = 0; $i -lt $Attacks; $i++) {
            $attackRolls += if (Invoke-Expression "$($rolls1[$i]) $comparisonOperator $($rolls2[$i])") { $rolls1[$i] } else { $rolls2[$i] }
        }
    }

    $numHit = 0
    $bonusDice = 0

    foreach ($roll in $attackRolls) {
        # A natural 1 always misses.
        if ($roll -eq 1) { continue }

        # A natural 20 always hits and is a critical.
        if ($roll -eq 20) {
            $numHit++
            $bonusDice++
            continue
        }

        # Check if the roll plus bonus meets or beats the AC.
        if (($roll + $Bonus) -ge $AC) {
            $numHit++
        }
    }
    return $numHit, $bonusDice, $attackRolls
}