<#
.SYNOPSIS
    This function formats a filter for Logic Monitor API calls.

.DESCRIPTION
    The Format-LMFilter-v1 function takes a hashtable of filter properties and an optional array of valid properties. 
    It checks if the supplied properties are valid, removes any invalid properties, and then formats the remaining properties into a filter string.

.PARAMETER Filter
    A hashtable of filter properties. This is a mandatory parameter.

.PARAMETER PropList
    An array of valid properties. If this parameter is provided, the function checks the properties in the Filter parameter against this list and removes any that are not valid.

.EXAMPLE
    Format-LMFilter-v1 -Filter $Filter -PropList $PropList

    This command formats the filter properties represented by the $Filter hashtable into a filter string, removing any properties that are not in the $PropList array.

.INPUTS
    System.Collections.Hashtable, System.String[]. You can pipe a hashtable of filter properties and an array of valid properties to Format-LMFilter-v1.

.OUTPUTS
    System.String. The function returns a string that represents the formatted filter.

.NOTES
    The function does not throw any errors. If a property in the Filter parameter is not in the PropList parameter, it is simply removed from the filter.
#>
Function Format-LMFilter-v1 {
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
        $FilterString += $Key + ":" + "`"$($Filter[$Key])`"" + ","
    }
    $FilterString = $FilterString.trimend(',')

    Return $FilterString
}