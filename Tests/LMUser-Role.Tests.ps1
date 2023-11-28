Describe 'User & Role Testing New/Get/Set/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging
    }
    
    Describe 'New-LMApiUser' {
        It 'When given mandatory parameters, returns a created user with matching values' {
            $Script:NewUser = New-LMApiUser -UserName "User.Build.Test" -Note "BuildNote" -RoleName @("no_access") -Status suspended
            $Script:NewUser | Should -Not -BeNullOrEmpty
            $Script:NewUser.Note | Should -BeLike "BuildNote"
            $Script:NewUser.Status | Should -BeLike "suspended"
        }
    }

    Describe 'New-LMRole' {
        It 'When given mandatory parameters, returns a created role with matching values' {
            $Script:NewRole = New-LMRole -Name "Role.Build.Test" -Description "BuildNote"
            $Script:NewRole | Should -Not -BeNullOrEmpty
            $Script:NewRole.Description | Should -BeLike "BuildNote"
        }
    }

    
    Describe 'Get-LMUser' {
        It 'When given no parameters, returns all users' {
            $User = Get-LMUser
            ($User | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that user' {
            $User = Get-LMUser -Id $Script:NewUser.Id
            ($User | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a name should return specified user matching that name' {
            $User = Get-LMUser -Name $Script:NewUser.UserName
            ($User | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a wildcard displayname should return all users matching that wildcard value' {
            $User = Get-LMUser -Name "$(($Script:NewUser.UserName.Split(".")[0]))*"
            ($User | Measure-Object).Count | Should -BeGreaterThan 0
        }
    }

    Describe 'Get-LMRole' {
        It 'When given no parameters, returns all roles' {
            $Role = Get-LMRole
            ($Role | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that role' {
            $Role = Get-LMRole -Id $Script:NewRole.Id
            ($Role | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a name should return specified role matching that name' {
            $Role = Get-LMRole -Name $Script:NewRole.Name
            ($Role | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a wildcard displayname should return all roles matching that wildcard value' {
            $Role = Get-LMRole -Name "$(($Script:NewRole.Name.Split(".")[0]))*"
            ($Role | Measure-Object).Count | Should -BeGreaterThan 0
        }
    }

    Describe 'Set-LMUser' {
        It 'When given a set of parameters, returns an updated user with matching values' {
            { $User = Set-LMUser -Id $Script:NewUser.Id -Note "Updated" -NewUsername "User.Build.Test.Updated" -ErrorAction Stop
                $User.Note | Should -Be "Updated"
                $User.Username | Should -Be "User.Build.Test.Updated"
            } | Should -Not -Throw
        }
    }

    Describe 'Set-LMRole' {
        It 'When given a set of parameters, returns an updated role with matching values' {
            { $Role = Set-LMRole -Id $Script:NewRole.Id -Description "Updated" -NewName "Role.Build.Test.Updated" -CustomHelpLabel "Example Help" -CustomHelpURL "https://logicmonitor.com" -ErrorAction Stop
                $Role.Description | Should -Be "Updated"
                $Role.Name | Should -Be "Role.Build.Test.Updated"
                $Role.CustomHelpLabel | Should -Be "Example Help"
                $Role.CustomHelpURL | Should -Be "https://logicmonitor.com"
            } | Should -Not -Throw
        }
    }

    Describe 'Remove-LMUser' {
        It 'When given an id, remove the user from logic monitor' {
            { Remove-LMUser -Id $Script:NewUser.Id -ErrorAction Stop -Confirm:$false } | Should -Not -Throw
        }
    }

    Describe 'Remove-LMRole' {
        It 'When given an id, remove the role from logic monitor' {
            { Remove-LMRole -Id $Script:NewRole.Id -ErrorAction Stop -Confirm:$false  } | Should -Not -Throw
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}