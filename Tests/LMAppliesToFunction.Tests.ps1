Describe 'AppliesToFunction Testing New/Get/Set/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging
    }
    
    Describe 'New-LMAppliesToFunction' {
        It 'When given mandatory parameters, returns a created AppliesToFunction with matching values' {
            $Script:NewAppliesToFunction = New-LMAppliesToFunction -Name "AppliesToFunction.Build.Test" -Description "Testing123" -AppliesTo "false()"
            $Script:NewAppliesToFunction | Should -Not -BeNullOrEmpty
            $Script:NewAppliesToFunction.Description | Should -Be "Testing123"
            $Script:NewAppliesToFunction.Code | Should -Be "false()"
        }
    }
    
    Describe 'Get-LMAppliesToFunction' {
        It 'When given no parameters, returns all devices' {
            $AppliesToFunction = Get-LMAppliesToFunction
            ($AppliesToFunction | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that device' {
            $AppliesToFunction = Get-LMAppliesToFunction -Id $Script:NewAppliesToFunction.Id
            ($AppliesToFunction | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a name should return specified device matching that name' {
            $AppliesToFunction = Get-LMAppliesToFunction -Name $Script:NewAppliesToFunction.Name
            ($AppliesToFunction | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a wildcard name should return all devices matching that wildcard value' {
            $AppliesToFunction = Get-LMAppliesToFunction -Name "$(($Script:NewAppliesToFunction.Name.Split(".")[0]))*"
            ($AppliesToFunction | Measure-Object).Count | Should -BeGreaterThan 0
        }
    }

    Describe 'Set-LMAppliesToFunction' {
        It 'When given a set of parameters, returns an updated AppliesToFunction with matching values' {
            { $AppliesToFunction = Set-LMAppliesToFunction -Id $Script:NewAppliesToFunction.Id -Description "Updated" -NewName "AppliesToFunction.Build.Test.UpdatedName" -ErrorAction Stop
                $AppliesToFunction.Description | Should -Be "Updated"
                $AppliesToFunction.Name | Should -Be "AppliesToFunction.Build.Test.UpdatedName"
            } | Should -Not -Throw
        }
    }

    Describe 'Remove-LMAppliesToFunction' {
        It 'When given an id, remove the AppliesToFunction from logic monitor' {
            { Remove-LMAppliesToFunction -Id $Script:NewAppliesToFunction.Id -Confirm:$false -ErrorAction Stop } | Should -Not -Throw
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}