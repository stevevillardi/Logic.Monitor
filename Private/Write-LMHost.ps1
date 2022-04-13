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
}