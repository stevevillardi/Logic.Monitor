Function Search-LMDeviceConfigBackup {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [System.Object[]]$ConfigBackups,

        [Parameter(Mandatory)]
        [Regex]$SearchPattern

        # [Parameter()]
        # [Int]$LinesBeforeMatch = 0,

        # [Parameter()]
        # [Int]$LinesAfterMatch = 0
    )
    Begin{}
    Process{
        $Results = @()
        Foreach ($device in $ConfigBackups){
            $SearchResults = $device.configContent.Split("`n") | Select-String -Pattern $SearchPattern -Context 0,0 | Select-Object Line,LineNumber
            If($SearchResults){
                $ResultCount = ($SearchResults | Measure-Object).Count
                Write-LMHost "Found $ResultCount search results matching pattern ($SearchPattern) for device: $($device.deviceDisplayName)"
                Foreach($Match in $SearchResults){
                    $Results += [PSCustomObject]@{
                        deviceDisplayName = $device.deviceDisplayName
                        devicePollTimestampUTC = $device.devicePollTimestampUTC
                        deviceInstanceName = $device.deviceInstanceName
                        configVersion = $device.deviceConfigVersion
                        configMatchLine = $Match.LineNumber
                        configMatchContent = $Match.Line
                    }
                }
            }
            Else{
                #Add entry noting pattern not found for device
                $Results += [PSCustomObject]@{
                    deviceDisplayName = $device.deviceDisplayName
                    devicePollTimestampUTC = $device.devicePollTimestampUTC
                    deviceInstanceName = $device.deviceInstanceName
                    configVersion = $device.deviceConfigVersion
                    configMatchLine = "No Match"
                    configMatchContent = "No Match"
                }
            }
        }
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.ConfigSearchResults" )
    }
    End{}
}