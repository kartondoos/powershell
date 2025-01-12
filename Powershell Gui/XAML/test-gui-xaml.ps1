#region XAML
#Form Start

Add-Type -AssemblyName PresentationFramework, System.Drawing, System.Windows.Forms, WindowsFormsIntegration

[xml]$XAML= @'

<Window x:Class="Test_app.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:Test_app"
        mc:Ignorable="d"
        Title="DEKRA Test app" Height="450" Width="800">
    <Grid>
        <Button x:Name="button_1" Content="btn1" HorizontalAlignment="Left" Margin="102,59,0,0" VerticalAlignment="Top"/>
        <Button x:Name="button_2" Content="btn2" HorizontalAlignment="Left" Margin="207,59,0,0" VerticalAlignment="Top"/>
        <Button x:Name="button_3" Content="btn3" HorizontalAlignment="Left" Margin="102,150,0,0" VerticalAlignment="Top"/>
        <Button x:Name="button_4" Content="btn4" HorizontalAlignment="Left" Margin="207,150,0,0" VerticalAlignment="Top"/>
        <Button x:Name="button_exit" Content="Exit" HorizontalAlignment="Left" Margin="635,242,0,0" VerticalAlignment="Top"/>

    </Grid>
</Window>

'@ -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window' -replace 'x:Class="\S+"',''

#Read XAML
$reader=(New-Object System.Xml.XmlNodeReader $XAML)
$Form=[Windows.Markup.XamlReader]::Load($reader)
$XAML.SelectNodes("//*[@Name]") | %{Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}

#endregion

#region XAML Controlls

$button_1.Add_Click({
    Write-Host "button 1"
})

$button_2.Add_Click({
    Write-Host "button 2"
})

$button_3.Add_Click({
    Write-Host "button 3"
})

$button_4.Add_Click({
    Write-Host "button 4"
})

$button_exit.Add_Click({
    Write-Host "exit"
    $Form.Close()
})

#endregion

$Form.ShowDialog()
