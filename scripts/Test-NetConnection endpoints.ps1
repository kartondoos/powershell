$msEndpoints = @()
(invoke-restmethod -Uri ("https://endpoints.office.com/endpoints/WorldWide?ServiceAreas=MEM`&clientrequestid=" + ([GUID]::NewGuid()).Guid)) | ?{$_.ServiceArea -eq "MEM" -and $_.urls} | select -ExpandProperty urls | ForEach-Object {
    $msEndpoints += $_
}

$msEndpoints = $msEndpoints | Where-Object {$_ -notmatch "\*." } #filter invalid urls
Write-Host -ForegroundColor blue "Check all other connections (Not all for windows enrollment necessary) (443):"

ForEach ($msEndpoint in $msEndpoints) {
    $result = (Test-NetConnection -Port 443 -ComputerName $msEndpoint)
    switch ($result.TcpTestSucceeded) {
        "True" { $color = "Green" }
        "False" { $color = "Red" }
    }
    Write-Host -NoNewline "  Other Connections: $($result.ComputerName) ($($result.RemoteAddress)): "
    Write-Host -ForegroundColor $color $result.TcpTestSucceeded
}
Write-Host