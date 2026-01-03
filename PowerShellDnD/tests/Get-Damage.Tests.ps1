Describe "Get-Damage Function" {
    BeforeEach {
        # Create a dynamic module containing both functions to ensure complete test isolation.
        $scriptContent = Get-Content -Path "$PSScriptRoot/../Private/Invoke-DiceRoll.ps1" -Raw
        $scriptContent += "`n" + (Get-Content -Path "$PSScriptRoot/../Private/Get-Damage.ps1" -Raw)
        
        # Set the variable in the Describe scope so it's available in the It blocks.
        $script:TestModule = New-Module -Name "GetDamageTestModule" -ScriptBlock ([scriptblock]::Create($scriptContent))
        Import-Module $script:TestModule
    }

    AfterEach {
        # Clean up the dynamic module after each test.
        Remove-Module $script:TestModule -Force
    }

    It "should calculate damage correctly for a single hit" {
        InModuleScope $TestModule {
            # Mock Invoke-DiceRoll to return 4 (roll of 4 on d6)
            Mock Invoke-DiceRoll { return 4 }
            
            # 1 Hit, 1d6+2 damage. Expected: 4 + 2 = 6
            $damage = Get-Damage -Sides 6 -NumDice 1 -Bonus 2 -Hits 1 -Crit 0
            
            $damage | Should -Be 6
        }
    }

    It "should calculate damage correctly for multiple hits" {
        InModuleScope $TestModule {
            # Mock Invoke-DiceRoll to return 3, 4 (rolls on d6)
            Mock Invoke-DiceRoll { return @(3, 4) }
            
            # 2 Hits, 1d6+2 damage. Expected: (3+4) + (2*2) = 7 + 4 = 11
            $damage = Get-Damage -Sides 6 -NumDice 1 -Bonus 2 -Hits 2 -Crit 0
            
            $damage | Should -Be 11
        }
    }

    It "should calculate critical damage correctly" {
        InModuleScope $TestModule {
            # Mock Invoke-DiceRoll to return 3, 4 (rolls on d6)
            # 1 Hit, 1 Crit. Total dice = 1 + 1 = 2.
            Mock Invoke-DiceRoll { return @(3, 4) }
            
            # 1 Hit, 1 Crit, 1d6+2 damage. 
            # Dice damage: 3 + 4 = 7
            # Bonus damage: 1 hit * 2 = 2 (Crits don't multiply bonus)
            # Total: 7 + 2 = 9
            $damage = Get-Damage -Sides 6 -NumDice 1 -Bonus 2 -Hits 1 -Crit 1
            
            $damage | Should -Be 9
        }
    }

    It "should return 0 damage if there are no hits or crits" {
        InModuleScope $TestModule {
            $damage = Get-Damage -Sides 6 -NumDice 1 -Bonus 2 -Hits 0 -Crit 0
            
            $damage | Should -Be 0
        }
    }

    It "should return 0 damage if the bonus is negative enough to reduce the total below 0" {
        InModuleScope $TestModule {
            # Mock Invoke-DiceRoll to return 1 (low roll)
            Mock Invoke-DiceRoll { return 1 }
            
            # 1 Hit, 1d6-5 damage. Expected: 1 - 5 = -4, clamped to 0
            $damage = Get-Damage -Sides 6 -NumDice 1 -Bonus -5 -Hits 1 -Crit 0
            
            $damage | Should -Be 0
        }
    }
}