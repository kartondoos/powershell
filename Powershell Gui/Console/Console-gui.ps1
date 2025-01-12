function Show-Menu
{
     param (
           [string]$Title = 'Titel of this gui'
     )
     cls
     Write-Host "================ $Title ================"  -ForegroundColor Gray
     Write-Host "===Installer TYPE===" -ForegroundColor Gray
     Write-Host "Press '1' for User INSTALL" -ForegroundColor green
     Write-Host "Press '2' for Admin INSTALL" -ForegroundColor green
     Write-Host "Press '3' for HR INSTALL" -ForegroundColor green
     Write-Host "===AFSLUITEN===" -ForegroundColor Gray
     Write-Host "Press 'Q' to quit" -ForegroundColor green
}

do {
    Show-Menu
    $input = Read-Host "Please make a choice" 
    switch ($input) {
        '1' {
            Write-Host "Pressed $($input), User INSTALL" -ForegroundColor Green
            return
        }
        '2' {
            Write-Host "Pressed $($input), Admin INSTALL" -ForegroundColor Green
            return
        }
        '3' { 
            Write-Host "Pressed $($input), HR INSTALL" -ForegroundColor Green
            return
        }
              
        'q' {
            Write-Host "Pressed $($input), quit" -ForegroundColor Gray
            return
        }
    }
Write-Host "Pressed $($input), no vallid input" -ForegroundColor Red
Pause
}
until ($input -eq 'q')