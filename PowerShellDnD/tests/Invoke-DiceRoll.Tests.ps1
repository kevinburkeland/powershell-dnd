Describe "Invoke-DiceRoll Function" {
    BeforeAll {
        # Get the path to the function being tested.
        $functionPath = "$PSScriptRoot/../Private/Invoke-DiceRoll.ps1"
        if (-not (Test-Path $functionPath)) {
            # Create a placeholder file if it doesn't exist, so the tests can be written.
            # The actual implementation will need to be created.
            New-Item -Path $functionPath -ItemType File -Value "function Invoke-DiceRoll { }" -Force | Out-Null
        }
    }

    BeforeEach {
        # Create a dynamic module to ensure complete test isolation.
        $scriptContent = Get-Content -Path "$PSScriptRoot/../Private/Invoke-DiceRoll.ps1" -Raw
        $script:TestModule = New-Module -Name "InvokeDiceRollTestModule" -ScriptBlock ([scriptblock]::Create($scriptContent))
        
        # Import the module to ensure it's available in the session
        Import-Module $script:TestModule
    }

    AfterEach {
        # Clean up the dynamic module after each test.
        Remove-Module $script:TestModule -Force
    }

    Context "Standard Rolls" {
        It "should perform a single standard d20 roll" {
            # All test logic runs inside InModuleScope to target the isolated module.
            InModuleScope $script:TestModule {
                # Mock Get-Random to return a predictable value (9), so the roll becomes 10.
                Mock Get-Random -MockWith { return 9 }

                $result = Invoke-DiceRoll -Dice 'd20'

                $result | Should -Be 10
            }
        }

        It "should perform multiple standard d20 rolls" {
            InModuleScope $script:TestModule {
                # Use a queue to mock a sequence of return values.
                $mockQueue = [System.Collections.Generic.Queue[int]]@(4, 9, 14) # Will result in rolls of 5, 10, 15
                Mock Get-Random -MockWith { return $mockQueue.Dequeue() }

                $result = Invoke-DiceRoll -Dice 'd20' -Count 3

                # Use unary comma to prevent unrolling
                , $result | Should -BeOfType ([array])
                $result.Count | Should -Be 3
                $result | Should -BeExactly @(5, 10, 15)
            }
        }
    }

    Context "Advantage and Disadvantage" {
        It "should perform a roll with Advantage and take the higher value" {
            InModuleScope $script:TestModule {
                # For advantage, Get-Random is called twice. We'll return 4 and 14 (rolls of 5 and 15).
                $mockQueue = [System.Collections.Generic.Queue[int]]@(4, 14)
                Mock Get-Random -MockWith { return $mockQueue.Dequeue() }

                $result = Invoke-DiceRoll -Dice 'd20' -Advantage

                $result | Should -Be 15 # The higher of 5 and 15
            }
        }

        It "should perform a roll with Disadvantage and take the lower value" {
            InModuleScope $script:TestModule {
                # For disadvantage, Get-Random is called twice. We'll return 4 and 14 (rolls of 5 and 15).
                $mockQueue = [System.Collections.Generic.Queue[int]]@(4, 14)
                Mock Get-Random -MockWith { return $mockQueue.Dequeue() }

                $result = Invoke-DiceRoll -Dice 'd20' -Disadvantage

                $result | Should -Be 5 # The lower of 5 and 15
            }
        }

        It "should perform a standard roll if both Advantage and Disadvantage are specified" {
            InModuleScope $script:TestModule {
                # If both are specified, it should behave like a normal roll (call Get-Random once).
                Mock Get-Random -MockWith { return 9 }

                $result = Invoke-DiceRoll -Dice 'd20' -Advantage -Disadvantage

                $result | Should -Be 10
                Assert-MockCalled Get-Random -Times 1 -Exactly
            }
        }
    }
}