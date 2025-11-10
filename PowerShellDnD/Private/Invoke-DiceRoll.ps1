function Private:Invoke-DiceRoll {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [int]$MaxRoll,

        [Parameter(Mandatory=$false)]
        [int]$NumDice = 1
    )

    [int[]]$rolls = @()
    1..$NumDice | ForEach-Object {
        # Get-Random -Maximum is exclusive, so add 1 to get values from 1 to MaxRoll
        # This ensures rolls are between 1 and MaxRoll (inclusive).
        $roll = (Get-Random -Maximum $MaxRoll) + 1
        $rolls += $roll
    }
    return $rolls
}