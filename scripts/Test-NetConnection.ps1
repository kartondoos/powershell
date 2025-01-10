function Get-ConnectionTest {
    param(
		[Parameter(Mandatory)]
		$connections,
		
		[Parameter(Mandatory)]
		[int]$port
	)

    Write-Host -ForegroundColor Gray "Performing tests on port $($port) :"

    ForEach ($connection in $connections) {
        $result = (Test-NetConnection -Port $port -ComputerName $connection.uri)    
        switch ($result.TcpTestSucceeded) {
            "True" { $color = "Green" }
            "False" { $color = "Red" }
        }
        Write-Host -NoNewline "  $($connection.area): $($result.ComputerName) ($($result.RemoteAddress)): "
        Write-Host -ForegroundColor $color $result.TcpTestSucceeded
    }
    Write-Host ""
}
$connections443 = @(
    [pscustomobject]@{uri='login.microsoftonline.com';Area='Microsoft authentication'},
    [pscustomobject]@{uri='aadcdn.msauth.net';Area='Microsoft authentication'}     
)

$connections80 = @(
    [pscustomobject]@{uri='emdl.ws.microsoft.com';Area='Windows Update'},
    [pscustomobject]@{uri='dl.delivery.mp.microsoft.com';Area='Windows Update'}
)

Get-ConnectionTest -connections $connections443 -port 443
Get-ConnectionTest -connections $connections80 -port 80