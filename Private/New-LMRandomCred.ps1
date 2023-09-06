Function New-LMRandomCred {

    [CmdletBinding()]
    Param (
        [Int]$Length = 25
    )

    # Valid password characters
    $SymbolSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!$%^()_-+=}{][@#&\|;:<>.?/".ToCharArray()

    #Generate random bytes
    $Random = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $Bytes = New-Object Byte[]($Length)
  
    #Generate character set
    $Random.GetBytes($Bytes)
    $Result = New-Object Char[]($Length)
  
    #Construct randomized password
    For ($i = 0 ; $i -lt $Length ; $i++) {
        $Result[$i] = $SymbolSet[$Bytes[$i]%$SymbolSet.Length]
    }
 
    #Return result
    Return -Join $Result

}
