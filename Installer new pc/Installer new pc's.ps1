#functions voor script
function softwarecheck
                {
                softwarecheck-drivers
                if ( "losse" -eq $Status )
                    {
                    #functie is voor losse dat onder de juiste gebruiker kan uitvoeren
                    $Status = Read-Host "Als welke gebruiker uitvoeren? User - Stage - Admin"
                    softwarecheck
                    }  
                elseif ( "admin" -ne $Status ) #skip als admin instal draait
                    {
                    softwarecheck-teams
                    }          
                }

function softwarecheck-drivers
                {
                    $typepc = Read-Host "DELL of HP? Type DELL, HP of X voor geen driver"  
                        if ($typepc -eq 'hp')
                        {
                            softwarecheck-drivers-hp
                        }
                        elseif ($typepc -eq 'dell')
                        {
                            softwarecheck-drivers-dell
                        }
                        elseif ($typepc -eq 'x')
                        {
                            softwarecheck-drivers-x
                        }
                }

function softwarecheck-drivers-hp                   
                {
                cls 
                # Installatie HP Support assistant 
                write-host "Voert HP Support assistant uit"  -ForegroundColor Green
                Start-Process "\\network\hp.exe" -Wait
                }

function softwarecheck-drivers-dell                   
                {
                cls                          
                #plaats hier de file locatie van Dell Command 
                $dellversie1 = “C:\Program Files (x86)\Dell\CommandUpdate”
                $dellversie2 = “C:\Program Files\WindowsApps\DellInc.DellCommandUpdate_3.1.115.0_x64__htrsf667h5kn2\Main”
                $dellversie3 = “C:\Program Files\WindowsApps\DellInc.DellCommandUpdate_4.0.33.0_x86__htrsf667h5kn2”
                         
                $Dell = ( (test-path -path $dellversie1) -or (test-path -Path $dellversie2) -or (test-path -Path $dellversie3) )
                if ( "True" -eq $Dell )
                {
                    write-host "Dell Geinstalleerd"  -ForegroundColor Green      
                }                                 
                elseif ( "False" -eq $Dell )
                    {
                    write-host "Geen Dell support"  -ForegroundColor Red
                    write-host "Voert dell command update uit" -ForegroundColor Green
                    #Installatie dell
                    Start-Process "\\network\dell.exe" -Wait                      
                    }
                }

function softwarecheck-drivers-x
                {
                write-host "GEEN Driver pakket" -ForegroundColor Green
                }

function softwarecheck-teams
                   {
                   $Teams = Test-Path ("C:\Users\" + $env:UserName + "\AppData\Local\Microsoft\Teams")       
                         if ( "True" -eq $Teams )
                         {
                         write-host "Teams Geinstalleerd"  -ForegroundColor Green         
                         }
                         elseif ( "False" -eq $Teams )
                         {
                         write-host "Geen Teams"  -ForegroundColor Red       
                         Start-Process "\\network\teams.exe" -Wait                        
                         }
                   }                                      


                   
function apps-onnodig
                   {            
                   #Delete onnodige apps
                   write-host "Delete onnodige apps van Windows"  -ForegroundColor Green
                   powershell.exe -Command 'Get-AppxPackage "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxPackage'
                   powershell.exe -Command 'Get-AppxPackage "Microsoft.MixedReality.Portal" | Remove-AppxPackage'
                   powershell.exe -Command 'Get-AppxPackage "Microsoft.Xbox.TCUI" | Remove-AppxPackage'
                   powershell.exe -Command 'Get-AppxPackage "Microsoft.XboxGameOverlay" | Remove-AppxPackage' 
                   powershell.exe -Command 'Get-AppxPackage "Microsoft.XboxSpeechToTextOverlay" | Remove-AppxPackage'
                   powershell.exe -Command 'Get-AppxPackage "Microsoft.BingFinance" | Remove-AppxPackage'
                   powershell.exe -Command 'Get-AppxPackage "Microsoft.BingNews" | Remove-AppxPackage'
                   powershell.exe -Command 'Get-AppxPackage "Microsoft.BingSports" | Remove-AppxPackage' 
                   powershell.exe -Command 'Get-AppxPackage "Microsoft.BingWeather" | Remove-AppxPackage' 
                   powershell.exe -Command 'Get-AppxPackage "Microsoft.XboxApp" | Remove-AppxPackage' 
                   }

function bing-disable 
                   {                   
                   # Disable Bing Search in Start Menu
                   # Write-Host "Disabling Bing Search in Start Menu..."
		           Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0
                   }

function printers
                   {
                   #printers
                   write-host "Installatie printer"  -ForegroundColor Green
                   Start-Process Powershell.exe "Add-Printer -ConnectionName \\network\printername" -windowstyle hidden -Wait   
                   write-host "Installatie printer 2"  -ForegroundColor Green
                   Start-Process Powershell.exe "Add-Printer -ConnectionName \\network\printername2" -windowstyle hidden -Wait 
                   }

function win-activate-switch
                   {
                   if ( ("user" -eq $Status) -or ("stage" -eq $Status))
                           {
                           #win activatie user
                           write-host "Windows activatie"  -ForegroundColor Green
                           Start-Process -Wait -FilePath cmd.exe -Verb RunAs -ArgumentList '/k del "C:\Users\Public\Desktop\Microsoft Edge.lnk" && echo edge snelkoppeling verwijderd && echo set kms server && cscript slmgr.vbs -skms servername:port && echo set windows key && cscript slmgr.vbs -ipk xxxxx-xxxxx-xxxxx-xxxxx-xxxxx && echo activeer key && cscript slmgr.vbs -ato &&  reg import "\\network\numloc.reg" && exit' 
                           }
                   elseif ( "admin" -eq $Status )
                           {
                           #winactivatie admin
                           write-host "Windows activatie"  -ForegroundColor Green
                           Start-Process -Wait -FilePath cmd.exe -Verb RunAs -ArgumentList '/k del "C:\Users\Public\Desktop\Microsoft Edge.lnk" && echo edge snelkoppeling verwijderd && echo set kms server && slmgr.vbs -skms servername:port && echo set windows key && slmgr.vbs -ipk xxxxx-xxxxx-xxxxx-xxxxx-xxxxx && echo activeer key && slmgr.vbs -ato &&  reg import "\\network\pinnedtaskbar.reg" &&  reg import "\\network\numloc.reg" && exit' 
                           }
                   elseif ( "losse" -eq $Status )
                           {
                           #functie is voor losse dat onder de juiste gebruiker kan uitvoeren
                           $Status = Read-Host "Win activate als welke gebruiker? User of Stage of Admin"
                           win-activate-switch
                           }
                   }

function start-app
                   {
                   #applicatie start
                   write-host "Start outlook"  -ForegroundColor Green
                   Start-Process "C:\Program Files (x86)\Microsoft Office\Office15\outlook.exe" -Wait 
                   write-host "Start word"  -ForegroundColor Green
                   Start-Process "C:\Program Files (x86)\Microsoft Office\Office15\WINWORD.EXE" -Wait 
                   }
  

function standaard-app
                   {
                   #melding wat nog moet dat script nog niet kan    
                   write-host "Set standaard Browser chrome"  -ForegroundColor Red
                   write-host "Set standaard Mail Outlook"  -ForegroundColor Red
                   start ms-settings:defaultapps 
                   }

function achtergrond
                   {
                   #achtergrond         
                   $Background = Read-Host "achtergrond Type: Licht, Donker of X voor geen achtergrond"     
                         if ($Background -eq 'licht')       
                         {
                         #set desktop licht
                         write-host "Set desktop achtergrond Licht"  -ForegroundColor Green
                         set-itemproperty -path "HKCU:Control Panel\Desktop" -name WallPaper -value "\\network\Achtergrond licht.png"  
                         }                
                         elseif ($Background -eq 'donker')
                         {
                         #set desktop donker
                         write-host "Set desktop achtergrond Donker"  -ForegroundColor Green
                         set-itemproperty -path "HKCU:Control Panel\Desktop" -name WallPaper -value "\\networkAchtergrond donker.png"      
                         }                   
                         elseif ($Background -eq 'x')
                         {
                         write-host "GEEN achtergrond" -ForegroundColor Green
                         }
                   }

function taskbar
                   {
                   #taskbar edit
                   Write-host "Taskbar Standaard"  -ForegroundColor Green
                   Copy-Item "\\network\Outlook 2013.lnk" -Destination ("C:\Users\" + $env:UserName + "\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar")
                   Copy-Item "\\networkGoogle Chrome.lnk" -Destination ("C:\Users\" + $env:UserName + "\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar")
                   start "\\network\pinnedtaskbar.reg" -wait
                   }

function taskbar-admin
                   {
                   #taskbar edit
                   Write-host "Taskbar Standaard"  -ForegroundColor Green
                   Copy-Item "\\networkOutlook 2013.lnk" -Destination ("C:\Users\" + $env:UserName + "\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar")
                   Copy-Item "\\networkGoogle Chrome.lnk" -Destination ("C:\Users\" + $env:UserName + "\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar")
                   }

function recent
                   {
                   #remove recente bestanden
                   write-host "Remove recente bestanden"  -ForegroundColor Green
                   Remove-Item  ("C:\Users\" + $env:UserName + "\AppData\Roaming\Microsoft\Windows\Recent\*.*")
                   Remove-Item  ("C:\Users\" + $env:UserName + "\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations\*.*")
                   }


function gpupdate
                   {
                   #Gpupdate /force cmd
                   Write-host "Gpupdate /force"  -ForegroundColor Green
                   Start-Process -Wait -FilePath cmd.exe -ArgumentList '/k echo n | gpupdate /force && exit'
                   }

function restart-pc
                   {
                   #Restart
                   Start-Process -FilePath cmd.exe -ArgumentList '/k shutdown /r && exit'
                   }

function exitscript
                   {
                   #Exit script
                   Set-Variable -Name "input" -Value "q"
                   }

function exitps
                   {
                   #Close powershell
                   exit
                   }


function fun
                  {
				  #stagers fun
                  start "https://youtu.be/ub82Xb1C8os”
                  }

function losse-functie
                   {
                   dir function: | where {(-Not $_.Source) -AND ($_.HelpFile -notmatch "System\.Management")}
                   #filters out most system function
                   write-host "Deze functions zijn build in" -ForegroundColor red
                   write-host "Filter more" -ForegroundColor green
                   write-host "Function psEdit"  -ForegroundColor green
                   $lossefunctie = Read-Host "Type hier je losse functie"
                   Write-Host "Starting function... $lossefunctie"  -ForegroundColor Gray
                   Invoke-Expression $lossefunctie 
                   }


                   


#script
function Show-Menu
{
     param (
           [string]$Title = 'Installer new pc'
     )
     cls
     Write-Host "================ $Title ================"  -ForegroundColor Gray
     Write-Host "===INSTALATIE TYPE===" -ForegroundColor Gray
     Write-Host "Type 'USER' voor User INSTALL" -ForegroundColor green
     Write-Host "Type 'ADMIN' voor Admin INSTALL" -ForegroundColor green
     Write-Host "Type 'STAGE' voor stageres INSTALL" -ForegroundColor green
     #Write-Host "Type 'RESTART'  for RESTART PC."
     #Write-Host "Type 'SHUTDOWN' for SHUTDOWN PC."
     Write-Host "===LOSSE FUNCTIES===" -ForegroundColor Gray
     Write-Host "Type 'GPUPDATE' voor policie bijwerken." -ForegroundColor green
     Write-Host "===AFSLUITEN===" -ForegroundColor Gray
     Write-Host "Type 'Q' voor Afsluiten" -ForegroundColor green
}

do
{
     Show-Menu
     $input = Read-Host "Je keuze graag" 
     switch ($input)
       {
             'user' 
             {
                   cls
                   $Status = "user"
                   softwarecheck 
                   apps-onnodig
                   bing-disable
                   printers
                   win-activate-switch
                   start-app
                   standaard-app
                   achtergrond
                   taskbar
                   recent                 
                   gpupdate                                    
                   restart-pc
                   exitscript
                   exitps

             }
                        
             'stage'
             {     
                   cls
                   $Status = "stage"   
                   softwarecheck 
                   apps-onnodig
                   bing-disable
                   fun
                   printers
                   win-activate-switch
                   start-app
                   standaard-app
                   achtergrond
                   taskbar
                   recent                
                   gpupdate                                    
                   restart-pc
                   exitscript
                   exitps
             }
                    
             'admin' 
             {
                   cls 
                   $Status = "admin" 
                   softwarecheck
                   bing-disable 
                   win-activate-switch
                   taskbar-admin
                   gpupdate              
                   restart-pc 
                   exitscript
                   exitps
             }
              
             #'RESTART' 
             #{
             #cls
             #Restart-Computer -ComputerName localhost
             #restart-pc 
             #}
            
             #'SHUTDOWN' 
             #{
             #cls
             #Stop-Computer -ComputerName localhost 
             #}
             
             'gpupdate' 
             {
                   cls 
                   gpupdate
                   restart-pc
                   exitscript
                   exitps
             }
             
             'losse' 
             {
                   cls 
                   $Status = "losse"
                   losse-functie
                   exitscript
             }
                                                 
             'q' 
             {
             return
             }

       }
       pause
 }
until ($input -eq 'q')

#maker script kartondoos 2019-2021