# Powershell usefull scripts

Commands in powershell like set Bios password, get IP info, wmi/cim 
### custom item in quick menu (admin)
```ps1
New-Item -Path "Registry::HKEY_CLASSES_ROOT\*\shell\CUSTOM\command" -Name "" -Value "NOTEPAD.EXE" -Type "String" -Force
```
### New-Object
Minimize all apps
```ps1
$shell = New-Object -ComObject "Shell.Application"
$shell.MinimizeAll()
sleep -Seconds 5
$shell.undominimizeall()
```
Read a file
```ps1
$FileObj = New-Object System.IO.StreamReader -Arg "C:\Users\Installers.txt"
$FileObj.ReadToEnd()
$FileObj.Close()
```
make shortcut (.url) no custom icon
```ps1
$objwscript = New-Object -comObject WScript.Shell
$location = $env:USERPROFILE + "\Desktop\kartondoos.url"
$shortcut = $objwscript.CreateShortcut($location)
$shortcut.TargetPath = "http://github.com/kartondoos"
$hortcut.Save()
```
make shortcut (.lnk) custom icon possible but has to be .ico
```ps1
$Shell = New-Object -ComObject ("WScript.Shell")
$ShortCut = $Shell.CreateShortcut($env:USERPROFILE + "\Desktop\kartondoos.lnk")
#$ShortCut.TargetPath="yourexecutable.exe"
#$ShortCut.Arguments="-arguementsifrequired"
#$ShortCut.WorkingDirectory = "c:\your\executable\folder\path";
#$ShortCut.WindowStyle = 1;
#$ShortCut.Hotkey = "CTRL+SHIFT+F";
$ShortCut.IconLocation = "C:\Documents\img\Yourlogo.ico";
$ShortCut.Description = "link to kartondoos";
$ShortCut.Save()
```
open eigenschappen van bestand
```ps1
$objshell = new-object -com Shell.Application
$folder = $objshell.NameSpace("C:\Windows\system32\")
$file = $folder.ParseName("cmd.exe")
$file.InvokeVerb("Properties")
```







