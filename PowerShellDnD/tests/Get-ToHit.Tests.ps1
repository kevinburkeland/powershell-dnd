Describe "Get-ToHit Function" {
    BeforeEach {
        # Create a dynamic module containing both functions to ensure complete test isolation.
        $scriptContent = Get-Content -Path "$PSScriptRoot/../Private/Invoke-DiceRoll.ps1" -Raw
        $scriptContent += "`n" + (Get-Content -Path "$PSScriptRoot/../Private/Get-ToHit.ps1" -Raw)
        # Set the variable in the Describe scope so it's available in the It blocks.
        $script:TestModule = New-Module -Name "GetToHitTestModule" -ScriptBlock ([scriptblock]::Create($scriptContent))
        Import-Module $script:TestModule
    }

    AfterEach {
        # Clean up the dynamic module after each test.
        Remove-Module $script:TestModule -Force
    }

    It "should return an array with 3 elements (hits, crits, rolls)" {
        InModuleScope $TestModule {
            # Mock Invoke-DiceRoll to ensure predictable output for this test
            Mock Invoke-DiceRoll { return @(10) }
            $result = Get-ToHit -Attacks 1 -AC 15 -Bonus 5
            $result.Count | Should -Be 3
        }
    }

    It "should always hit when the bonus is very high" {
        InModuleScope $TestModule {
            # Mock the direct dependency 'Invoke-DiceRoll' to control the dice rolls.
            # We'll make it return an array of 10 rolls, all of which are 5.
            Mock Invoke-DiceRoll { return @(5) * 10 }
            ($hits, $crits, $rolls) = Get-ToHit -Attacks 10 -AC 15 -Bonus 10
            $hits | Should -Be 10 # With a roll of 5 + 10 bonus, every attack (total 15) should hit AC 15
        }
    }
}