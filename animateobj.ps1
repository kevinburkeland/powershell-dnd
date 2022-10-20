#Created By Kevin Burkeland
using module ./dice.psm1
$dice = [Dice]::new()

[int]$numHit=0
[int]$bonusDice=0
write-host -ForegroundColor Green "Welcome to the D&D Animate Object Damage Automater"
[int]$objectNum = Read-Host -Prompt "Enter the number of objects you are animating"
[int]$targetAC = Read-Host -Prompt "Enter the target AC"
$attackRoll = $dice.GetD20($objectNum)
for ($i = 0; $i -lt $attackRoll.Count; $i++) {
    if (($attackRoll[$i]+8) -ge $targetAC) {
        $numHit++
        if ($attackRoll[$i] -eq 20) {
            $bonusDice++
        }
    }
    elseif ($attackRoll[$i] -eq 20) {
        $numHit++
    }
}
write-host -ForegroundColor Yellow "You hit" $numHit "times"
write-host -ForegroundColor Yellow "You get" $bonusDice "bonus damage dice"
[int]$totalDice = $numHit + $bonusDice
[int]$damage = $dice.GetD4($totalDice)|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_+4} -End {$sum}
write-host -ForegroundColor Yellow "Your total damage is" $damage