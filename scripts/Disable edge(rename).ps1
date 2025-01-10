$disable_edge = Read-Host "disable edge y/n"  
 
if ($disable_edge -eq 'y') {
    write-host "disable"  -ForegroundColor Green
    #rename folder (disable edge)
    Rename-Item "C:\Program Files (x86)\Microsoft\Edge" "C:\Program Files (x86)\Microsoft\Disabeld.Edge"
    Rename-Item "C:\Program Files (x86)\Microsoft\EdgeUpdate" "C:\Program Files (x86)\Microsoft\Disabeld.EdgeUpdate" 
    Rename-Item "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" "C:\Windows\SystemApps\Disabeld.Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
    Rename-Item "C:\Windows\SystemApps\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe" "C:\Windows\SystemApps\Disabeld.Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe"
}

elseif ($disable_edge -eq 'n') {
    write-host "enable"  -ForegroundColor Green
    #rename folder (enable edge)
    Rename-Item "C:\Program Files (x86)\Microsoft\Disabeld.Edge" "C:\Program Files (x86)\Microsoft\Edge"
    Rename-Item "C:\Program Files (x86)\Microsoft\Disabeld.EdgeUpdate" "C:\Program Files (x86)\Microsoft\EdgeUpdate"
    Rename-Item "C:\Windows\SystemApps\Disabeld.Microsoft.MicrosoftEdge_8wekyb3d8bbwe" "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
    Rename-Item "C:\Windows\SystemApps\Disabeld.Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe" "C:\Windows\SystemApps\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe"  
}
 