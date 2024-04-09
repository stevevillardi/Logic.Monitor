<#
.SYNOPSIS
Generates a random password with the specified length.

.DESCRIPTION
The New-LMRandomCred function generates a random password using a specified length. It uses a set of valid password characters and a cryptographic random number generator to ensure the password is secure.

.PARAMETER Length
The length of the password to generate. The default value is 25.

.EXAMPLE
PS> New-LMRandomCred -Length 12
Generates a random password with a length of 12 characters.

.OUTPUTS
System.String
A randomly generated password.

#>
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
