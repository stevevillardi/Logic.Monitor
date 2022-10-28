Function Import-LMDashboard {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'File-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'File-GroupName')]
        [String]$FilePath,

        [Parameter(Mandatory, ParameterSetName = 'Repo-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Repo-GroupName')]
        [String]$GithubUserRepo, # format "username/repo"

        [Parameter(ParameterSetName = 'Repo-GroupId')]
        [Parameter(ParameterSetName = 'Repo-GroupName')]
        [String]$GithubAccessToken, #Required for large repos, github api is limited to 60 requests per hour when unauthenticated

        [Parameter(Mandatory, ParameterSetName = 'File-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Repo-GroupId')]
        [String]$ParentGroupId,

        [Parameter(Mandatory, ParameterSetName = 'File-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Repo-GroupName')]
        [String]$ParentGroupName,

        [Switch]$ReplaceAPITokensOnImport,

        [String]$PrivateUserName = ""
    )

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

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
                    Foreach($File in $Files){
                        #Convert from json into object
                        $RawFile = Get-Content $File.FullName -Raw | ConvertFrom-Json
                        $DashboardList += @{
                            file = $RawFile
                            path = $($File.DirectoryName -split $FullPath)[1]
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

            If($GithubUserRepo){
                $Headers = @{}
                If($GithubAccessToken){
                    $Headers = @{"Authorization"="token $GithubAccessToken"}
                }
                $Uri = "https://api.github.com/repos/$GithubUserRepo/git/trees/master?recursive=1"
                $RepoData = (Invoke-RestMethod -Uri $Uri -Headers $Headers).tree | Where-Object {$_.Path -like "*.json" -and $_.Path -notlike "Packages/LogicMonitor_Dashboards*"} | Select-Object path,url
                If($RepoData){
                    $TotalItems = ($RepoData | Measure-Object).Count
                    Write-LMHost "Found $TotalItems JSON files from Github repo ($GithubUserRepo)"
                    Foreach ($Item in $RepoData){
                        $EncodedDash = (Invoke-RestMethod -Uri $Item.url -Headers $Headers).content
                        $DashboardList += @{
                            file = [Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($EncodedDash)) | ConvertFrom-Json
                            path = [System.IO.Path]::GetDirectoryName($Item.path)
                            parentid = $ParentGroupId
                            parentname = $ParentGroupName
                        }
                        
                        Write-LMHost "Successfully downloaded dashboard ($($Item.path)) from Github repo ($GithubUserRepo)"
                    }
                }
            }

            Foreach($Dashboard in $DashboardList){
                #Swap apiKeys for dynamic dashboards
                If($ReplaceAPITokensOnImport){
                    If($Dashboard.file.widgetTokens.name -contains "apiKey"){
                       $KeyIndex = $Dashboard.file.widgetTokens.name.toLower().IndexOf("apikey")
                       $Dashboard.file.widgetTokens[$KeyIndex].value = [System.Net.NetworkCredential]::new("", $Script:LMAuth.Key).Password
                    }
                    If($Dashboard.file.widgetTokens.name -contains "apiId"){
                        $IdIndex = $Dashboard.file.widgetTokens.name.toLower().IndexOf("apiid")
                        $Dashboard.file.widgetTokens[$IdIndex].value = $Script:LMAuth.Id
                    }
                }

                #Check if a path has been provided and check if folder exists in selected root folder, if not create
                If($Dashboard.path){
                    [Array]$SubFolders = $Dashboard.path -split  "\\|/" | Where-Object {$_}

                    For($Index = 0; $Index -lt $($SubFolders | Measure-Object).Count; $Index++){

                        If($Index -eq 0){
                            $DashboardGroup = Get-LMDashboardGroup -ParentGroupId $ParentGroupId | Where-Object {$_.Name -eq $SubFolders[$Index]}

                            If(!$DashboardGroup){
                                Write-LMHost "Existing dashboard group not found for $($Subfolders[$Index]) creating new resource group under root group ($ParentGroupName)"
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
                                Write-LMHost "Existing dashboard group not found for $($Subfolders[$Index]) creating new resource group under group ($($NewDashboardParentGroup.Name))"
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
        
                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Body $Data
                    Write-LMHost "Successfully imported dashboard: $($Dashboard.file.name)"
    
                    $Response
    
                }
                Catch [Exception] {
                    Write-LMHost "Failed to import dashboard: $($Dashboard.file.name)"
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
    End {}
}