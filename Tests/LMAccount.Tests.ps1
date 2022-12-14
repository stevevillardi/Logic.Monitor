BeforeAll {
    Import-Module $Module -Force
}

Describe 'Connect-LMAccount' {
    It 'Connects successfully with admin level credentials' {
        { Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging } | Should -Not -Throw
    }
}

Describe 'Disconnect-LMAccount' {
    It 'Disconnect should remove auth variables from scope without throwing exception' {
        { Disconnect-LMAccount } | Should -Not -Throw

    }
}
