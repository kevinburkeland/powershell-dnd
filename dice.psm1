class Dice {
    [int[]]GetD4(){
        return (Get-Random -maximum 4)+1
    }
    [int[]]GetD6(){
        return (Get-Random -maximum 6)+1
    }
    [int[]]GetD8(){
        return (Get-Random -maximum 8)+1
    }
    [int[]]GetD10(){
        return (Get-Random -maximum 10)+1
    }
    [int[]]GetD12(){
        return (Get-Random -maximum 12)+1
    }
    [int[]]GetD20(){
        return (Get-Random -maximum 20)+1
    }
    [int[]]GetD100(){
        return (Get-Random -maximum 100)+1
    }
}