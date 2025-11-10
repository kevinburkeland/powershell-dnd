Describe "Get-ToHit Function" {
    # Import the function to be tested once before all tests in this block
    BeforeAll {
        . "$PSScriptRoot/../modules/tohit.ps1"
    }

    It "should return an array with 3 elements (hits, crits, rolls)" {
        $result = Get-ToHit -Attacks 1 -AC 15 -Bonus 10
        $result.Count | Should Be 3
    }

    It "should always hit when the bonus is very high" {
        # Mock Get-Random to control the dice rolls and make this test predictable.
        # This mock is scoped only to this 'It' block.
        InModuleScope -ModuleName 'dice' {
            Mock Get-Random { return 4 } # All d20 rolls will be 5 (Get-Random -Maximum 20 returns 0-19, then +1)
        }
        ($hits, $crits, $rolls) = Get-ToHit -Attacks 10 -AC 15 -Bonus 10
        $hits | Should Be 10 # With a roll of 5 + 10 bonus, every attack (15) should hit AC 15
    }
}