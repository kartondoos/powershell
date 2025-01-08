# Powershell usefull commands

Commands in powershell like set Bios password, get IP info, wmi/cim 

# Commands
Get info about the a process
```ps1
Get-Process -Name "explorer" 
```
run a process
```ps1
Start-Process "C:\Program Files (x86)\Microsoft Office\Office15\WINWORD.EXE" -Wait 
```
Get info about the a services
```ps1
Get-Service -Name:'WinDefend'
```                        
set kms server
```ps1
slmgr.vbs -skms servername:port
```
set windows key
```ps1
slmgr.vbs -ipk xxxxx-xxxxx-xxxxx-xxxxx-xxxxx 
```
activate (KMS) Volume License Key
```ps1
slmgr.vbs -ato 
```
Get contents of a file
```ps1
Get-Content -Path "<path>.txt"
```
Copy item from src /dst
```ps1
Copy-Item "\\src\1" -Destination "C:\dst\2"
```
Remove item
```ps1
Remove-Item  ("C:\Users\" + $env:UserName + "\AppData\Roaming\Microsoft\Windows\Recent\*.*")
```
list custom made functions in script
```ps1
dir function: | where {(-Not $_.Source) -AND ($_.HelpFile -notmatch "System\.Management") -and ($_.Name -ne "more" -and $_.Name -ne "psEdit")}
```
Add printer 
```ps1
Add-Printer -ConnectionName \\network\printername
```
Write a text to the console with colors
```ps1
write-host "test" -ForegroundColor white  -BackgroundColor black
```
Get info of command
```ps1
Get-Command Get-Process -Syntax
```
Get fullPath of current process 
```ps1
[System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
```
When running a script some variables could be used
```ps1
$myInvocation.MyCommand.Name
$myInvocation.MyCommand.Path
$PSCommandPath
```
ADSI/LDAP search
```ps1
([adsisearcher]"(&(objectclass=computer)(name=$($env:COMPUTERNAME)))").findall()
([adsisearcher]"(&(objectclass=group)(samaccountname=$($adgroup)))").findall()
```
transcript
```ps1
Start-Transcript -Path .\test.txt
Get-Process -Name "explorer"
Write-Host "This is test"
Stop-Transcript
Uninstall Modern Windows Apps - MSIX
'''
```ps1
Get-AppxPackage -AllUsers -Name "*MSTeams*" | Remove-AppxPackage -AllUsers
```
Combine data to one
```ps1
[System.IO.Path]::Combine($env:APPDATA,'Microsoft','Teams','Update.exe') + ' --uninstall -s'
```
Get all user profiles and their SIDs
```ps1
$userProfiles = Get-WmiObject Win32_UserProfile | Where-Object { $_.Special -eq $false } | Select-Object LocalPath, SID
```
unpack .cab
```ps1
expand.exe -F:* "<Filelocation>\***.cab" "<Filelocation>\cabextract" -Recurse
```
Unpack .zip
```ps1
Expand-Archive -Path "<Filelocation>\***.zip" -DestinationPath "$($env:TEMP)\zipextract\"
```
Set attribute hidden and system
```ps1
Set-ItemProperty -Path "C:\test.txt" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden + [System.IO.FileAttributes]::System)
```
Import the CSV
```ps1
$CSVData = Import-CSV -Path $ExportPath 
```
Display the data in Grid View from Pipeline input
```ps1
$CSVData | Out-Gridview
```
get ip info
```ps1
Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"}
```
Set Display name of program
```ps1
$Host.UI.RawUI.WindowTitle = "kartondoos"
```
Get-date in format
```ps1
(Get-Date -f yyyy-MM-dd_HH-mm-ss)
```
Get info of computer
```ps1
get-computerinfo
```
Get info of TPM
```ps1
get-tpm
```
Show the running tasks
```ps1
tasklist
```
Get windows version
```ps1
[environment]::OSVersion 
```
Remove bios PW of DELL computer
```ps1
Set-Item DellSmbios:\Security\AdminPassword -value "Newpassword" -password oldpassword
```
Test if user is in the admin group (also list user info)
```ps1
$curUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$admGroup = [System.Security.Principal.WindowsBuiltInRole]::Administrator
$Principal = New-Object System.Security.Principal.WindowsPrincipal($curUser)
$Principal.IsInRole($admGroup) 
```
Get UI Culture
```ps1
$ActiveLanguage = (Get-UICulture).Name.Split('-')[0]
```
Set ErrorAction global
```ps1
$ProgressPreference = "SilentlyContinue"
```
set a proxy
```ps1
[System.Net.WebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy <Severname>:<port>
```
set/edit current background 
```ps1
mspaint.exe C:\Users\$($env:USERNAME)\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper
```
set background by registry
```ps1
set-itemproperty -path "HKCU:Control Panel\Desktop" -name WallPaper -value "\\network\Achtergrond licht.png" 
```
azure join info
```ps1
dsregcmd.exe /status
```
put data in clipboard
```ps1
Set-Clipboard "test to send to clipboard"
```
GUI ID Generation 
```ps1
[System.Guid]::NewGuid()
```
Get windows version (admin)
```ps1
((Get-WindowsEdition -Online).Edition)
```
Forces system to refresh
```ps1
RUNDLL32.EXE USER32.DLL, UpdatePerUserSystemParameters 1, True
```
Reslove DNS
```ps1
Resolve-DnsName dcaes.local
```
test server/ip on port
```ps1
Test-NetConnection 10.11.18.10 -Port 53
```
# shortcut
start settings
```ps1
start ms-settings:personalization-colors
```
start settings
```ps1
start ms-settings:defaultapps
```
start windows defender 
```ps1
start windowsdefender://RansomwareProtection
```
start store
```ps1
start ms-windows-store://pdp/?ProductId=9n4wgh0z6vhq
```
# Netsh commands
detect proxy
```ps1
netsh winhttp show proxy
```
Set interface to dhcp 
```ps1
netsh interface ip set dns name="Ethernet" source=dhcp #dns via dhcp
netsh interface ip set address name="Ethernet" source=dhcp #ip via dhcp
```
Set static ip 
```ps1
netsh interface ipv4 set address name="Ethernet" source=static 192.168.1.20 255.255.255.0 192.168.1.1 #static ip  #ip/subnet/gateway
netsh interface ipv4 set dns name="Ethernet" source=static addr=8.8.8.8 #static first dns server
netsh interface ipv4 add dns name="Ethernet" 8.8.4.4 index=2 #static second dns server
```
# Server commands
## AD command
make a new ad user
```ps1
New-ADUser new.ad.user
```
make a new ad group in the root
```ps1
New-ADOrganizationalUnit -Name "UserAccounts" -Path "DC=FABRIKAM,DC=COM"
```
get info of AD user
```ps1
Get-ADUser -Identity $user -Properties * ,"msDS-UserPasswordExpiryTimeComputed"
```
get info of adcomputer
```ps1
Get-ADComputer -Identity $typepc -Properties *
```
get name of AD Domain
```ps1
([System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name).split(".")
```
## DHCP/DNS
add new a record
```ps1
Add-DnsServerResourceRecordA -Name "host23" -ZoneName "contoso.com" -AllowUpdateAny -IPv4Address "172.18.99.23" -TimeToLive 01:00:00
```
add dhcp resavation in dhcp scope
```ps1
Add-DhcpServerv4Reservation -ScopeId 10.10.10.0 -IPAddress 10.10.10.8 -ClientId "F0-DE-F1-7A-00-5E" -Description "Reservation for Printer"
```
## WmiObject /CimInstance
### Please note Wmi is older standard
### https://medium.com/@crawlerd01/windows-powershell-wmi-vs-cim-bd09a3469ea1
Get info from battery
```ps1
Get-WmiObject -Class batterystatus -Namespace root\wmi
```
Get addapter info with filter
```ps1
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -namespace "root\CIMV2" -computername "." -Filter "IPEnabled = 'True' AND DHCPEnabled ='True'" 
```
Get addapter info with where/select
```ps1
Get-WmiObject Win32_NetworkAdapterConfiguration | where { (($_.IPEnabled -ne $null) -and ($_.DefaultIPGateway -ne $null)) } | select IPAddress -First 1
```
Getbios info
```ps1
Get-WmiObject -Class Win32_BIOS
```
get installed software
```ps1
Get-WmiObject -Class Win32_Product
```
Get info of mulipe thing on the system
```ps1
Get-CimInstance win32_operatingsystem | Get-Member -MemberType Property
```
Get if pc or laptop, PCSystemType = 1 (Desktop), PCSystemType = 2 (Laptop)
```ps1
(Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType
```
# New-Object
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
