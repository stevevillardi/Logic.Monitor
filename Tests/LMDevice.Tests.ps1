Describe 'Device Testing New/Get/Set/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging
    }
    
    Describe 'New-LMDevice' {
        It 'When given mandatory parameters, returns a created resource with matching values' {
            $Script:NewDevice = New-LMDevice -Name "1.1.1.1" -DisplayName "Device.Build.Test" -PreferredCollectorId $PreferredCollectorId -DisableAlerting $true
            $Script:NewDevice | Should -Not -BeNullOrEmpty
        }
    }

    Describe 'New-LMDeviceProperty' {
        It 'When given mandatory parameters, returns a created property with matching values' {
            $DeviceProp = New-LMDeviceProperty -Id $Script:NewDevice.Id -PropertyName "newpropname" -PropertyValue "NewPropValue"
            $DeviceProp | Should -Not -BeNullOrEmpty
            $DeviceProp.name | Should -BeLike "newpropname"
            $DeviceProp.value | Should -BeLike "NewPropValue"
        }
    }

    Describe 'Get-LMDeviceProperty' {
        It 'When given mandatory parameters, returns a specified property' {
            $DeviceProp = Get-LMDeviceProperty -Id $Script:NewDevice.Id -PropertyName "newpropname"
            $DeviceProp | Should -Not -BeNullOrEmpty
            $DeviceProp.name | Should -BeLike "newpropname"
        }
    }

    Describe 'Set-LMDeviceProperty' {
        It 'When given mandatory parameters, returns a updated property with matching values' {
            $DeviceProp = Set-LMDeviceProperty -Id $Script:NewDevice.Id -PropertyName "newpropname" -PropertyValue "UpdatedPropValue"
            $DeviceProp | Should -Not -BeNullOrEmpty
            $DeviceProp.name | Should -BeLike "newpropname"
            $DeviceProp.value | Should -BeLike "UpdatedPropValue"
        }
    }

    Describe 'Remove-LMDeviceProperty' {
        It 'When given an id, remove the device property from resource' {
            { Remove-LMDeviceProperty -Id $Script:NewDevice.Id -PropertyName "newpropname" -Confirm:$false -ErrorAction Stop } | Should -Not -Throw
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
            { $Device = Set-LMDevice -Id $Script:NewDevice.Id -Description "Updated" -Properties @{"test"="123";"test2"="456"}  -ErrorAction Stop
                $Device.Description | Should -Be "Updated"
                $Device.CustomProperties.name.IndexOf("test") | Should -Not -BeExactly -1
                $Device.CustomProperties.name.IndexOf("test2") | Should -Not -BeExactly -1
            } | Should -Not -Throw
        }
    }

    Describe 'Remove-LMDevice' {
        It 'When given an id, remove the device from logic monitor' {
            { Remove-LMDevice -Id $Script:NewDevice.Id -HardDelete $true -Confirm:$false  -ErrorAction Stop} | Should -Not -Throw
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}