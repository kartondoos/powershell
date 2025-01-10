#unicode, UTF8, ASCII
#decode to text 
$text_to_base64 = "VwByAGkAdABlAC0ASABvAHMAdAAgACIAdABlAHMAdAAxADIAMwAiAA=="
$base64decoded = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($text_to_base64))
Write-Host $base64decoded

#encode to Base64
$plain_to_base64 = @'
Write-Host "test123"
'@
$base64encoded = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($plain_to_base64))
Write-Host $base64encoded

#powershell.exe -EncodedCommand $base64encoded

#convert base64 to file
$base64 = ''
$filename = '.\test.txt'

$bytes = [System.Convert]::FromBase64String($base64)
[System.IO.File]::WriteAllBytes($filename, $bytes)