cls
#self elevating admin promt
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$numlock = Get-ItemPropertyValue -Path 'Registry::HKU\.DEFAULT\Control Panel\Keyboard' -Name InitialKeyboardIndicators

if ($numlock -eq '0') {
    $numlock = "off"
} elseif ($numlock -eq '2') {
    $numlock = "on"
} else {
    $numlock = "Unknown"
}

$switch = Read-Host "Numlock is" $numlock "at startup (on or off)" 
    if ($switch -eq 'off') {
        Set-ItemProperty -Path 'Registry::HKU\.DEFAULT\Control Panel\Keyboard' -Name "InitialKeyboardIndicators" -Value "0"
        write-host "set to numlock off at startup"  -ForegroundColor green
    }
    elseif ($switch -eq 'on') {
        Set-ItemProperty -Path 'Registry::HKU\.DEFAULT\Control Panel\Keyboard' -Name "InitialKeyboardIndicators" -Value "2"
        write-host "set to numlock on at startup"  -ForegroundColor green
    }