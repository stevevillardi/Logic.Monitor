function Invoke-LMScanIPRange {
<#
    .SYNOPSIS
    Scan IP-Addresses, Ports and HostNames
    .DESCRIPTION
    Scan for IP-Addresses, HostNames and open Ports in your Network.
    .PARAMETER StartAddress
    StartAddress Range
    .PARAMETER EndAddress
    EndAddress Range
    .PARAMETER ResolveHost
    Resolve HostName
    .PARAMETER ScanPort
    Perform a PortScan
    .PARAMETER Ports
    Ports That should be scanned, default values are: 21,22,23,25,53,69,80,81,110,123,135,143,389,443,445,631,993,1433,1521,3306,3389,5432,5672,6081,7199,8000,8080,8081,9100,10000,11211,27017
    .PARAMETER TimeOut
    Time (in MilliSeconds) before TimeOut, Default set to 100
    .EXAMPLE
    Invoke-TSPingSweep -StartAddress 192.168.0.1 -EndAddress 192.168.0.254
    .EXAMPLE
    Invoke-TSPingSweep -StartAddress 192.168.0.1 -EndAddress 192.168.0.254 -ResolveHost
    .EXAMPLE
    Invoke-TSPingSweep -StartAddress 192.168.0.1 -EndAddress 192.168.0.254 -ResolveHost -ScanPort
    .EXAMPLE
    Invoke-TSPingSweep -StartAddress 192.168.0.1 -EndAddress 192.168.0.254 -ResolveHost -ScanPort -TimeOut 500
    .EXAMPLE
    Invoke-TSPingSweep -StartAddress 192.168.0.1 -EndAddress 192.168.10.254 -ResolveHost -ScanPort -Port 80
    #>
    Param(
        [Parameter(Mandatory = $true,Position = 0,ParameterSetName = 'Address')]
        [ValidatePattern("\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b")]
        [string]$StartAddress,

        [Parameter(Mandatory = $true,Position = 1,ParameterSetName = 'Address')]
        [ValidatePattern("\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b")]
        [string]$EndAddress,

        [Parameter(Mandatory = $true,Position = 0,ParameterSetName = 'Range')]
        [string]$AddressRange,

        [switch]$ResolveHost,

        [switch]$ScanPort,

        [int[]]$Ports = @(21,22,23,25,53,69,80,123,135,389,443,445,3389),

        [int]$PingTimeout = 500,

        [int]$PortScanTimeout = 100,

        [switch]$ShowProgress
    )
    Begin {
        $Ping = New-Object System.Net.Networkinformation.Ping
    }
    Process {
        If ($AddressRange){
            Try{
                $StartAddress = Get-IPV4NetworkStartIP $AddressRange
                $EndAddress = Get-IPV4NetworkEndIP $AddressRange
            }
            Catch {
                Write-Error "Invalid IP range entered: $AddressRange"
                return
            }
        }

        Foreach ($a in ($StartAddress.Split(".")[0]..$EndAddress.Split(".")[0])) {
            Foreach ($b in ($StartAddress.Split(".")[1]..$EndAddress.Split(".")[1])) {
                Foreach ($c in ($StartAddress.Split(".")[2]..$EndAddress.Split(".")[2])) {
                    Foreach ($d in ($StartAddress.Split(".")[3]..$EndAddress.Split(".")[3])) {
                        If ($ShowProgress) {
                            Write-Progress -Activity PingSweep -Status "$a.$b.$c.$d" -PercentComplete (($d / ($EndAddress.Split(".")[3])) * 100)
                        }
                        $PingStatus = $Ping.Send("$a.$b.$c.$d",$PingTimeout)
                        If ($PingStatus.Status -eq "Success") {
                            If ($ResolveHost) {
                                If ($ShowProgress) {
                                    Write-Progress -Activity ResolveHost -Status "$a.$b.$c.$d" -PercentComplete (($d / ($EndAddress.Split(".")[3])) * 100) -Id 1
                                }
                                $GetHostEntry = [Net.DNS]::BeginGetHostEntry($PingStatus.Address,$null,$null)
                            }
                            If ($ScanPort) {
                                $OpenPorts = @()
                                For ($i = 1; $i -le $Ports.Count; $i++) {
                                    $Port = $Ports[($i - 1)]
                                    If ($ShowProgress) {
                                        Write-Progress -Activity PortScan -Status "$a.$b.$c.$d" -PercentComplete (($i / ($Ports.Count)) * 100) -Id 2
                                    }
                                    $Client = New-Object System.Net.Sockets.TcpClient
                                    Try{
                                        $beginConnect = $Client.BeginConnect($PingStatus.Address,$Port,$null,$null)
                                        If ($Client.Connected) {
                                            $OpenPorts += $Port
                                        }
                                        Else {
                                            # Wait
                                            Start-Sleep -Milli $PortScanTimeOut
                                            If ($Client.Connected) {
                                                $OpenPorts += $Port
                                            }
                                        }
                                        $Client.Close()
                                    }
                                    Catch{
                                        $Client.Close()
                                    }
                                }
                            }
                            If ($ResolveHost) {
                                Try{
                                    $HostName = ([Net.DNS]::EndGetHostEntry([IAsyncResult]$GetHostEntry)).HostName
                                }
                                Catch {
                                    $HostName = $null
                                }
                            }
                            # Return Object
                            New-Object PSObject -Property @{
                                IPAddress = "$a.$b.$c.$d";
                                HostName = $HostName;
                                Ports = $OpenPorts
                            } | Select-Object IPAddress,HostName,Ports
                        }
                    }
                }
            }
        }
    }
    End {
    }
}
