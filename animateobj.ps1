#Created By Kevin Burkeland
#imports dice class
using module ./modules/dice.psm1
$dice = [Dice]::new()
. ./modules/tohit.ps1


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
switch ($objectSize) {
    1 {
        $hits=Get-ToHit -Attacks $objectNum -AC $targetAC -Bonus 8
    }
    2 {
        $hits=Get-ToHit -Attacks $objectNum -AC $targetAC -Bonus 6
    }
    3 {
        $hits=Get-ToHit -Attacks $objectNum -AC $targetAC -Bonus 5
    }
    4 {
        $hits=Get-ToHit -Attacks $objectNum -AC $targetAC -Bonus 6
    }
    5 {
        $hits=Get-ToHit -Attacks $objectNum -AC $targetAC -Bonus 8
    }
    Default { Write-Host "Invalid size, select a number 1-5" }
}
#writes out the number of hits
write-host -ForegroundColor Yellow "You hit" $hits[0] "times"
write-host -ForegroundColor Yellow "You get" $hits[1] "set of bonus crit damage dice"
#adds the bonus dice to the number of hits
[int]$totalDice = $hits[0] + $hits[1]
#rolls the damage dice
switch ($objectSize) {
    1 {
        [int]$damage = $dice.GetD4($totalDice)|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_+4} -End {$sum}
        $damage = $damage - ($hits[1] * 4)
    }
    2 {
        [int]$damage = $dice.GetD8($totalDice)|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_+2} -End {$sum}
        $damage = $damage - ($hits[1] * 2)
    }
    3 {
        [int]$damage = $dice.GetD6($totalDice * 2)|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_+1} -End {$sum}
        $damage = $damage - ($hits[1] * 1)
    }
    4 {
        [int]$damage = $dice.GetD10($totalDice * 2)|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_+2} -End {$sum}
        $damage = $damage - ($hits[1] * 2)
    }
    5 {
        [int]$damage = $dice.GetD12($totalDice * 2)|ForEach-Object -Begin {$sum=0} -Process {$sum+=$_+4} -End {$sum}
        $damage = $damage - ($hits[1] * 4)
    }
}
#write out the damage
write-host -ForegroundColor Yellow "Your total damage is" $damage