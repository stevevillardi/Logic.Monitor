<#
.SYNOPSIS
Imports LogicMonitor dashboards from various sources.

.DESCRIPTION
The `Import-LMDashboard` function allows you to import LogicMonitor dashboards from different sources, such as local files, GitHub repositories, or LogicMonitor dashboard groups. It supports importing dashboards in JSON format.

.PARAMETER FilePath
Specifies the path to a local file or directory containing the JSON dashboard files to import. If a directory is specified, all JSON files within the directory (and its subdirectories) will be imported.

.PARAMETER File
Specifies a single JSON dashboard file to import.

.PARAMETER GithubUserRepo
Specifies the GitHub repository (in the format "username/repo") from which to import JSON dashboard files.

.PARAMETER GithubAccessToken
Specifies the GitHub access token to use for authenticated requests. This is required for large repositories, as the GitHub API has rate limits for unauthenticated requests.

.PARAMETER ParentGroupId
Specifies the ID of the parent dashboard group under which the imported dashboards will be placed. This parameter is mandatory when importing from a file or GitHub repository.

.PARAMETER ParentGroupName
Specifies the name of the parent dashboard group under which the imported dashboards will be placed. This parameter is mandatory when importing from a file or GitHub repository.

.PARAMETER ReplaceAPITokensOnImport
Indicates whether to replace API tokens in the imported dashboards with a dynamically generated API token. This is useful for managing API access to the dashboards.

.PARAMETER APIToken
Specifies the API token to use for replacing API tokens in the imported dashboards. This parameter is required when `ReplaceAPITokensOnImport` is set to `$true`.

.PARAMETER PrivateUserName
Specifies the username of dashboard owner when creating dashboard as private.

.EXAMPLE
Import-LMDashboard -FilePath "C:\Dashboards" -ParentGroupId 12345 -ReplaceAPITokensOnImport -APIToken $apiToken
Imports all JSON dashboard files from the "C:\Dashboards" directory and its subdirectories. The imported dashboards will be placed under the dashboard group with ID 12345. API tokens in the imported dashboards will be replaced with the specified API token.

.EXAMPLE
Import-LMDashboard -GithubUserRepo "username/repo" -ParentGroupName "MyDashboards" -ReplaceAPITokensOnImport -APIToken $apiToken
Imports JSON dashboard files from the specified GitHub repository. The imported dashboards will be placed under the dashboard group with the name "MyDashboards". API tokens in the imported dashboards will be replaced with the specified API token.
#>
Function Import-LMDashboard {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'FilePath-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'FilePath-GroupName')]
        [String]$FilePath,

        [Parameter(Mandatory, ParameterSetName = 'File-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'File-GroupName')]
        [String]$File,

        [Parameter(Mandatory, ParameterSetName = 'Repo-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Repo-GroupName')]
        [String]$GithubUserRepo, # format "username/repo"

        [Parameter(ParameterSetName = 'Repo-GroupId')]
        [Parameter(ParameterSetName = 'Repo-GroupName')]
        [String]$GithubAccessToken, #Required for large repos, github api is limited to 60 requests per hour when unauthenticated

        [Parameter(Mandatory, ParameterSetName = 'FilePath-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'File-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Repo-GroupId')]
        [String]$ParentGroupId,

        [Parameter(Mandatory, ParameterSetName = 'FilePath-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'File-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Repo-GroupName')]
        [String]$ParentGroupName,

        [Switch]$ReplaceAPITokensOnImport,

        $APIToken,

        [String]$PrivateUserName = ""
    )

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            $Results = @()
            $DashboardList = @()

            If($ParentGroupName){
                $ParentGroupId = (Get-LMDashboardGroup -Name $ParentGroupName | Select-Object -First 1 ).Id
            }
            If($ParentGroupId){
                $ParentGroupName = (Get-LMDashboardGroup -Id $ParentGroupId | Select-Object -First 1 ).Name
            }

            If($FilePath){
                If((Get-Item $FilePath) -is [System.IO.DirectoryInfo]){
                    $FullPath = (Resolve-Path $FilePath).Path
                    $Files = Get-ChildItem $FullPath -Recurse | Where-Object {([IO.Path]::GetExtension($_.Name) -eq '.json')}
                    Foreach($F in $Files){
                        #Convert from json into object
                        $RawFile = Get-Content $F.FullName -Raw | ConvertFrom-Json
                        $DashboardList += @{
                            file = $RawFile
                            path = $($F.DirectoryName -split $FullPath)[1]
                            parentid = $ParentGroupId
                            parentname = $ParentGroupName
                        }
                    }
                }
                Else{
                    If (!(Test-Path -Path $FilePath) -and (!([IO.Path]::GetExtension($FilePath) -eq '.json'))) {
                        Write-Error "File not found or is not a valid json file, check file path and try again"
                        Return
                    }

                    #Convert from json into object
                    $RawFile = Get-Content $FilePath -Raw | ConvertFrom-Json
                    $DashboardList += @{
                        file = $RawFile
                        path = ""
                        parentid = $ParentGroupId
                        parentname = $ParentGroupName
                    }
                }
            }

            If($File){
                $DashboardList += @{
                    file = $File | ConvertFrom-Json
                    path = ""
                    parentid = $ParentGroupId
                    parentname = $ParentGroupName
                }
            }

            If($GithubUserRepo){
                $Headers = @{}
                If($GithubAccessToken){
                    $Headers = @{"Authorization"="token $GithubAccessToken"}
                }
                $Uri = "https://api.github.com/repos/$GithubUserRepo/git/trees/master?recursive=1"
                $RepoData = (Invoke-RestMethod -Uri $Uri -Headers $Headers[0] -WebSession $Headers[1]).tree | Where-Object {$_.Path -like "*.json" -and $_.Path -notlike "Packages/LogicMonitor_Dashboards*"} | Select-Object path,url
                If($RepoData){
                    $TotalItems = ($RepoData | Measure-Object).Count
                    Write-LMHost "[INFO]: Found $TotalItems JSON files from Github repo ($GithubUserRepo)"
                    Foreach ($Item in $RepoData){
                        $EncodedDash = (Invoke-RestMethod -Uri $Item.url -Headers $Headers[0] -WebSession $Headers[1]).content
                        $DashboardList += @{
                            file = [Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($EncodedDash)) | ConvertFrom-Json
                            path = [System.IO.Path]::GetDirectoryName($Item.path)
                            parentid = $ParentGroupId
                            parentname = $ParentGroupName
                        }
                        
                        Write-LMHost "[INFO]: Successfully downloaded dashboard ($($Item.path)) from Github repo ($GithubUserRepo)"
                    }
                }
            }
    
            If($ReplaceAPITokensOnImport -and !($APIToken)){
                $DashboardAPIRoleName = "lm-dynamic-dashboards"
                $DashboardAPIUserName = "lm_dynamic_dashboards"
                $DashboardAPIRole = Get-LMRole -Name $DashboardAPIRoleName
                $DashboardAPIUser = Get-LMUser -Name $DashboardAPIUserName
                If(!$DashboardAPIRole){
                    $DashboardAPIRole = New-LMRole -Name $DashboardAPIRoleName -ResourcePermission view -DashboardsPermission manage -Description "Auto provisioned for use with dynamic dashboards"
                    Write-LMHost "[INFO]: Successfully generated required API role ($DashboardAPIRoleName) for dynamic dashboards"
                }
                If(!$DashboardAPIUser){
                    $DashboardAPIUser = New-LMAPIUser -Username "$DashboardAPIUserName" -note "Auto provisioned for use with dynamic dashboards" -RoleNames @($DashboardAPIRoleName)
                    Write-LMHost "[INFO]: Successfully generated required API user ($DashboardAPIUserName) for dynamic dashboards"
                }
                If($DashboardAPIRole -and $DashboardAPIUser){
                    $APIToken = New-LMAPIToken -Username $DashboardAPIUserName -Note "Auto provisioned for use with dynamic dashboards"
                    If($APIToken){
                        Write-LMHost "[INFO]: Successfully generated required API token for dynamic dashboards for user: $DashboardAPIUserName"
                    }
                }
                Else{
                    Write-LMHost "[WARN]: Unable to generate required API token for dynamic dashboards, manually update the required tokens to use dynamic dashboards" -ForegroundColor Yellow
                }
            }

            Foreach($Dashboard in $DashboardList){
                #Swap apiKeys for dynamic dashboards
                If($ReplaceAPITokensOnImport){
                    If($APIToken){
                        If($Dashboard.file.widgetTokens.name -contains "apiKey"){
                           $KeyIndex = $Dashboard.file.widgetTokens.name.toLower().IndexOf("apikey")
                           $Dashboard.file.widgetTokens[$KeyIndex].value = $APIToken.accessKey
                        }
                        If($Dashboard.file.widgetTokens.name -contains "apiID"){
                            $IdIndex = $Dashboard.file.widgetTokens.name.toLower().IndexOf("apiid")
                            $Dashboard.file.widgetTokens[$IdIndex].value = $APIToken.accessId
                        }
                    }
                }

                #Check if a path has been provided and check if folder exists in selected root folder, if not create
                If($Dashboard.path){
                    [Array]$SubFolders = $Dashboard.path -split  "\\|/" | Where-Object {$_}

                    For($Index = 0; $Index -lt $($SubFolders | Measure-Object).Count; $Index++){

                        If($Index -eq 0){
                            $DashboardGroup = Get-LMDashboardGroup -ParentGroupId $ParentGroupId | Where-Object {$_.Name -eq $SubFolders[$Index]}

                            If(!$DashboardGroup){
                                Write-LMHost "[INFO]: Existing dashboard group not found for $($Subfolders[$Index]) creating new resource group under root group ($ParentGroupName)"
                                $NewDashboardGroup = New-LMDashboardGroup -Name $SubFolders[$Index] -ParentGroupId $ParentGroupId
                                $Dashboard.parentid = $NewDashboardGroup.id
                                $Dashboard.parentname = $NewDashboardGroup.name

                            }
                            Else{
                                $Dashboard.parentid = $DashboardGroup.id
                                $Dashboard.parentname = $DashboardGroup.name
                            }
                        }
                        Else{
                            $DashboardGroup = Get-LMDashboardGroup -Name $Subfolders[$Index] | Where-Object { $_.fullPath -like "$($Subfolders[0])*$($Subfolders[$Index])"}
                            
                            If(!$DashboardGroup){

                                $NewDashboardParentGroup = Get-LMDashboardGroup -Name $Subfolders[$Index-1] | Where-Object {$_.fullPath -like "$ParentGroupName*" -or $_.fullPath -eq $Subfolders[$Index-1]}
                                Write-LMHost "[INFO]: Existing dashboard group not found for $($Subfolders[$Index]) creating new resource group under group ($($NewDashboardParentGroup.Name))"
                                $NewDashboardGroup = New-LMDashboardGroup -Name $SubFolders[$Index] -ParentGroupId $NewDashboardParentGroup.id

                                $Dashboard.parentid = $NewDashboardGroup.id
                                $Dashboard.parentname = $NewDashboardGroup.name

                            }
                            Else{
                                $Dashboard.parentid = $DashboardGroup.id
                                $Dashboard.parentname = $DashboardGroup.name
                            }
                        }
                    }
                }
    
                #Construct our object for import
                $Data = @{
                    description = $Dashboard.file.description
                    groupId = [int]$Dashboard.parentid
                    groupName = $Dashboard.parentname
                    name = $Dashboard.file.name
                    sharable = If($PrivateUserName){$False} Else{$True}
                    owner = $PrivateUserName
                    template = $Dashboard.file | Select-Object -ExcludeProperty group
                    widgetTokens = $Dashboard.file.widgetTokens
                    widgetsConfigVersion = $Dashboard.file.widgetsConfigVersion
                }
    
                #Build header and uri
                $ResourcePath = "/dashboard/dashboards"
                
                Try {
                    $Data = ($Data | ConvertTo-Json -Depth 10)

                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
        
                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
                    Write-Output "Successfully imported dashboard: $($Dashboard.file.name)"
    
                    $Results += (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Dashboard" )
    
                }
                Catch [Exception] {
                    Write-Output "Failed to import dashboard: $($Dashboard.file.name)"
                    $Proceed = Resolve-LMException -LMException $PSItem
                    If (!$Proceed) {
                       # Return
                    }
                }
            }
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {
        $Results
    }
}