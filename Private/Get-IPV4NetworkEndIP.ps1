Function Get-IPV4NetworkEndIP ($StrNetwork){
    Try{
        $StrNetworkAddress = ($StrNetwork.Split("/"))[0]
        [int]$NetworkLength = ($StrNetwork.Split("/"))[1]
        $IPLength = 32 - $NetworkLength
        $NumberOfIPs = ([System.Math]::Pow(2,$IPLength)) - 1
        $NetworkIP = ([System.Net.IPAddress]$StrNetworkAddress).GetAddressBytes()
        [array]::Reverse($NetworkIP)
        $NetworkIP = ([System.Net.IPAddress]($NetworkIP -join ".")).Address
        $EndIP = $NetworkIP + $NumberOfIPs
    }
    Catch {
        #Write-Error "Invalid IP range entered: $StrNetwork"
        return
    }

    If (($EndIP.GetType()).Name -ine "double"){
        $EndIP = [Convert]::ToDouble($EndIP)
    }

    $EndIP = [System.Net.IPAddress]$EndIP

    Return $EndIP
}
