Describe 'OpsNotes Testing New/Get/Set/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging
    }
    
    Describe 'New-LMOpsNote' {
        It 'When given mandatory parameters, returns a created opsnote with matching values' {
            $Script:TimeNow = Get-Date -UFormat %m%d%Y-%H%M
            $Script:NewOpsNote = New-LMOpsNote -Note "OpsNote.Build.Test: $Script:TimeNow" -Tags "OpsNote.Build.Test-$Script:TimeNow"
            $Script:NewOpsNote | Should -Not -BeNullOrEmpty
            $Script:NewOpsNote.note | Should -Be "OpsNote.Build.Test: $Script:TimeNow"
            $Script:NewOpsNote.tags | Should -Not -BeNullOrEmpty
            $Script:NewOpsNote.scopes | Should -BeNullOrEmpty
            
        }
    }
    
    Describe 'Get-LMOpsNote' {
        It 'When given no parameters, returns all opsnotes' {
            $OpsNote = Get-LMOpsNote
            ($OpsNote | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that opsnote' {
            $Retry = 0
            While(!$OpsNote -or $Retry -eq 5){
                $OpsNote = Get-LMOpsNote -Id $Script:NewOpsNote.Id -ErrorAction SilentlyContinue
                $Retry++
            }
            ($OpsNote | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a name should return specified opsnote matching that tag value' {
            $Retry = 0
            While(!$OpsNote -or $Retry -eq 5){
                $OpsNote = Get-LMOpsNote -Tag $Script:NewOpsNote.Tags.name -ErrorAction SilentlyContinue
                $Retry++
            }
            ($OpsNote | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a wildcard name should return all opsnotes matching that wildcard value' {
            $Retry = 0
            While(!$OpsNote -or $Retry -eq 5){
                $OpsNote = Get-LMOpsNote -Tag "$(($Script:NewOpsNote.Tags.name.Split(".")[0]))*"  -ErrorAction SilentlyContinue
                $Retry++
            }
            ($OpsNote | Measure-Object).Count | Should -BeGreaterThan 0
        }
    }

    Describe 'Set-LMOpsNote' {
        It 'When given a set of parameters, returns an updated opsnote with matching values' {
            { $OpsNote = Set-LMOpsNote -Id $Script:NewOpsNote.Id -Note "OpsNote.Build.Test: $Script:TimeNow Updated"-ErrorAction Stop
                $OpsNote.Note | Should -Be "OpsNote.Build.Test: $Script:TimeNow Updated"
            } | Should -Not -Throw
        }
    }

    Describe 'Remove-LMOpsNote' {
        It 'When given an id, remove the opsnote from logic monitor' {
            { Remove-LMOpsNote -Id $Script:NewOpsNote.Id -ErrorAction Stop -Confirm:$false } | Should -Not -Throw
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}