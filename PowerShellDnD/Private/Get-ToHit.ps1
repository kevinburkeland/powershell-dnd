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

    $attackRolls = Invoke-DiceRoll -Dice 'd20' `
                                   -Count $Attacks `
                                   -Advantage:$Advantage `
                                   -Disadvantage:$Disadvantage

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