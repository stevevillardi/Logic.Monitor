Function Get-LMAuditLogs
{

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'Id')]
        [String]$Id,

        [Parameter(ParameterSetName = 'Range')]
        [Datetime]$StartDate,

        [Parameter(ParameterSetName = 'Range')]
        [Datetime]$EndDate,

        [Parameter(ParameterSetName = 'Filter')]
        [String]$Filter,

        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If($global:LMAuth.Valid){
        
        #Build header and uri
        $ResourcePath = "/setting/accesslogs"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Convert to epoch, if not set use defaults
        If(!$StartDate){
            [int]$StartDate = 0
        }
        Else{
            [int]$StartDate = ([DateTimeOffset]$($StartDate)).ToUnixTimeSeconds()
        }

        If(!$EndDate){
            [int]$EndDate = ([DateTimeOffset]$(Get-Date)).ToUnixTimeSeconds()
        }
        Else{
            [int]$EndDate = ([DateTimeOffset]$($EndDate)).ToUnixTimeSeconds()
        }

        #Loop through requests 
        While(!$Done){
            #Build query params
            Switch($PSCmdlet.ParameterSetName){
                "All" {$QueryParams = "?filter=happenedOn%3E%3A`"$StartDate`"%2ChappenedOn%3C%3A`"$EndDate`",size=$BatchSize&offset=$Count&sort=+happenedOn"}
                "Id" {$resourcePath += "/$Id"}
                "Filter" {$QueryParams = "?filter=$Filter&size=$BatchSize&offset=$Count&sort=+happenedOn"}
            }
            Try{
                $Headers = New-LMHeader -Auth $global:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
    
                #Issue request
                $Request = Invoke-WebRequest -Uri $Uri -Method "GET" -Headers $Headers
                $Response = $Request.Content | ConvertFrom-Json

                #Stop looping if single device, no need to continue
                If($PSCmdlet.ParameterSetName -eq "Id"){
                    $Done = $true
                    Return $Response
                }
                #Check result size and if needed loop again
                Else{
                    [Int]$Total = $Response.Total
                    [Int]$Count += ($Response.Items | Measure-Object).Count
                    $Results += $Response.Items
                    If($Count -ge $Total){
                        $Done = $true
                    }
                }
            }
            Catch{
                $LMError = $_.ErrorDetails | ConvertFrom-Json
                Write-Error "Failed to execute query: $($LMError.errorMessage) - $($LMError.errorCode)"
                $Done = $true
            }
        }
        Return $Results
    }
    Else{
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
