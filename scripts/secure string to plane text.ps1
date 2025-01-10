#This script converts securestring to plaintext
cls
$SecureString = Get-Credential -Message "Provide a username and password"

Write-Host "this is the password: $($SecureString.Password) of $($SecureString.UserName)"

$ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString.Password)
try {
    $plaintext = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr)
} finally {
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssPtr)
}

Write-Host "this is the password: $($plaintext) of $($SecureString.UserName)"