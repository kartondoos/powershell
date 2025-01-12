#Load assemblies
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

#region Create GUI
[xml]$XAML = @"
<Window x:Class="UMB.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:system="clr-namespace:UMB;assembly=mscorlib"
        mc:Ignorable="d"
		Topmost="true"
        Title="MainWindow" x:Name="WindowTitle" SizeToContent="WidthAndHeight" WindowStartupLocation="CenterScreen" WindowState="Normal">
    <Grid Background="#FFE5E5E5" HorizontalAlignment="Stretch" >
        <TextBlock x:Name="Label1" Text="Label1" TextAlignment="Left" TextWrapping="Wrap" HorizontalAlignment="Stretch" Margin="5,5,5,45" VerticalAlignment="Stretch" FontSize="14"/>
        <Button x:Name="btnOK" Margin="-150,0,0,10" Content="OK" HorizontalAlignment="Center" VerticalAlignment="Bottom" FontWeight="Normal" FontSize="14" Height="25" Width="80">
            <Button.Effect>
                <DropShadowEffect/>
            </Button.Effect>
        </Button>
        <Button x:Name="btnCancel" Margin="150,0,0,10" Content="Cancel" HorizontalAlignment="Center" VerticalAlignment="Bottom" FontWeight="Normal" FontSize="14" Height="25" Width="80">
            <Button.Effect>
                <DropShadowEffect/>
            </Button.Effect>
        </Button>
    </Grid>
</Window>
"@ -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*','<Window'


#Process XAML code
try { $Window = [Windows.Markup.XamlReader]::Load( (New-Object System.Xml.XmlNodeReader $xaml) ) }
catch { Write-Host "Windows.Markup.XamlReader could not be loaded. Possible cause: invalid syntax or missing .net"; break}

#Connect to Controls 
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object {New-Variable -Name $_.Name -Value $Window.FindName($_.Name) -Force}
#endregion



$IconBase64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAc0QKQHNECp9zRArf
c0QK/3NECv9zRArfc0QKn3NECkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABzRAoQc0QKr3hGCf+dVwX/tmIC/8ZoAP/FZwD/tmAC/5xVBf94Rgn/c0QKr3NE
ChAAAAAAAAAAAAAAAABzRAoQc0QKz45QB//CaAH/x2kA/8ZpAP/GaAD/xmgA/8VnAP/FZwD/v2QB/4xPB/9zRArPc0QKEAAAAAAAAAAAc0QKr45QB//IawD/
yGsA/8dqAP/HaQD////////////GaAD/xWcA/8VnAP/EZgD/jE8H/3NECq8AAAAAc0QKQHhHCf/EagH/yGwA/8hrAP/IawD/x2oA////////////xmgA/8Zo
AP/FZwD/xWcA/79kAf94Rgn/c0QKQHNECp+eWQX/yW0A/8lsAP/IbAD/yGsA/8hrAP///////////8ZpAP/GaAD/xmgA/8VnAP/FZwD/nFUF/3NECp9zRArf
umYC/8ptAP/JbQD/yWwA/8hsAP/IawD////////////HaQD/xmkA/8ZoAP/GaAD/xWcA/7ZgAv9zRArfc0QK/8pvAP/KbgD/ym0A/8ltAP/JbAD/yGwA////
////////x2oA/8dpAP/GaQD/xmgA/8ZoAP/FZwD/c0QK/3NECv/LbwD/ym8A/8puAP/KbQD/yW0A/8lsAP///////////8hrAP/HagD/x2kA/8ZpAP/GaAD/
xmgA/3NECv9zRArfu2gC/8tvAP/KbwD/ym4A/8ptAP/JbQD////////////IawD/yGsA/8dqAP/HaQD/xmkA/7ZiAv9zRArfc0QKn59aBf/LcAD/y28A/8pv
AP/KbgD/ym0A/8ltAP/JbAD/yGwA/8hrAP/IawD/x2oA/8dpAP+dVwX/c0QKn3NECkB5Rwn/xm0B/8twAP/LbwD/ym8A/8puAP///////////8lsAP/IbAD/
yGsA/8hrAP/CaAH/eEYJ/3NECkAAAAAAc0QKr49SB//McAD/y3AA/8tvAP/KbwD////////////JbQD/yWwA/8hsAP/IawD/jlAH/3NECq8AAAAAAAAAAHNE
ChBzRArPj1IH/8ZtAf/LcAD/y28A/8pvAP/KbgD/ym0A/8ltAP/EagH/jlAH/3NECs9zRAoQAAAAAAAAAAAAAAAAc0QKEHNECq95Rwn/n1oF/7toAv/LbwD/
ym8A/7pmAv+eWQX/eEcJ/3NECq9zRAoQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAc0QKQHNECp9zRArfc0QK/3NECv9zRArfc0QKn3NECkAAAAAAAAAAAAAA
AAAAAAAA8A8A/8ADAP+AAQT/gAEKrwAACmAAAAj/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/gAEA/4ABAP/AAwD/8A8A/w=='

$WindowTitle.Icon = [convert]::FromBase64String($IconBase64)
$WindowTitle.ResizeMode = "NoResize"
$WindowTitle.Title = "test titel"
$Label1.Text = "test text"

#region buttons
($btnOK, $btnCancel) | ForEach-Object{$_.Add_MouseEnter({ $Window.Cursor=[System.Windows.Input.Cursors]::Hand })}
($btnOK, $btnCancel) | ForEach-Object{$_.Add_MouseLeave({ $Window.Cursor=[System.Windows.Input.Cursors]::Arrow })}

$btnCancel.Add_Click({
    Write-Host "Clicked Cancel button "
    $Window.Close()
})

$btnOK.Add_Click({
    Write-Host "Clicked OK button "
    $Window.Close()
})

$null = $Window.ShowDialog()
#endregion 