BeforeAll {
    Import-Module $Module -Force
}

Describe 'Connect-LMAccount with LMv1' {
    It 'Connects successfully with admin level credentials using LMv1 auth' {
        { Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging -ErrorAction Stop } | Should -Not -Throw
    }
}
Describe 'Connect-LMAccount with BearerToken' {
    It 'Connects successfully with admin level credentials using BearerToken auth' {
        { Connect-LMAccount -BearerToken $BearerToken -AccountName $AccountName -DisableConsoleLogging -ErrorAction Stop } | Should -Not -Throw
    }
}

Describe 'Disconnect-LMAccount' {
    It 'Disconnect should remove auth variables from scope without throwing exception' {
        { Disconnect-LMAccount -ErrorAction Stop } | Should -Not -Throw

    }
}
