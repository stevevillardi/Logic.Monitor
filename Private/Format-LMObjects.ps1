Function Format-LMObjects {
    [CmdletBinding()]
    Param (
        [Object]$Object,

        [String]$ObjectType,

        [String[]]$ObjectDisplayList
    )

    #Add custom type to response
    $Object.PSObject.TypeNames.Insert(0, $ObjectType)

    #Create our default display output
    $TypeData = @{
        TypeName                  = $ObjectType
        DefaultDisplayPropertySet = $ObjectDisplayList
    }

    #Update the type data for our custom type
    Update-TypeData @TypeData -Force

    Return $Object
}
