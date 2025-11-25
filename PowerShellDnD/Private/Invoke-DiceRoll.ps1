function Invoke-DiceRoll {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern('d(4|6|8|10|12|20|100)')]
        [string]$Dice,

        [Parameter(Mandatory = $false)]
        [int]$Count = 1,

        [Parameter(Mandatory = $false)]
        [switch]$Advantage,

        [Parameter(Mandatory = $false)]
        [switch]$Disadvantage
    )

    $maxRoll = [int]($Dice.Substring(1))
    [int[]]$rolls = @()

    # If advantage and disadvantage cancel out, or neither is specified, perform normal rolls.
    if ($Advantage -eq $Disadvantage) {
        foreach ($i in 1..$Count) {
            $rolls += (Get-Random -Maximum $maxRoll) + 1
        }
    }
    else {
        # For each requested roll, roll twice and take the appropriate one.
        foreach ($i in 1..$Count) {
            $roll1 = (Get-Random -Maximum $maxRoll) + 1
            $roll2 = (Get-Random -Maximum $maxRoll) + 1

            $comparison = if ($Advantage) { [System.Math]::Max($roll1, $roll2) } else { [System.Math]::Min($roll1, $roll2) }
            $rolls += $comparison
        }
    }
    return $rolls
}