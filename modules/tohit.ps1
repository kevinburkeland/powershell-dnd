using module ./dice.psm1
$dice = [Dice]::new()
function Get-ToHit {
    [CmdletBinding()]
    param (
        [int]$Attacks,
        [int]$AC,
        [int]$Bonus
    )
    $attackRoll = $dice.GetD20($Attacks)
    $numHit = 0
    $bonusDice = 0
    for ($i = 0; $i -lt $attackRoll.Count; $i++) {
        if (($attackRoll[$i]+$Bonus) -ge $AC) {
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
    $numHit, $bonusDice
}