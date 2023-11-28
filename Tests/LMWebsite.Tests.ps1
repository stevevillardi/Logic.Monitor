Describe 'Website Testing New/Get/Set/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging
    }
    
    Describe 'New-LMWebsite' {
        It 'When given mandatory parameters, returns a created website with matching values' {
            $Script:NewWebsite = New-LMWebsite -Name "Website.Build.Test"  -Webcheck -WebsiteDomain "example.com" -Description "BuildTest" -Properties @{"testprop"="BuildTest"}
            $Script:NewWebsite | Should -Not -BeNullOrEmpty
            $Script:NewWebsite.Description | Should -BeExactly "BuildTest"
            $Script:NewWebsite.properties.name.IndexOf("testprop") | Should -Not -BeExactly -1
        }
    }

    Describe 'Get-LMWebsiteProperty' {
        It 'When given mandatory parameters, returns a specified property' {
            $WebsiteProp = Get-LMWebsiteProperty -Id $Script:NewWebsite.Id | Where-Object {$_.name -eq "testprop"}
            $WebsiteProp | Should -Not -BeNullOrEmpty
        }
    }
    
    Describe 'Get-LMWebsite' {
        It 'When given no parameters, returns all websites' {
            $Website = Get-LMWebsite
            ($Website | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that website' {
            $Website = Get-LMWebsite -Id $Script:NewWebsite.Id
            ($Website | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a name should return specified website matching that name' {
            $Website = Get-LMWebsite -Name $Script:NewWebsite.Name
            ($Website | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a wildcard name should return all websites matching that wildcard value' {
            $Website = Get-LMWebsite -Name "$(($Script:NewWebsite.Name.Split(".")[0]))*"
            ($Website | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given a type value should return all websites matching that type' {
            $Website = Get-LMWebsite -Type Webcheck
            $Website.type.Contains("pingcheck") | Should -BeExactly $false
        }
    }

    Describe 'Set-LMWebsite' {
        It 'When given a set of parameters, returns an updated website with matching values' {
            { $Device = Set-LMWebsite -Id $Script:NewWebsite.Id -Description "Updated" -Properties @{"test"="123";"test2"="456"} -ErrorAction Stop
                $Device.Description | Should -Be "Updated"
                $Device.Properties.name.IndexOf("test") | Should -Not -BeExactly -1
                $Device.Properties.name.IndexOf("test2") | Should -Not -BeExactly -1
            } | Should -Not -Throw
        }
    }

    Describe 'Remove-LMWebsite' {
        It 'When given an id, remove the device from logic monitor' {
            { Remove-LMWebsite -Id $Script:NewWebsite.Id -ErrorAction Stop -Confirm:$false } | Should -Not -Throw
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}