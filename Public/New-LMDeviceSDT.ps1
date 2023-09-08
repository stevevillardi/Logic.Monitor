Function New-LMDeviceSDT {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Comment,

        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceName')]
        [Datetime]$StartDate,

        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceName')]
        [Datetime]$EndDate,

        # [Parameter(Mandatory)]
        # [ValidateSet("Africa/Abidjan", "Africa/Accra", "Africa/Addis_Ababa", "Africa/Algiers", "Africa/Asmara", "Africa/Bamako", "Africa/Bangui", "Africa/Banjul", "Africa/Bissau", "Africa/Blantyre", "Africa/Brazzaville", "Africa/Bujumbura", "Africa/Cairo", "Africa/Casablanca", "Africa/Ceuta", "Africa/Conakry", "Africa/Dakar", "Africa/Dar_es_Salaam", "Africa/Djibouti", "Africa/Douala", "Africa/El_Aaiun", "Africa/Freetown", "Africa/Gaborone", "Africa/Harare", "Africa/Johannesburg", "Africa/Juba", "Africa/Kampala", "Africa/Khartoum", "Africa/Kigali", "Africa/Kinshasa", "Africa/Lagos", "Africa/Libreville", "Africa/Lome", "Africa/Luanda", "Africa/Lubumbashi", "Africa/Lusaka", "Africa/Malabo", "Africa/Maputo", "Africa/Maseru", "Africa/Mbabane", "Africa/Mogadishu", "Africa/Monrovia", "Africa/Nairobi", "Africa/Ndjamena", "Africa/Niamey", "Africa/Nouakchott", "Africa/Ouagadougou", "Africa/Porto-Novo", "Africa/Sao_Tome", "Africa/Tripoli", "Africa/Tunis", "Africa/Windhoek", "America/Adak", "America/Anchorage", "America/Anguilla", "America/Antigua", "America/Araguaina", "America/Argentina/Buenos_Aires", "America/Argentina/Catamarca", "America/Argentina/Cordoba", "America/Argentina/Jujuy", "America/Argentina/La_Rioja", "America/Argentina/Mendoza", "America/Argentina/Rio_Gallegos", "America/Argentina/Salta", "America/Argentina/San_Juan", "America/Argentina/San_Luis", "America/Argentina/Tucuman", "America/Argentina/Ushuaia", "America/Aruba", "America/Asuncion", "America/Atikokan", "America/Bahia", "America/Bahia_Banderas", "America/Barbados", "America/Belem", "America/Belize", "America/Blanc-Sablon", "America/Boa_Vista", "America/Bogota", "America/Boise", "America/Cambridge_Bay", "America/Campo_Grande", "America/Cancun", "America/Caracas", "America/Cayenne", "America/Cayman", "America/Chicago", "America/Chihuahua", "America/Costa_Rica", "America/Creston", "America/Cuiaba", "America/Curacao", "America/Danmarkshavn", "America/Dawson", "America/Dawson_Creek", "America/Denver", "America/Detroit", "America/Dominica", "America/Edmonton", "America/Eirunepe", "America/El_Salvador", "America/Fort_Nelson", "America/Fortaleza", "America/Glace_Bay", "America/Goose_Bay", "America/Grand_Turk", "America/Grenada", "America/Guadeloupe", "America/Guatemala", "America/Guayaquil", "America/Guyana", "America/Halifax", "America/Havana", "America/Hermosillo", "America/Indiana/Indianapolis", "America/Indiana/Knox", "America/Indiana/Marengo", "America/Indiana/Petersburg", "America/Indiana/Tell_City", "America/Indiana/Vevay", "America/Indiana/Vincennes", "America/Indiana/Winamac", "America/Inuvik", "America/Iqaluit", "America/Jamaica", "America/Juneau", "America/Kentucky/Louisville", "America/Kentucky/Monticello", "America/Kralendijk", "America/La_Paz", "America/Lima", "America/Los_Angeles", "America/Lower_Princes", "America/Maceio", "America/Managua", "America/Manaus", "America/Marigot", "America/Martinique", "America/Matamoros", "America/Mazatlan", "America/Menominee", "America/Merida", "America/Metlakatla", "America/Mexico_City", "America/Miquelon", "America/Moncton", "America/Monterrey", "America/Montevideo", "America/Montserrat", "America/Nassau", "America/New_York", "America/Nipigon", "America/Nome", "America/Noronha", "America/North_Dakota/Beulah", "America/North_Dakota/Center", "America/North_Dakota/New_Salem", "America/Nuuk", "America/Ojinaga", "America/Panama", "America/Pangnirtung", "America/Paramaribo", "America/Phoenix", "America/Port_of_Spain", "America/Port-au-Prince", "America/Porto_Velho", "America/Puerto_Rico", "America/Punta_Arenas", "America/Rainy_River", "America/Rankin_Inlet", "America/Recife", "America/Regina", "America/Resolute", "America/Rio_Branco", "America/Santarem", "America/Santiago", "America/Santo_Domingo", "America/Sao_Paulo", "America/Scoresbysund", "America/Sitka", "America/St_Barthelemy", "America/St_Johns", "America/St_Kitts", "America/St_Lucia", "America/St_Thomas", "America/St_Vincent", "America/Swift_Current", "America/Tegucigalpa", "America/Thule", "America/Thunder_Bay", "America/Tijuana", "America/Toronto", "America/Tortola", "America/Vancouver", "America/Whitehorse", "America/Winnipeg", "America/Yakutat", "America/Yellowknife", "Antarctica/Casey", "Antarctica/Davis", "Antarctica/DumontDUrville", "Antarctica/Macquarie", "Antarctica/Mawson", "Antarctica/McMurdo", "Antarctica/Palmer", "Antarctica/Rothera", "Antarctica/Syowa", "Antarctica/Troll", "Antarctica/Vostok", "Arctic/Longyearbyen", "Asia/Aden", "Asia/Almaty", "Asia/Amman", "Asia/Anadyr", "Asia/Aqtau", "Asia/Aqtobe", "Asia/Ashgabat", "Asia/Atyrau", "Asia/Baghdad", "Asia/Bahrain", "Asia/Baku", "Asia/Bangkok", "Asia/Barnaul", "Asia/Beirut", "Asia/Bishkek", "Asia/Brunei", "Asia/Chita", "Asia/Choibalsan", "Asia/Colombo", "Asia/Damascus", "Asia/Dhaka", "Asia/Dili", "Asia/Dubai", "Asia/Dushanbe", "Asia/Famagusta", "Asia/Gaza", "Asia/Hebron", "Asia/Ho_Chi_Minh", "Asia/Hong_Kong", "Asia/Hovd", "Asia/Irkutsk", "Asia/Jakarta", "Asia/Jayapura", "Asia/Jerusalem", "Asia/Kabul", "Asia/Kamchatka", "Asia/Karachi", "Asia/Kathmandu", "Asia/Khandyga", "Asia/Kolkata", "Asia/Krasnoyarsk", "Asia/Kuala_Lumpur", "Asia/Kuching", "Asia/Kuwait", "Asia/Macau", "Asia/Magadan", "Asia/Makassar", "Asia/Manila", "Asia/Muscat", "Asia/Nicosia", "Asia/Novokuznetsk", "Asia/Novosibirsk", "Asia/Omsk", "Asia/Oral", "Asia/Phnom_Penh", "Asia/Pontianak", "Asia/Pyongyang", "Asia/Qatar", "Asia/Qostanay", "Asia/Qyzylorda", "Asia/Riyadh", "Asia/Sakhalin", "Asia/Samarkand", "Asia/Seoul", "Asia/Shanghai", "Asia/Singapore", "Asia/Srednekolymsk", "Asia/Taipei", "Asia/Tashkent", "Asia/Tbilisi", "Asia/Tehran", "Asia/Thimphu", "Asia/Tokyo", "Asia/Tomsk", "Asia/Ulaanbaatar", "Asia/Urumqi", "Asia/Ust-Nera", "Asia/Vientiane", "Asia/Vladivostok", "Asia/Yakutsk", "Asia/Yangon", "Asia/Yekaterinburg", "Asia/Yerevan", "Atlantic/Azores", "Atlantic/Bermuda", "Atlantic/Canary", "Atlantic/Cape_Verde", "Atlantic/Faroe", "Atlantic/Madeira", "Atlantic/Reykjavik", "Atlantic/South_Georgia", "Atlantic/St_Helena", "Atlantic/Stanley", "Australia/Adelaide", "Australia/Brisbane", "Australia/Broken_Hill", "Australia/Darwin", "Australia/Eucla", "Australia/Hobart", "Australia/Lindeman", "Australia/Lord_Howe", "Australia/Melbourne", "Australia/Perth", "Australia/Sydney", "Europe/Amsterdam", "Europe/Andorra", "Europe/Astrakhan", "Europe/Athens", "Europe/Belgrade", "Europe/Berlin", "Europe/Bratislava", "Europe/Brussels", "Europe/Bucharest", "Europe/Budapest", "Europe/Busingen", "Europe/Chisinau", "Europe/Copenhagen", "Europe/Dublin", "Europe/Gibraltar", "Europe/Guernsey", "Europe/Helsinki", "Europe/Isle_of_Man", "Europe/Istanbul", "Europe/Jersey", "Europe/Kaliningrad", "Europe/Kiev", "Europe/Kirov", "Europe/Lisbon", "Europe/Ljubljana", "Europe/London", "Europe/Luxembourg", "Europe/Madrid", "Europe/Malta", "Europe/Mariehamn", "Europe/Minsk", "Europe/Monaco", "Europe/Moscow", "Europe/Oslo", "Europe/Paris", "Europe/Podgorica", "Europe/Prague", "Europe/Riga", "Europe/Rome", "Europe/Samara", "Europe/San_Marino", "Europe/Sarajevo", "Europe/Saratov", "Europe/Simferopol", "Europe/Skopje", "Europe/Sofia", "Europe/Stockholm", "Europe/Tallinn", "Europe/Tirane", "Europe/Ulyanovsk", "Europe/Uzhgorod", "Europe/Vaduz", "Europe/Vatican", "Europe/Vienna", "Europe/Vilnius", "Europe/Volgograd", "Europe/Warsaw", "Europe/Zagreb", "Europe/Zaporozhye", "Europe/Zurich", "Indian/Antananarivo", "Indian/Chagos", "Indian/Christmas", "Indian/Cocos", "Indian/Comoro", "Indian/Kerguelen", "Indian/Mahe", "Indian/Maldives", "Indian/Mauritius", "Indian/Mayotte", "Indian/Reunion", "Pacific/Apia", "Pacific/Auckland", "Pacific/Bougainville", "Pacific/Chatham", "Pacific/Chuuk", "Pacific/Easter", "Pacific/Efate", "Pacific/Enderbury", "Pacific/Fakaofo", "Pacific/Fiji", "Pacific/Funafuti", "Pacific/Galapagos", "Pacific/Gambier", "Pacific/Guadalcanal", "Pacific/Guam", "Pacific/Honolulu", "Pacific/Kiritimati", "Pacific/Kosrae", "Pacific/Kwajalein", "Pacific/Majuro", "Pacific/Marquesas", "Pacific/Midway", "Pacific/Nauru", "Pacific/Niue", "Pacific/Norfolk", "Pacific/Noumea", "Pacific/Pago_Pago", "Pacific/Palau", "Pacific/Pitcairn", "Pacific/Pohnpei", "Pacific/Port_Moresby", "Pacific/Rarotonga", "Pacific/Saipan", "Pacific/Tahiti", "Pacific/Tarawa", "Pacific/Tongatapu", "Pacific/Wake", "Pacific/Wallis")]
        # [String]$Timezone,

        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceId')]
        [String]$DeviceId,
        
        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceName')]
        [String]$DeviceName,
        
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceId')]
        [ValidateRange(0, 23)]
        [Int]$StartHour,

        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceId')]
        [ValidateRange(0, 59)]
        [Int]$StartMinute,

        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceId')]
        [ValidateRange(0, 23)]
        [Int]$EndHour,

        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceId')]
        [ValidateRange(0, 59)]
        [Int]$EndMinute,

        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceName')]
        [ValidateSet("Monday", "Tuesday", "Wednesday","Thursday","Friday","Saturday","Sunday")]
        [String]$WeekDay,

        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceName')]
        [ValidateSet("First", "Second", "Third","Fourth","Last")]
        [String]$WeekOfMonth,

        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceName')]
        [ValidateRange(1, 31)]
        [Int]$DayOfMonth

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Lookup DeviceId
        If ($DeviceName) {
            $LookupResult = (Get-LMDevice -Name $DeviceName).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $DeviceName) {
                Return
            }
            $DeviceId = $LookupResult
        }
        
        Switch -Wildcard ($PSCmdlet.ParameterSetName){
            "OneTime-Device*" {$Occurance = "oneTime"}
            "Daily-Device*" {$Occurance = "daily"}
            "Monthly-Device*" {$Occurance = "monthly"}
            "MonthlyByWeek-Device*" {$Occurance = "monthlyByWeek"}
            "Weekly-Device*" {$Occurance = "weekly"}
        }

        #Build header and uri
        $ResourcePath = "/sdt/sdts"

        Try {
            $Data = $null

            $Data = @{
                comment         = $Comment
                deviceId        = $DeviceId
                sdtType         = $Occurance
                #timezone        = $Timezone
                type            = "ResourceSDT"
            }

            Switch ($Occurance){
               "onetime" {
                    #Get UTC time based on selected timezone
                    # $TimeZoneID = [System.TimeZoneInfo]::FindSystemTimeZoneById($Timezone)
                    # $StartUTCTime = [System.TimeZoneInfo]::ConvertTimeFromUtc((Get-Date $StartDate).ToUniversalTime(), $TimeZoneID)
                    # $EndUTCTime = [System.TimeZoneInfo]::ConvertTimeFromUtc((Get-Date $EndDate).ToUniversalTime(), $TimeZoneID)

                    # #Get epoch time and include selected timezone offset
                    # $StartDateTime = (New-TimeSpan -Start (Get-Date "01/01/1970") -End $StartUTCTime).TotalMilliseconds - $TimeZoneID.BaseUtcOffset.TotalMilliseconds
                    # $EndDateTime = (New-TimeSpan -Start (Get-Date "01/01/1970") -End $EndUTCTime).TotalMilliseconds - $TimeZoneID.BaseUtcOffset.TotalMilliseconds

                    $StartDateTime = (New-TimeSpan -Start (Get-Date "01/01/1970") -End $StartDate.ToUniversalTime()).TotalMilliseconds
                    $EndDateTime = (New-TimeSpan -Start (Get-Date "01/01/1970") -End $EndDate.ToUniversalTime()).TotalMilliseconds
                    $Data.Add('endDateTime',[math]::Round($EndDateTime))
                    $Data.Add('startDateTime',[math]::Round($StartDateTime))
               }

               "daily" {
                    $Data.Add('hour',$StartHour)
                    $Data.Add('minute',$StartMinute)
                    $Data.Add('endHour',$EndHour)
                    $Data.Add('endMinute',$EndMinute)
               } 
               
               "weekly" {
                    $Data.Add('hour',$StartHour)
                    $Data.Add('minute',$StartMinute)
                    $Data.Add('endHour',$EndHour)
                    $Data.Add('endMinute',$EndMinute)
                    $Data.Add('weekDay',$WeekDay)
               } 
               
               "monthly" {
                    $Data.Add('hour',$StartHour)
                    $Data.Add('minute',$StartMinute)
                    $Data.Add('endHour',$EndHour)
                    $Data.Add('endMinute',$EndMinute)
                    $Data.Add('monthDay',$DayOfMonth)
               } 
               
               "monthlyByWeek" {
                    $Data.Add('hour',$StartHour)
                    $Data.Add('minute',$StartMinute)
                    $Data.Add('endHour',$EndHour)
                    $Data.Add('endMinute',$EndMinute)
                    $Data.Add('weekDay',$WeekDay)
                    $Data.Add('WeekOfMonth',$WeekOfMonth)
               } 

               default {}
            }

            #Remove empty keys so we dont overwrite them
            @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            Return $Response
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