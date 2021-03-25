Function Get-NestedDeviceGroups {
    Param (
        [String[]]$Ids,
        [String[]]$PreviousIds = @()
    )
    ##Write-Host "Function Called with Ids: $Ids"
    $AdditionalIds = @()
    Foreach($Id in $Ids){
        ##Write-Host "Processing Id: ($Id)"
        $temp = @()
        $temp += (Get-LMDeviceGroupGroups -Id $Id).Id
        If($temp){
            $AdditionalIds += $temp
        }
    }
    ##Write-Host "Function End with Ids: $AdditionalIds"
    ##Write-Host "Function Previous Called Ids: $PreviousIds"
    If($AdditionalIds){
        #PreviousIds and CurrentIds get combined and AdditionalIds get passed forward
        Get-NestedDeviceGroups -Ids $AdditionalIds -PreviousIds $($Ids + $PreviousIds)
    }
    Else{
        ##Write-Host "Return Value: "
        Return $($PreviousIds + $Ids)
    }
}