<#
.SYNOPSIS
Formats the LogicMonitor filter for API requests.

.DESCRIPTION
The Format-LMFilter function is used to format the LogicMonitor filter for API requests. It takes an input filter object and an optional list of properties to include in the formatted filter. The function supports both legacy and new filter formats.

.PARAMETER Filter
The input filter object. It can be a hashtable or a string.

.PARAMETER PropList
An optional list of properties to include in the formatted filter. The default value is an array containing the following properties: "name", "id", "status", "severity", "startEpoch", "endEpoch", "cleared", "resourceTemplateName", "monitorObjectName", "customProperties", "systemProperties", "autoProperties", "displayName".

.OUTPUTS
The formatted filter string.

.EXAMPLE
$filter = @{
    name = "MyMonitor"
    status = "active"
}
$formattedFilter = Format-LMFilter -Filter $filter
Write-Host $formattedFilter
# Output: name:"MyMonitor",status:"active"

.EXAMPLE
$filter = "name -eq 'MyMonitor' -and status -eq 'active'"
$formattedFilter = Format-LMFilter -Filter $filter
Write-Host $formattedFilter
# Output: name:"MyMonitor",status:"active"
#>

Function Format-LMFilter {
    [CmdletBinding()]
    Param (
        [Object]$Filter,

        [String[]]$PropList = @("name","id","status","severity","startEpoch","endEpoch","cleared","resourceTemplateName","monitorObjectName","customProperties","systemProperties","autoProperties","displayName")
    )
    $FormatedFilter = ""
    #Keep legacy filter method for backwards compatability
    If($Filter -is [hashtable]){
        $FormatedFilter = Format-LMFilter-v1 -Filter $Filter -PropList $PropList
        Write-Debug "Constructed Filter-v1: $FormatedFilter"
        Return $FormatedFilter
    }
    Else{    
        #Split our filters in an array based on logical operator
        $FilterArray = [regex]::Split($Filter,'(\s+-and\s+|\s+-or\s+)')
    
        Foreach ($Filter in $FilterArray){
            If($Filter -match '\s+-and\s+'){
                $FormatedFilter += ","
            }
            ElseIf($Filter -match '\s+-or\s+'){
                $FormatedFilter += "||"
            }
            Else{
                $SingleFilterArray = [regex]::Split($Filter,'(\s+-eq\s+|\s+-ne\s+|\s+-gt\s+|\s+-lt\s+|\s+-ge\s+|\s+-le\s+|\s+-contains\s+|\s+-notcontains\s+)')
                If(($SingleFilterArray | Measure-Object).Count -gt 1){
                    Foreach($SingleFilter in $SingleFilterArray){
                        If($SingleFilter -match '(\s+-eq\s+|\s+-ne\s+|\s+-gt\s+|\s+-lt\s+|\s+-ge\s+|\s+-le\s+|\s+-contains\s+|\s+-notcontains\s+)'){
                            Switch -Regex ($SingleFilter){
                                '\s+-eq\s+' { $FormatedFilter += ":"}
                                '\s+-ne\s+' { $FormatedFilter += "!:"}
                                '\s+-gt\s+' { $FormatedFilter += ">"}
                                '\s+-lt\s+' { $FormatedFilter += "<"}
                                '\s+-ge\s+' { $FormatedFilter += ">:"}
                                '\s+-le\s+' { $FormatedFilter += "<:"}
                                '\s+-contains\s+' { $FormatedFilter += "~"}
                                '\s+-notcontains\s+' { $FormatedFilter += "!~"}
                                default {Write-LMHost "[ERROR]: Invalid filter syntax: $Filter" -ForegroundColor Red}
                            }
                        }
                        Else{
                            $FormatedFilter += $SingleFilter.Replace("'","`"") #replace single quotes with double quotes as reqired by LM API
                        }
                    }
                }
                Else{
                    Write-LMHost "[ERROR]: Invalid filter syntax: $SingleFilterArray" -ForegroundColor Red
                }
            }
        }
        Write-Debug "Constructed Filter-v2: $FormatedFilter"
        Return $FormatedFilter
    }
}