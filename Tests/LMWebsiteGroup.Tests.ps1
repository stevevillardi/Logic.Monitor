Describe 'WebsiteGroup Testing New/Get/Set/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging
    }
    
    Describe 'New-LMWebsiteGroup' {
        It 'When given mandatory parameters, returns a created group with matching values' {
            $Script:NewWebsiteGroup = New-LMWebsiteGroup -Name "WebsiteGroup.Build.Test" -Description "Testing123" -ParentGroupId 1 -Properties @{"testing"="123"} -DisableAlerting $true
            $Script:NewWebsiteGroup | Should -Not -BeNullOrEmpty
            $Script:NewWebsiteGroup.Description | Should -Be "Testing123"
            $Script:NewWebsiteGroup.DisableAlerting | Should -Be $true
            $Script:NewWebsiteGroup.Properties.name.IndexOf("testing") | Should -Not -BeExactly -1
        }
    }
    
    Describe 'Get-LMWebsiteGroup' {
        It 'When given no parameters, returns all groups' {
            $WebsiteGroup = Get-LMWebsiteGroup
            ($WebsiteGroup | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that group' {
            $WebsiteGroup = Get-LMWebsiteGroup -Id $Script:NewWebsiteGroup.Id
            ($WebsiteGroup | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a name should return specified group matching that name' {
            $WebsiteGroup = Get-LMWebsiteGroup -Name $Script:NewWebsiteGroup.Name
            ($WebsiteGroup | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a wildcard name should return all groups matching that wildcard value' {
            $WebsiteGroup = Get-LMWebsiteGroup -Name "$(($Script:NewWebsiteGroup.Name.Split(".")[0]))*"
            ($WebsiteGroup | Measure-Object).Count | Should -BeGreaterThan 0
        }
    }

    Describe 'Set-LMWebsiteGroup' {
        It 'When given a set of parameters, returns an updated group with matching values' {
            { $WebsiteGroup = Set-LMWebsiteGroup -Id $Script:NewWebsiteGroup.Id -Description "Updated" -Properties @{"test"="123";"test2"="456"} -ErrorAction Stop
                $WebsiteGroup.Description | Should -Be "Updated"
                $WebsiteGroup.Properties.name.IndexOf("test") | Should -Not -BeExactly -1
                $WebsiteGroup.Properties.name.IndexOf("test2") | Should -Not -BeExactly -1
            } | Should -Not -Throw
        }
    }

    Describe 'Remove-LMWebsiteGroup' {
        It 'When given an id, remove the group from logic monitor' {
            { Remove-LMWebsiteGroup -Id $Script:NewWebsiteGroup.Id -ErrorAction Stop -Confirm:$false } | Should -Not -Throw
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}