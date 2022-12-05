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
Write-Host "[1] Tiny Object
[2] Small Object
[3] Medium Object
[4] Large Object
[5] Huge Object"
[int]$objectSize = Read-Host -Prompt "Enter the size of the objects you are animating"
[int]$targetAC = Read-Host -Prompt "Enter the target AC"
#rolls the requested number of d20s
$attackRoll = $dice.GetD20($objectNum)
switch ($objectSize) {
    1 {
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
    }
    2 {
        for ($i = 0; $i -lt $attackRoll.Count; $i++) {
            if (($attackRoll[$i]+6) -ge $targetAC) {
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
    }
    3 {
        for ($i = 0; $i -lt $attackRoll.Count; $i++) {
            if (($attackRoll[$i]+5) -ge $targetAC) {
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
    }
    4 {
        for ($i = 0; $i -lt $attackRoll.Count; $i++) {
            if (($attackRoll[$i]+6) -ge $targetAC) {
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
    }
    5 {
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
    }
    Default { Write-Host "Invalid size, select a number 1-5" }
}
#writes out the number of hits
write-host -ForegroundColor Yellow "You hit" $numHit "times"
write-host -ForegroundColor Yellow "You get" $bonusDice "set of bonus crit damage dice"
#adds the bonus dice to the number of hits
[int]$totalDice = $numHit + $bonusDice
#calculates the damage

#subtracts the hit damage from crit dice
switch ($objectSize) {
    1 {
        [int]$damage = $dice.GetD4($totalDice)|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_+4} -End {$sum}
        $damage = $damage - ($bonusDice * 4)
    }
    2 {
        [int]$damage = $dice.GetD8($totalDice)|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_+2} -End {$sum}
        $damage = $damage - ($bonusDice * 2)
    }
    3 {
        [int]$damage = $dice.GetD6($totalDice * 2)|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_+1} -End {$sum}
        $damage = $damage - ($bonusDice * 1)
    }
    4 {
        [int]$damage = $dice.GetD10($totalDice * 2)|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_+2} -End {$sum}
        $damage = $damage - ($bonusDice * 2)
    }
    5 {
        [int]$damage = $dice.GetD12($totalDice * 2)|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_+4} -End {$sum}
        $damage = $damage - ($bonusDice * 4)
    }
}
#write out the damage
write-host -ForegroundColor Yellow "Your total damage is" $damage