Describe 'Device Testing New/Get/Set/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging
    }
    
    Describe 'New-LMDevice' {
        It 'When given mandatory parameters, returns a created resource with matching values' {
            $Script:NewDevice = New-LMDevice -Name $TestDeviceName -DisplayName $TestDeviceDisplayName -PreferredCollectorId $PreferredCollectorId -DisableAlerting $true
            $Script:NewDevice | Should -Not -BeNullOrEmpty
        }
    }
    
    Describe 'Get-LMDevice' {
        It 'When given no parameters, returns all devices' {
            $Device = Get-LMDevice
            ($Device | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that device' {
            $Device = Get-LMDevice -Id $Script:NewDevice.Id
            ($Device | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a name should return all devices matching that name' {
            $Device = Get-LMDevice -Name $Script:NewDevice.Name
            ($Device | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a wildcard displayname should return all devices matching that wildcard value' {
            $Device = Get-LMDevice -DisplayName "$(($Script:NewDevice.DisplayName.Split(".")[0]))*"
            ($Device | Measure-Object).Count | Should -BeGreaterThan 0
        }
    }

    Describe 'Set-LMDevice' {
        It 'When given a set of parameters, returns an updated resource with matching values' {
            { $Device = Set-LMDevice -Id $Script:NewDevice.Id -Description "Updated" -Properties @{"test"="123";"test2"="456"} 
                $Device.Description | Should -Be "Updated"
                $Device.CustomProperties.name.IndexOf("test") | Should -Not -BeExactly -1
                $Device.CustomProperties.name.IndexOf("test2") | Should -Not -BeExactly -1
            } | Should -Not -Throw
        }
    }

    Describe 'Remove-LMDevice' {
        It 'When given an id, remove the device from logic monitor' {
            { Remove-LMDevice -Id $Script:NewDevice.Id -HardDelete $true } | Should -Not -Throw
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}