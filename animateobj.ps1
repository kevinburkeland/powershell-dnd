#Created By Kevin Burkeland
#imports dice class
using module ./modules/dice.psm1
$dice = [Dice]::new()

#set initial values to zero
[int]$numHit=0
[int]$bonusDice=0
#write out user info
write-host -ForegroundColor Green "Welcome to the D&D Animate Object Damage Automater"
[int]$objectNum = Read-Host -Prompt "Enter the number of objects you are animating"
[int]$targetAC = Read-Host -Prompt "Enter the target AC"
#rolls the requested number of d20s
$attackRoll = $dice.GetD20($objectNum)
#calculates the number of hits
for ($i = 0; $i -lt $attackRoll.Count; $i++) {
    if (($attackRoll[$i]+8) -ge $targetAC) {
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
#writes out the number of hits
write-host -ForegroundColor Yellow "You hit" $numHit "times"
write-host -ForegroundColor Yellow "You get" $bonusDice "bonus damage dice"
#adds the bonus dice to the number of hits
[int]$totalDice = $numHit + $bonusDice
#calculates the damage
[int]$damage = $dice.GetD4($totalDice)|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_+4} -End {$sum}
#subtracts the hit damage from crit dice
$damage = $damage - ($bonusDice * 4)
#write out the damage
write-host -ForegroundColor Yellow "Your total damage is" $damage