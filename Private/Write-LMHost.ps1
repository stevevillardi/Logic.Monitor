<#
.SYNOPSIS
Writes a message to the host with optional foreground and background colors.

.DESCRIPTION
The Write-LMHost function writes a message to the host console. It provides the option to specify the foreground and background colors of the message.

.PARAMETER Message
The message to be written to the host.

.PARAMETER ForegroundColor
The foreground color of the message. This parameter accepts a ConsoleColor value.

.PARAMETER BackgroundColor
The background color of the message. This parameter accepts a ConsoleColor value.

.NOTES
Only log message content if the switch is set to true during connect-lmaccount.

.EXAMPLE
Write-LMHost -Message "Hello, World!" -ForegroundColor Green -BackgroundColor Black
Writes the message "Hello, World!" to the host console with green foreground color and black background color.

.EXAMPLE
Write-LMHost -Message "Error: Something went wrong." -ForegroundColor Red
Writes the error message "Error: Something went wrong." to the host console with red foreground color.

#>

Function Write-LMHost {
    Param (
        [Object]$Message=$args[0],
    
        [Nullable[ConsoleColor]]$ForegroundColor,

        [Nullable[ConsoleColor]]$BackgroundColor
    )
    #Only log message content if switch is set to true during connect lm account
    If($Script:LMAuth.Logging){
        If($ForegroundColor -and !$BackgroundColor){
            Write-Host $Message -ForegroundColor $ForegroundColor
        }
        ElseIf(!$ForegroundColor -and $BackgroundColor) {
            Write-Host $Message -BackgroundColor $BackgroundColor
        }
        ElseIf($ForegroundColor -and $BackgroundColor){
            Write-Host $Message -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
        }
        Else{
            Write-Host $Message
        }
    }
    Else{
        Write-Host $Message
    }
}