$Seconds = 30

while ($Seconds -gt 0) {
    Write-host "starting in $($Seconds), press c to cancel"
    Start-Sleep 1
    if([Console]::KeyAvailable) {
        if([Console]::ReadKey($true).Key -in 'c', 'C') {
            break
        }
    }
    $Seconds --
} #break exits the script

Write-host "Starting now $($Seconds) second left"
Read-Host "keeps the PS window open"