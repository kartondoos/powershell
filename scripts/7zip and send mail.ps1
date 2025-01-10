#region Make .7z

#7z.exe --help

New-Item -ItemType Directory "$env:TEMP\tempzip"
copy "$env:APPDATA\Microsoft\Windows\Libraries\*" "$env:TEMP\tempzip\" -Recurse

$7zip = "$env:TEMP\tempzip_$(Get-Date -Format "yyyyMMdd_HHmmssfff").7z"
Start-Process -FilePath "$env:ProgramFiles\7-Zip\7z.exe" -ArgumentList "a -t7z $7zip -mmt2 -mx9 -w $env:TEMP\ -ppassword@zip" -Wait

#remove tempfolder that is used to build the zip
Remove-Item -Path "$env:TEMP\tempzip" -Recurse -Force
#endregion 

#region Email create

$outlook = new-object -comobject outlook.application
Write-Host "COM object created here"

$email = $outlook.CreateItem(0)
Write-Host "Outlook item created here"

$email.To = "XXXXXX@XXXXXX.com; XXXXXX@XXXXXX.com"
Write-Host "Recipient address created here"

$email.Subject = "QM-Tool-Logs from $env:UserName"
Write-Host "Subject created here"

$email.Body = "automatically generated email`n`nerror description (optional):`n`n"
Write-Host "Message text created here"

$email.Attachments.add("$filename")
Write-Host "Appendix created here"

$email.Display()
Write-Host "Email displayed here"

#$email.Send()
#Write-Host "Send email here"

Remove-Item $7zip -Force
#endregion