Function Get-LMv4Error {
    Param (
        $InputObject
    )

    $ErrResults = @()
    Try{
        $ErrType = (Get-Member -InputObject $InputObject.errors -Type NoteProperty).Name
        Foreach($Type in $ErrType){
            $AlertId = (Get-Member -InputObject $InputObject.errors.$Type.alerts -Type NoteProperty).Name
            Foreach($Id in $InputObject.errors.$Type.alerts.$AlertId){
                $ErrResults += $Id.message
            }
        }
    }
    Catch{
        Write-Error "Unable to parse error message, see response results for info."
    }

    Return $ErrResults
}