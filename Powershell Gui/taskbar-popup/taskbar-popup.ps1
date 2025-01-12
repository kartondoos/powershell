Add-Type -AssemblyName PresentationFramework,System.Drawing,System.Windows.Forms

#region XAML
[xml]$XAML ='
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Name="window" WindowStyle="None" Height="200" Width="400"
    ResizeMode="NoResize" ShowInTaskbar="False">
    <Window.Resources>
        <Style TargetType="GridViewColumnHeader">
            <Setter Property="Background" Value="Transparent" />
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderBrush" Value="Transparent"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="GridViewColumnHeader">
                        <Border Background="#313130">
                            <ContentPresenter>
                            </ContentPresenter>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
    <Grid Name="grid" Background="#313130" Height="200" Width="400">
        <Label Name="label" Content="Current Disk Usage" Foreground="White" FontSize="18" Margin="10,10,0,15"/>
        <ListView Name="listview" SelectionMode="Single" Margin="0,50,0,0" Foreground="White" Background="Transparent" BorderBrush="Transparent" IsHitTestVisible="False">
            <ListView.ItemContainerStyle>
                <Style>
                    <Setter Property="ItemsControl.HorizontalContentAlignment" Value="Stretch"/>
                    <Setter Property="ItemsControl.VerticalContentAlignment" Value="Stretch"/>
                </Style>
            </ListView.ItemContainerStyle>
        </ListView>
    </Grid>
</Window>
'

$reader=(New-Object System.Xml.XmlNodeReader $XAML)
$window=[Windows.Markup.XamlReader]::Load($reader)
$XAML.SelectNodes("//*[@Name]") | %{Set-Variable -Name ($_.Name) -Value $window.FindName($_.Name)}

#endregion

#region Getdiskinfo
$localdisks = Get-WmiObject Win32_Volume -Filter "DriveType='3'"
$itemsource = @()
foreach ($disk in ($localdisks| Sort-Object -Property Name)) {
    if (!$disk.name.StartsWith(“\\”)) {
        $itemsource += [PSCustomObject]@{
            Name = $disk.Name
            Label = $disk.Label
            Total = “$([Math]::Round($disk.Capacity /1GB,1)) GB”
            Free = “$([Math]::Round($disk.FreeSpace /1GB,1)) GB”
        }
    }
}
$columnorder = 'Name', 'Label', 'Total', 'Free'
#endregion

$listview.ItemsSource = $itemsource
$listview.Width = $grid.width*.9

$gridview = New-Object System.Windows.Controls.GridView
foreach ($column in $columnorder) {
    $gridcolumn = New-Object System.Windows.Controls.GridViewColumn
    $gridcolumn.Header = $column
    $gridcolumn.Width = $grid.width*.20
    $gridbinding = New-Object System.Windows.Data.Binding $column
    $gridcolumn.DisplayMemberBinding = $gridbinding
    $gridview.AddChild($gridcolumn)
}

$listview.view = $gridview


$icon = [System.Drawing.Icon]::ExtractAssociatedIcon(“$pshome\powershell.exe”)

$notifyicon = New-Object System.Windows.Forms.NotifyIcon
$notifyicon.Text = “Disk Usage”
$notifyicon.Icon = $icon
$notifyicon.Visible = $true
$menuitem = New-Object System.Windows.Forms.MenuItem
$menuitem.Text = “Exit”

$contextmenu = New-Object System.Windows.Forms.ContextMenu
$notifyicon.ContextMenu = $contextmenu
$notifyicon.contextMenu.MenuItems.AddRange($menuitem)

#region functions
$notifyicon | Get-Member -MemberType Event
# Close the pop-up window if it’s double clicked

$window.Add_MouseDoubleClick({
    $window.Hide()
})

# Close the pop-up window if any other window is clicked

$window.Add_Deactivated({
    $window.Hide()
})

# When Exit is clicked, close everything and kill the PowerShell process
$menuitem.add_Click({
    $notifyicon.Visible = $false
    $window.Close()
    Stop-Process $pid
})

# Show window when the notifyicon is clicked with the left mouse button
# Recall that the right mouse button brings up the contextmenu
$notifyicon.add_Click({
    if ($_.Button -eq [Windows.Forms.MouseButtons]::Left) {
        # reposition each time, in case the resolution changes
        $window.Left = $([System.Windows.SystemParameters]::WorkArea.Width-$window.Width)
        $window.Top = $([System.Windows.SystemParameters]::WorkArea.Height-$window.Height)
        $window.Show()
        $window.Activate()
    }
})
#endregion

$windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)

[System.GC]::Collect()
$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)

#$window.ShowDialog()