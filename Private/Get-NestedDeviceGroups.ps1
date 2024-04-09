<#
.SYNOPSIS
    Retrieves nested device groups based on the provided group IDs.

.DESCRIPTION
    The Get-NestedDeviceGroups function retrieves nested device groups by recursively querying the child groups of the provided group IDs. It returns an array of group IDs, including the original IDs and all nested child IDs.

.PARAMETER Ids
    Specifies an array of group IDs for which to retrieve nested device groups.

.PARAMETER PreviousIds
    Specifies an optional array of previously processed group IDs. This parameter is used internally for recursive calls and should not be provided when calling the function.

.EXAMPLE
    Get-NestedDeviceGroups -Ids "Group1", "Group2"
    Retrieves all nested device groups for "Group1" and "Group2".

.EXAMPLE
    Get-NestedDeviceGroups -Ids "Group1" -PreviousIds "Group3"
    Retrieves all nested device groups for "Group1" and includes "Group3" in the list of previously processed group IDs.

#>
Function Get-NestedDeviceGroups {
    Param (
        [String[]]$Ids,
        [String[]]$PreviousIds = @()
    )
    ##Write-Host "Function Called with Ids: $Ids"
    $AdditionalIds = @()
    Foreach ($Id in $Ids) {
        ##Write-Host "Processing Id: ($Id)"
        $temp = @()
        $temp += (Get-LMDeviceGroupGroups -Id $Id).Id
        If ($temp) {
            $AdditionalIds += $temp
        }
    }
    ##Write-Host "Function End with Ids: $AdditionalIds"
    ##Write-Host "Function Previous Called Ids: $PreviousIds"
    If ($AdditionalIds) {
        #PreviousIds and CurrentIds get combined and AdditionalIds get passed forward
        Get-NestedDeviceGroups -Ids $AdditionalIds -PreviousIds $($Ids + $PreviousIds)
    }
    Else {
        ##Write-Host "Return Value: "
        Return $($PreviousIds + $Ids)
    }
}