#https://www.jesusninoc.com/02/04/ejercicios-de-powershell-intentar-saltar-la-uac-simulacion/
#opens start menu - starts chrome - go to webpage

[System.Windows.Forms.SendKeys]::SendWait("^({ESC})")
Start-Sleep -Seconds 2

[System.Windows.Forms.SendKeys]::SendWait("chrome.exe")
Start-Sleep -Seconds 2

[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
Start-Sleep -Seconds 2

[System.Windows.Forms.SendKeys]::SendWait("https://github.com/kartondoos/powershell")
Start-Sleep -Seconds 2

[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
Start-Sleep -Seconds 5