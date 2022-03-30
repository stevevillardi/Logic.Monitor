Function Get-LMv4AlertError {
    Param (
        $InputObject
    )

    $ErrResults = @()
    Try {
        Foreach($item in $InputObject){
            Foreach($id in $item.allIds){
                $ErrResults += "Status:$($item.status)-$($item.type)-$($item.operation):$($item.message)(Id:$($id.id))"
            }
        }
    }
    Catch {
        Write-Error "Unable to parse error message, see response results for info."
    }
    Return $ErrResults
}