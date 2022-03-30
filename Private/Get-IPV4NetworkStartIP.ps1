Function Get-IPV4NetworkStartIP ($StrNetwork){
    Try{
        $StrNetworkAddress = ($StrNetwork.Split("/"))[0]
        $NetworkIP = ([System.Net.IPAddress]$StrNetworkAddress).GetAddressBytes()
        [array]::Reverse($NetworkIP)
        $NetworkIP = ([System.Net.IPAddress]($NetworkIP -join ".")).Address
        $StartIP = $NetworkIP + 1
    }
    Catch{
        #Write-Error "Invalid IP range entered: $StrNetwork"
        return
    }

    #Convert To Double
    If (($StartIP.GetType()).Name -ine "double"){
        $StartIP = [Convert]::ToDouble($StartIP)
    }
    $StartIP = [System.Net.IPAddress]$StartIP

    Return $StartIP
}
