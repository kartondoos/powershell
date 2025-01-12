Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

function Show-BalloonTip  
{
   param
  (
    [Parameter(Mandatory)]
    [String]$Message,
   
    [Parameter(Mandatory)]
    [String]$Title,
   
    [ValidateSet('None', 'Info', 'Warning', 'Error')]
    [string]$Icon = 'Info',

    [int]$Timeout = 10000
  )
 

  if ($script:balloon -eq $null)
  {
    $script:balloon = New-Object -TypeName System.Windows.Forms.NotifyIcon
  }

  $path                    = Get-Process -id $pid | Select-Object -ExpandProperty Path
  $balloon.Icon            = [Drawing.Icon]::ExtractAssociatedIcon($path)
  $balloon.BalloonTipIcon  = $Icon
  $balloon.BalloonTipText  = $Message
  $balloon.BalloonTipTitle = $Title
  $balloon.Visible         = $true
  $Timeout
  $balloon.ShowBalloonTip($Timeout)
} 

Show-BalloonTip -Title "test titel" -Message "test mesage" -Icon Warning -Timeout 2