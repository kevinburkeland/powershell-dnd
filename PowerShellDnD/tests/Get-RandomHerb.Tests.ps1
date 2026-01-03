Describe "Get-RandomHerb Function" {
    BeforeEach {
        # Load the function into a dynamic module
        # We need to remove the dot-sourcing of Invoke-DiceRoll because $PSScriptRoot is invalid in the New-Module scope.
        $scriptContent = Get-Content -Path "$PSScriptRoot/../Public/Get-RandomHerb.ps1" -Raw
        
        # Remove the dot-source line
        $scriptContent = $scriptContent -replace '(?m)^\s*\.\s*".*Invoke-DiceRoll\.ps1"', ''
        
        # Prepend the dummy function definition so it exists at module scope
        $scriptContent = "function Invoke-DiceRoll {} `n" + $scriptContent

        $script:TestModule = New-Module -Name "GetRandomHerbTestModule" -ScriptBlock ([scriptblock]::Create($scriptContent))
        Import-Module $script:TestModule
    }

    AfterEach {
        Remove-Module $script:TestModule -Force
    }

    It "should return a Common herb when roll is between 1 and 39" {
        InModuleScope $script:TestModule {
            # Mock Data
            $mockJson = '{ "Forest": { "Common": ["CommonHerb"], "Rare": ["RareHerb"] } }'
            Mock Get-Content { return $mockJson } -ParameterFilter { $Path -like "*herbs.json" }

            # Mock Dice Roll (Result 10 -> Common)
            Mock Invoke-DiceRoll { return @(10) }
            
            # Mock Get-Random to return the expected herb string
            # We filter by InputObject to ensure we are mocking the selection from the list, not the dice roll (which is separate)
            Mock Get-Random { return "CommonHerb" } -ParameterFilter { $InputObject -contains "CommonHerb" }

            $result = Get-RandomHerb -Count 1 -Biome "Forest"
            
            $result.Count | Should -Be 1
            $result[0].Name | Should -Be "CommonHerb"
            $result[0].Count | Should -Be 1
        }
    }

    It "should return a Rare herb when roll is between 81 and 94" {
        InModuleScope $script:TestModule {
            # Mock Data
            $mockJson = '{ "Forest": { "Common": ["CommonHerb"], "Rare": ["RareHerb"] } }'
            Mock Get-Content { return $mockJson } -ParameterFilter { $Path -like "*herbs.json" }

            # Mock Dice Roll (Result 85 -> Rare)
            Mock Invoke-DiceRoll { return @(85) }
            
            Mock Get-Random { return "RareHerb" } -ParameterFilter { $InputObject -contains "RareHerb" }

            $result = Get-RandomHerb -Count 1 -Biome "Forest"
            
            $result.Count | Should -Be 1
            $result[0].Name | Should -Be "RareHerb"
        }
    }

    It "should handle case insensitivity for biome" {
        InModuleScope $script:TestModule {
            # Mock Data
            $mockJson = '{ "Forest": { "Common": ["CommonHerb"] } }'
            Mock Get-Content { return $mockJson } 

            Mock Invoke-DiceRoll { return @(10) }
            Mock Get-Random { return "CommonHerb" }

            # Pass 'forest' lowercase, should match 'Forest' key in JSON
            $result = Get-RandomHerb -Count 1 -Biome "forest"
            
            $result[0].Name | Should -Be "CommonHerb"
        }
    }
}
