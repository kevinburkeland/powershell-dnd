using module ./dice.psm1
$dice = [Dice]::new()
function Get-ToHit {
    [CmdletBinding()]
    param (
        [int]$Attacks,
        [int]$AC,
        [int]$Bonus,
        [bool]$Advantage = $false,
        [bool]$Disadvantage = $false
    )
    if (!($Advantage) -xor ($Disadvantage)) {
        $attackRoll = $dice.GetD20($Attacks)
    }
    elseif ($Advantage) {
        $attackRoll = $dice.GetD20($Attacks)
        $attackRoll2 = $dice.GetD20($Attacks)
        for ($i = 0; $i -lt $attackRoll.Count; $i++) {
            if ($attackRoll2[$i] -gt $attackRoll[$i]) {
                $attackRoll[$i] = $attackRoll2[$i]
            }
        }
    }
    else {
        $attackRoll = $dice.GetD20($Attacks)
        $attackRoll2 = $dice.GetD20($Attacks)
        for ($i = 0; $i -lt $attackRoll.Count; $i++) {
            if ($attackRoll2[$i] -lt $attackRoll[$i]) {
                $attackRoll[$i] = $attackRoll2[$i]
            }
        }
    }
    $numHit = 0
    $bonusDice = 0
    for ($i = 0; $i -lt $attackRoll.Count; $i++) {
        if (($attackRoll[$i]+$Bonus) -gt $AC) {
            $numHit++
            #bonus dice for crits
            if ($attackRoll[$i] -eq 20) {
                $bonusDice++
            }
        }
        #auto hit on 20 if ac too high
        elseif ($attackRoll[$i] -eq 20) {
            $numHit++
        }
    }
    $numHit, $bonusDice, $attackRoll
}