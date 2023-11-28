Describe 'DeviceGroup Testing New/Get/Set/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging
    }
    
    Describe 'New-LMDeviceGroup' {
        It 'When given mandatory parameters, returns a created group with matching values' {
            $Script:NewDeviceGroup = New-LMDeviceGroup -Name "DeviceGroup.Build.Test" -Description "Testing123" -ParentGroupId 1 -Properties @{"testing"="123"} -DisableAlerting $true -AppliesTo "false()"
            $Script:NewDeviceGroup | Should -Not -BeNullOrEmpty
            $Script:NewDeviceGroup.Description | Should -Be "Testing123"
            $Script:NewDeviceGroup.DisableAlerting | Should -Be $true
            $Script:NewDeviceGroup.AppliesTo | Should -Be "false()"
            $Script:NewDeviceGroup.CustomProperties.name.IndexOf("testing") | Should -Not -BeExactly -1
        }
    }
    
    Describe 'Get-LMDeviceGroup' {
        It 'When given no parameters, returns all devices' {
            $DeviceGroup = Get-LMDeviceGroup
            ($DeviceGroup | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that device' {
            $DeviceGroup = Get-LMDeviceGroup -Id $Script:NewDeviceGroup.Id
            ($DeviceGroup | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a name should return specified device matching that name' {
            $DeviceGroup = Get-LMDeviceGroup -Name $Script:NewDeviceGroup.Name
            ($DeviceGroup | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a wildcard name should return all devices matching that wildcard value' {
            $DeviceGroup = Get-LMDeviceGroup -Name "$(($Script:NewDeviceGroup.Name.Split(".")[0]))*"
            ($DeviceGroup | Measure-Object).Count | Should -BeGreaterThan 0
        }
    }

    Describe 'Set-LMDeviceGroup' {
        It 'When given a set of parameters, returns an updated group with matching values' {
            { $DeviceGroup = Set-LMDeviceGroup -Id $Script:NewDeviceGroup.Id -Description "Updated" -Properties @{"test"="123";"test2"="456"} -ErrorAction Stop
                $DeviceGroup.Description | Should -Be "Updated"
                $DeviceGroup.CustomProperties.name.IndexOf("test") | Should -Not -BeExactly -1
                $DeviceGroup.CustomProperties.name.IndexOf("test2") | Should -Not -BeExactly -1
            } | Should -Not -Throw
        }
    }

    Describe 'Remove-LMDeviceGroup' {
        It 'When given an id, remove the group from logic monitor' {
            { Remove-LMDeviceGroup -Id $Script:NewDeviceGroup.Id -HardDelete $true -Confirm:$false -ErrorAction Stop } | Should -Not -Throw
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}