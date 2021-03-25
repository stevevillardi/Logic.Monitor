Function Get-LMIdType {
    Param (
        $InputObject
    )

    Add-Type -Assembly Microsoft.VisualBasic
    #Check if the supplied input is a number, if so treat it as an Id vs a Name param
    If([Microsoft.VisualBasic.Information]::IsNumeric($InputObject)){
        $InputType = "Id"
    }
    Else{
        $InputType = "Name"
    }

    Return $InputType
}