---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMScanIPRange

## SYNOPSIS
Scan IP-Addresses, Ports and HostNames

## SYNTAX

### Address
```
Invoke-LMScanIPRange [-StartAddress] <String> [-EndAddress] <String> [-ResolveHost] [-ScanPort]
 [-Ports <Int32[]>] [-PingTimeout <Int32>] [-PortScanTimeout <Int32>] [-ShowProgress] [<CommonParameters>]
```

### Range
```
Invoke-LMScanIPRange [-AddressRange] <String> [-ResolveHost] [-ScanPort] [-Ports <Int32[]>]
 [-PingTimeout <Int32>] [-PortScanTimeout <Int32>] [-ShowProgress] [<CommonParameters>]
```

## DESCRIPTION
Scan for IP-Addresses, HostNames and open Ports in your Network.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMScanIPRange -StartAddress 192.168.0.1 -EndAddress 192.168.0.254
```

### EXAMPLE 2
```
Invoke-LMScanIPRange -StartAddress 192.168.0.1 -EndAddress 192.168.0.254 -ResolveHost
```

### EXAMPLE 3
```
Invoke-LMScanIPRange -StartAddress 192.168.0.1 -EndAddress 192.168.0.254 -ResolveHost -ScanPort
```

### EXAMPLE 4
```
Invoke-LMScanIPRange -StartAddress 192.168.0.1 -EndAddress 192.168.0.254 -ResolveHost -ScanPort -TimeOut 500
```

### EXAMPLE 5
```
Invoke-LMScanIPRange -StartAddress 192.168.0.1 -EndAddress 192.168.10.254 -ResolveHost -ScanPort -Port 80
```

## PARAMETERS

### -StartAddress
StartAddress Range

```yaml
Type: String
Parameter Sets: Address
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndAddress
EndAddress Range

```yaml
Type: String
Parameter Sets: Address
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AddressRange
{{ Fill AddressRange Description }}

```yaml
Type: String
Parameter Sets: Range
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResolveHost
Resolve HostName

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScanPort
Perform a PortScan

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Ports
Ports That should be scanned, default values are: 21,22,23,25,53,69,80,81,110,123,135,143,389,443,445,631,993,1433,1521,3306,3389,5432,5672,6081,7199,8000,8080,8081,9100,10000,11211,27017

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @(21,22,23,25,53,69,80,123,135,389,443,445,3389)
Accept pipeline input: False
Accept wildcard characters: False
```

### -PingTimeout
{{ Fill PingTimeout Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 500
Accept pipeline input: False
Accept wildcard characters: False
```

### -PortScanTimeout
{{ Fill PortScanTimeout Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowProgress
{{ Fill ShowProgress Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
