class Dice {
    [int]$max_roll
    [int]$num_dice

    [int[]]roll($max_roll, $num_dice){
        $rolls = @()
        1..$num_dice|ForEach-Object {
            $roll=(Get-Random -Maximum $max_roll)+1
            $rolls += $roll
            }
        return $rolls
    }
    [int[]]GetD4($num_dice){
        return $this.roll(4, $num_dice)
    }
    [int[]]GetD6($num_dice){
        return $this.roll(6, $num_dice)
    }
    [int[]]GetD8($num_dice){
        return $this.roll(8, $num_dice)
    }
    [int[]]GetD10($num_dice){
        return $this.roll(10, $num_dice)
    }
    [int[]]GetD12($num_dice){
        return $this.roll(12, $num_dice)
    }
    [int[]]GetD20($num_dice){
        return $this.roll(20, $num_dice)
    }
    [int[]]GetD100($num_dice){
        return $this.roll(100, $num_dice)
    }
}