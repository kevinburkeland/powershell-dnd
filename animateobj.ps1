#Created By Kevin Burkeland
. ./modules/tohit.ps1
. ./modules/damage.ps1

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
$Adv = Read-Host -Prompt "Do you have advantage? [y/n]"
$Adv = switch ($Adv.ToLower) {
    {$_ -in "y","yes"} { $true }
    {$_ -in "n","no"} { $false }
    Default {$false}
}
$Dis = Read-Host -Prompt "Do you have disadvantage? [y/n]"
$Dis = switch ($Dis.ToLower) {
    {$_ -in "y","yes"} { $true }
    {$_ -in "n","no"} { $false }
    Default {$false}
}
#rolls the requested number of d20s
switch ($objectSize) {
    1 {
        $hits=Get-ToHit -Attacks $objectNum -AC $targetAC -Bonus 8 -Advantage $Adv -Disadvantage $Dis
        $damage=Get-Damage -Sides 4 -NumDice 1 -Bonus 4 -Hits $hits[0] -Crit $hits[1]
    }
    2 {
        $hits=Get-ToHit -Attacks $objectNum -AC $targetAC -Bonus 6 -Advantage $Adv -Disadvantage $Dis
        $damage=Get-Damage -Sides 8 -NumDice 1 -Bonus 2 -Hits $hits[0] -Crit $hits[1]
    }
    3 {
        $hits=Get-ToHit -Attacks $objectNum -AC $targetAC -Bonus 5 -Advantage $Adv -Disadvantage $Dis
        $damage=Get-Damage -Sides 6 -NumDice 2 -Bonus 1 -Hits $hits[0] -Crit $hits[1]
    }
    4 {
        $hits=Get-ToHit -Attacks $objectNum -AC $targetAC -Bonus 6 -Advantage $Adv -Disadvantage $Dis
        $damage=Get-Damage -Sides 10 -NumDice 2 -Bonus 2 -Hits $hits[0] -Crit $hits[1]
    }
    5 {
        $hits=Get-ToHit -Attacks $objectNum -AC $targetAC -Bonus 8 -Advantage $Adv -Disadvantage $Dis
        $damage=Get-Damage -Sides 12 -NumDice 2 -Bonus 4 -Hits $hits[0] -Crit $hits[1]
    }
    Default { Write-Host "Invalid size, select a number 1-5" }
}
#writes out the number of hits
write-host -ForegroundColor Yellow "You hit" $hits[0] "times"
write-host -ForegroundColor Yellow "You get" $hits[1] "set of bonus crit damage dice"
write-host -ForegroundColor Yellow "Your total damage is" $damage