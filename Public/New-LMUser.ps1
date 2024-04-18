<#
.SYNOPSIS
Creates a new LogicMonitor user.

.DESCRIPTION
The New-LMUser function creates a new user in LogicMonitor with the specified parameters.

.PARAMETER Username
The username of the new user. This parameter is mandatory.

.PARAMETER Email
The email address of the new user. This parameter is mandatory.

.PARAMETER AcceptEULA
Specifies whether the user has accepted the End User License Agreement (EULA). The default value is $false.

.PARAMETER Password
The password for the new user.

.PARAMETER UserGroups
An array of user group names to which the new user should be added.

.PARAMETER FirstName
The first name of the new user.

.PARAMETER LastName
The last name of the new user.

.PARAMETER ForcePasswordChange
Specifies whether the new user should be forced to change their password on first login. The default value is $true.

.PARAMETER Phone
The phone number of the new user.

.PARAMETER Note
A note or description for the new user.

.PARAMETER RoleNames
An array of role names to assign to the new user. The default value is "readonly".

.PARAMETER SmsEmail
The SMS email address for the new user.

.PARAMETER SmsEmailFormat
The format of SMS emails for the new user. Valid values are "sms" and "fulltext". The default value is "sms".

.PARAMETER Status
The status of the new user. Valid values are "active" and "suspended". The default value is "active".

.PARAMETER Timezone
The timezone for the new user. Valid values are listed in the function code.

.PARAMETER TwoFAEnabled
Specifies whether two-factor authentication (2FA) is enabled for the new user. The default value is $false.

.PARAMETER Views
An array of views that the new user should have access to. Valid values are listed in the function code.

.EXAMPLE
New-LMUser -Username "john.doe" -Email "john.doe@example.com" -Password "P@ssw0rd" -RoleNames @("admin") -Views @("Dashboards", "Reports")

This example creates a new LogicMonitor user with the username "john.doe", email "john.doe@example.com", password "P@ssw0rd", role "admin", and access to the "Dashboards" and "Reports" views.

.NOTES
This function requires valid API credentials and a logged-in session in LogicMonitor.
#>
Function New-LMUser {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Username,

        [Parameter(Mandatory)]
        [String]$Email,

        [Boolean]$AcceptEULA = $false,

        [String]$Password,

        [String[]]$UserGroups,

        [String]$FirstName,

        [String]$LastName,

        [Boolean]$ForcePasswordChange = $true,

        [String]$Phone,

        [String]$Note,

        [String[]]$RoleNames = @("readonly"),

        [String]$SmsEmail,

        [ValidateSet("sms", "fulltext")]
        [String]$SmsEmailFormat = "sms",

        [ValidateSet("active", "suspended")]
        [String]$Status = "active",

        [ValidateSet("Africa/Abidjan", "Africa/Accra", "Africa/Addis_Ababa", "Africa/Algiers", "Africa/Asmara", "Africa/Bamako", "Africa/Bangui", "Africa/Banjul", "Africa/Bissau", "Africa/Blantyre", "Africa/Brazzaville", "Africa/Bujumbura", "Africa/Cairo", "Africa/Casablanca", "Africa/Ceuta", "Africa/Conakry", "Africa/Dakar", "Africa/Dar_es_Salaam", "Africa/Djibouti", "Africa/Douala", "Africa/El_Aaiun", "Africa/Freetown", "Africa/Gaborone", "Africa/Harare", "Africa/Johannesburg", "Africa/Juba", "Africa/Kampala", "Africa/Khartoum", "Africa/Kigali", "Africa/Kinshasa", "Africa/Lagos", "Africa/Libreville", "Africa/Lome", "Africa/Luanda", "Africa/Lubumbashi", "Africa/Lusaka", "Africa/Malabo", "Africa/Maputo", "Africa/Maseru", "Africa/Mbabane", "Africa/Mogadishu", "Africa/Monrovia", "Africa/Nairobi", "Africa/Ndjamena", "Africa/Niamey", "Africa/Nouakchott", "Africa/Ouagadougou", "Africa/Porto-Novo", "Africa/Sao_Tome", "Africa/Tripoli", "Africa/Tunis", "Africa/Windhoek", "America/Adak", "America/Anchorage", "America/Anguilla", "America/Antigua", "America/Araguaina", "America/Argentina/Buenos_Aires", "America/Argentina/Catamarca", "America/Argentina/Cordoba", "America/Argentina/Jujuy", "America/Argentina/La_Rioja", "America/Argentina/Mendoza", "America/Argentina/Rio_Gallegos", "America/Argentina/Salta", "America/Argentina/San_Juan", "America/Argentina/San_Luis", "America/Argentina/Tucuman", "America/Argentina/Ushuaia", "America/Aruba", "America/Asuncion", "America/Atikokan", "America/Bahia", "America/Bahia_Banderas", "America/Barbados", "America/Belem", "America/Belize", "America/Blanc-Sablon", "America/Boa_Vista", "America/Bogota", "America/Boise", "America/Cambridge_Bay", "America/Campo_Grande", "America/Cancun", "America/Caracas", "America/Cayenne", "America/Cayman", "America/Chicago", "America/Chihuahua", "America/Costa_Rica", "America/Creston", "America/Cuiaba", "America/Curacao", "America/Danmarkshavn", "America/Dawson", "America/Dawson_Creek", "America/Denver", "America/Detroit", "America/Dominica", "America/Edmonton", "America/Eirunepe", "America/El_Salvador", "America/Fort_Nelson", "America/Fortaleza", "America/Glace_Bay", "America/Goose_Bay", "America/Grand_Turk", "America/Grenada", "America/Guadeloupe", "America/Guatemala", "America/Guayaquil", "America/Guyana", "America/Halifax", "America/Havana", "America/Hermosillo", "America/Indiana/Indianapolis", "America/Indiana/Knox", "America/Indiana/Marengo", "America/Indiana/Petersburg", "America/Indiana/Tell_City", "America/Indiana/Vevay", "America/Indiana/Vincennes", "America/Indiana/Winamac", "America/Inuvik", "America/Iqaluit", "America/Jamaica", "America/Juneau", "America/Kentucky/Louisville", "America/Kentucky/Monticello", "America/Kralendijk", "America/La_Paz", "America/Lima", "America/Los_Angeles", "America/Lower_Princes", "America/Maceio", "America/Managua", "America/Manaus", "America/Marigot", "America/Martinique", "America/Matamoros", "America/Mazatlan", "America/Menominee", "America/Merida", "America/Metlakatla", "America/Mexico_City", "America/Miquelon", "America/Moncton", "America/Monterrey", "America/Montevideo", "America/Montserrat", "America/Nassau", "America/New_York", "America/Nipigon", "America/Nome", "America/Noronha", "America/North_Dakota/Beulah", "America/North_Dakota/Center", "America/North_Dakota/New_Salem", "America/Nuuk", "America/Ojinaga", "America/Panama", "America/Pangnirtung", "America/Paramaribo", "America/Phoenix", "America/Port_of_Spain", "America/Port-au-Prince", "America/Porto_Velho", "America/Puerto_Rico", "America/Punta_Arenas", "America/Rainy_River", "America/Rankin_Inlet", "America/Recife", "America/Regina", "America/Resolute", "America/Rio_Branco", "America/Santarem", "America/Santiago", "America/Santo_Domingo", "America/Sao_Paulo", "America/Scoresbysund", "America/Sitka", "America/St_Barthelemy", "America/St_Johns", "America/St_Kitts", "America/St_Lucia", "America/St_Thomas", "America/St_Vincent", "America/Swift_Current", "America/Tegucigalpa", "America/Thule", "America/Thunder_Bay", "America/Tijuana", "America/Toronto", "America/Tortola", "America/Vancouver", "America/Whitehorse", "America/Winnipeg", "America/Yakutat", "America/Yellowknife", "Antarctica/Casey", "Antarctica/Davis", "Antarctica/DumontDUrville", "Antarctica/Macquarie", "Antarctica/Mawson", "Antarctica/McMurdo", "Antarctica/Palmer", "Antarctica/Rothera", "Antarctica/Syowa", "Antarctica/Troll", "Antarctica/Vostok", "Arctic/Longyearbyen", "Asia/Aden", "Asia/Almaty", "Asia/Amman", "Asia/Anadyr", "Asia/Aqtau", "Asia/Aqtobe", "Asia/Ashgabat", "Asia/Atyrau", "Asia/Baghdad", "Asia/Bahrain", "Asia/Baku", "Asia/Bangkok", "Asia/Barnaul", "Asia/Beirut", "Asia/Bishkek", "Asia/Brunei", "Asia/Chita", "Asia/Choibalsan", "Asia/Colombo", "Asia/Damascus", "Asia/Dhaka", "Asia/Dili", "Asia/Dubai", "Asia/Dushanbe", "Asia/Famagusta", "Asia/Gaza", "Asia/Hebron", "Asia/Ho_Chi_Minh", "Asia/Hong_Kong", "Asia/Hovd", "Asia/Irkutsk", "Asia/Jakarta", "Asia/Jayapura", "Asia/Jerusalem", "Asia/Kabul", "Asia/Kamchatka", "Asia/Karachi", "Asia/Kathmandu", "Asia/Khandyga", "Asia/Kolkata", "Asia/Krasnoyarsk", "Asia/Kuala_Lumpur", "Asia/Kuching", "Asia/Kuwait", "Asia/Macau", "Asia/Magadan", "Asia/Makassar", "Asia/Manila", "Asia/Muscat", "Asia/Nicosia", "Asia/Novokuznetsk", "Asia/Novosibirsk", "Asia/Omsk", "Asia/Oral", "Asia/Phnom_Penh", "Asia/Pontianak", "Asia/Pyongyang", "Asia/Qatar", "Asia/Qostanay", "Asia/Qyzylorda", "Asia/Riyadh", "Asia/Sakhalin", "Asia/Samarkand", "Asia/Seoul", "Asia/Shanghai", "Asia/Singapore", "Asia/Srednekolymsk", "Asia/Taipei", "Asia/Tashkent", "Asia/Tbilisi", "Asia/Tehran", "Asia/Thimphu", "Asia/Tokyo", "Asia/Tomsk", "Asia/Ulaanbaatar", "Asia/Urumqi", "Asia/Ust-Nera", "Asia/Vientiane", "Asia/Vladivostok", "Asia/Yakutsk", "Asia/Yangon", "Asia/Yekaterinburg", "Asia/Yerevan", "Atlantic/Azores", "Atlantic/Bermuda", "Atlantic/Canary", "Atlantic/Cape_Verde", "Atlantic/Faroe", "Atlantic/Madeira", "Atlantic/Reykjavik", "Atlantic/South_Georgia", "Atlantic/St_Helena", "Atlantic/Stanley", "Australia/Adelaide", "Australia/Brisbane", "Australia/Broken_Hill", "Australia/Darwin", "Australia/Eucla", "Australia/Hobart", "Australia/Lindeman", "Australia/Lord_Howe", "Australia/Melbourne", "Australia/Perth", "Australia/Sydney", "Europe/Amsterdam", "Europe/Andorra", "Europe/Astrakhan", "Europe/Athens", "Europe/Belgrade", "Europe/Berlin", "Europe/Bratislava", "Europe/Brussels", "Europe/Bucharest", "Europe/Budapest", "Europe/Busingen", "Europe/Chisinau", "Europe/Copenhagen", "Europe/Dublin", "Europe/Gibraltar", "Europe/Guernsey", "Europe/Helsinki", "Europe/Isle_of_Man", "Europe/Istanbul", "Europe/Jersey", "Europe/Kaliningrad", "Europe/Kiev", "Europe/Kirov", "Europe/Lisbon", "Europe/Ljubljana", "Europe/London", "Europe/Luxembourg", "Europe/Madrid", "Europe/Malta", "Europe/Mariehamn", "Europe/Minsk", "Europe/Monaco", "Europe/Moscow", "Europe/Oslo", "Europe/Paris", "Europe/Podgorica", "Europe/Prague", "Europe/Riga", "Europe/Rome", "Europe/Samara", "Europe/San_Marino", "Europe/Sarajevo", "Europe/Saratov", "Europe/Simferopol", "Europe/Skopje", "Europe/Sofia", "Europe/Stockholm", "Europe/Tallinn", "Europe/Tirane", "Europe/Ulyanovsk", "Europe/Uzhgorod", "Europe/Vaduz", "Europe/Vatican", "Europe/Vienna", "Europe/Vilnius", "Europe/Volgograd", "Europe/Warsaw", "Europe/Zagreb", "Europe/Zaporozhye", "Europe/Zurich", "Indian/Antananarivo", "Indian/Chagos", "Indian/Christmas", "Indian/Cocos", "Indian/Comoro", "Indian/Kerguelen", "Indian/Mahe", "Indian/Maldives", "Indian/Mauritius", "Indian/Mayotte", "Indian/Reunion", "Pacific/Apia", "Pacific/Auckland", "Pacific/Bougainville", "Pacific/Chatham", "Pacific/Chuuk", "Pacific/Easter", "Pacific/Efate", "Pacific/Enderbury", "Pacific/Fakaofo", "Pacific/Fiji", "Pacific/Funafuti", "Pacific/Galapagos", "Pacific/Gambier", "Pacific/Guadalcanal", "Pacific/Guam", "Pacific/Honolulu", "Pacific/Kiritimati", "Pacific/Kosrae", "Pacific/Kwajalein", "Pacific/Majuro", "Pacific/Marquesas", "Pacific/Midway", "Pacific/Nauru", "Pacific/Niue", "Pacific/Norfolk", "Pacific/Noumea", "Pacific/Pago_Pago", "Pacific/Palau", "Pacific/Pitcairn", "Pacific/Pohnpei", "Pacific/Port_Moresby", "Pacific/Rarotonga", "Pacific/Saipan", "Pacific/Tahiti", "Pacific/Tarawa", "Pacific/Tongatapu", "Pacific/Wake", "Pacific/Wallis")]
        [String]$Timezone,

        [Boolean]$TwoFAEnabled = $false,

        [ValidateSet("Alerts", "Dashboards", "Logs", "Maps", "Reports", "Resources", "Settings", "Websites", "All")]
        [String[]]$Views = @("All")
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Build role id list
        $Roles = @()
        Foreach ($Role in $RoleNames) {
            $RoleId = (Get-LMRole -Name $Role | Select-Object -First 1 ).Id
            If ($RoleId) {
                $Roles += @{id = $RoleId }
            }
            Else {
                Write-LMHost "[WARN]: Unable to locate user role named $Role, it will be skipped" -ForegroundColor Yellow
            }
        }

        $AdminGroupIds = ""
        If ($UserGroups) {
            $AdminGroupIds = @()
            Foreach ($Group in $UserGroups) {
                If ($Group -Match "\*") {
                    Write-Error "Wildcard values not supported for groups." 
                    return
                }
                $Id = (Get-LMUserGroup -Name $Group | Select-Object -First 1 ).Id
                If (!$Id) {
                    Write-Error "Unable to find user group: $Group, please check spelling and try again." 
                    return
                }
                $AdminGroupIds += $Id
            }
        }

        #Build view permissions hashtable
        $ViewPermission = @{
            Alerts     = $false
            Dashboards = $false
            Logs       = $false
            Maps       = $false
            Reports    = $false
            Resources  = $false
            Settings   = $false
            Websites   = $false
        }

        Foreach ($View in $Views) {
            If ($View -eq "All") {
                Foreach ($key in $($ViewPermission.keys)) {
                    $ViewPermission[$key] = $true
                }
                break
            }
            ElseIf ($ViewPermission.ContainsKey($View)) {
                $ViewPermission[$View] = $true
            }
        }

        #Auto generate password if not provided
        $AutoGeneratePassword = $False
        If(!$Password){
            $Password = New-LMRandomCred
            $AutoGeneratePassword = $True
        }
        
        #Build header and uri
        $ResourcePath = "/setting/admins"

        Try {
            $Data = @{
                username            = $Username
                email               = $Email
                acceptEULA          = $AcceptEULA
                password            = $Password
                firstName           = $FirstName 
                lastName            = $LastName
                forcePasswordChange = $ForcePasswordChange
                phone               = "+" + $Phone.Replace("-", "")
                note                = $Note
                roles               = $Roles
                smsEmail            = $SmsEmail
                smsEmailFormat      = $SmsEmailFormat
                status              = $Status
                timezone            = $Timezone
                twoFAEnabled        = $TwoFAEnabled
                viewPermission      = $ViewPermission
                adminGroupIds       = $AdminGroupIds

            }

            #Remove empty keys so we dont overwrite them
            @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
            If($AutoGeneratePassword){
                If(!$global:LMUserData){
                    $UserData = New-Object System.Collections.ArrayList
                    $UserData.Add([PSCustomObject]@{"Username"=$Username;"Temp_Password"=$Password}) | Out-Null
                    New-Variable -Name LMUserData -Scope global -Value $UserData
                }
                Else{
                    $global:LMUserData.Add([PSCustomObject]@{"Username"=$Username;"Temp_Password"=$Password}) | Out-Null
                }
                
                Write-LMHost "[INFO]: Auto generated password assigned to $Username`: $Password" -ForegroundColor Yellow
                Write-LMHost "[INFO]: Auto generated passwords are also stored in a reference variable called `$LMUserData" -ForegroundColor Yellow
            }

            Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.User" )
        }
        Catch [Exception] {
            $Proceed = Resolve-LMException -LMException $PSItem
            If (!$Proceed) {
                Return
            }
        }
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
