Function Format-LMFilter {
    [CmdletBinding()]
    Param (
        [Hashtable]$Filter,

        [String[]]$PropList
    )

    #Initalize variable for final filter string
    $FilterString = ""

    #Check if supplied properties are valid, if no prop list then just assume valid
    If ($PropList) {
        Foreach ($Key in $($Filter.keys)) {
            If ($Key -notin $PropList) {
                #Remove key since its not a valid filter property
                $filter.remove($Key)
            }
        }
    }

    #Create filter string from hash table and url encode
    foreach ($Key in $($Filter.keys)) {
        $FilterString += $Key + ":" + $([System.Web.HttpUtility]::UrlEncode("`"$($Filter[$Key])`"")) + ","
    }
    $FilterString = $FilterString.trimend(',')

    Return $FilterString
}