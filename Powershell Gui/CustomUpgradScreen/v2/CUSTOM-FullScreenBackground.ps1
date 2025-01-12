# Creates a full screen 'background' styled for a Windows 10 upgrade, and hides the task bar
# Called by the "Show-OSUpgradeBackground" script

switch ((get-host).Name) { 
    'Windows PowerShell ISE Host' { $files_location = $psISE.CurrentFile.FullPath -replace ($psISE.CurrentFile.DisplayName,"") }
    'ConsoleHost' { $files_location = $myInvocation.MyCommand.Path -replace ($myInvocation.MyCommand.Name,"")  }
}

Add-Type -AssemblyName System.Windows.Forms

#Param($DeviceName)

# Add required assemblies
Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase,System.Windows.Forms,System.Drawing,System.DirectoryServices.AccountManagement
Add-Type -Path "$($files_location)bin\System.Windows.Interactivity.dll"
Add-Type -Path "$($files_location)bin\ControlzEx.dll"
Add-Type -Path "$($files_location)bin\MahApps.Metro.dll"

# Find screen by DeviceName
$Screens = [System.Windows.Forms.Screen]::AllScreens
$Screen = $Screens | Where {$_.DeviceName -eq $Screens.DeviceName}

# Get the bounds of the primary screen
$script:Bounds = $Screen.Bounds



# Add custom type to hide the taskbar
# Thanks to https://stackoverflow.com/questions/25499393/make-my-wpf-application-full-screen-cover-taskbar-and-title-bar-of-window
<#####
$CSharpSource = @"
using System;
using System.Runtime.InteropServices;

public class Taskbar
{
    [DllImport("user32.dll")]
    private static extern int FindWindow(string className, string windowText);
    [DllImport("user32.dll")]
    private static extern int ShowWindow(int hwnd, int command);

    private const int SW_HIDE = 0;
    private const int SW_SHOW = 1;

    protected static int Handle
    {
        get
        {
            return FindWindow("Shell_TrayWnd", "");
        }
    }

    private Taskbar()
    {
        // hide ctor
    }

    public static void Show()
    {
        ShowWindow(Handle, SW_SHOW);
    }

    public static void Hide()
    {
        ShowWindow(Handle, SW_HIDE);
    }
}
"@
Add-Type -ReferencedAssemblies 'System', 'System.Runtime.InteropServices' -TypeDefinition $CSharpSource -Language CSharp
#####>

# Add custom type to prevent the screen from sleeping
$code=@' 
using System;
using System.Runtime.InteropServices;

public class DisplayState
{
    [DllImport("kernel32.dll", CharSet = CharSet.Auto,SetLastError = true)]
    public static extern void SetThreadExecutionState(uint esFlags);

    public static void KeepDisplayAwake()
    {
        SetThreadExecutionState(
            0x00000002 | 0x80000000);
    }

    public static void Cancel()
    {
        SetThreadExecutionState(0x80000000);
    }
}
'@
Add-Type -ReferencedAssemblies 'System', 'System.Runtime.InteropServices' -TypeDefinition $code -Language CSharp

# Load the main window XAML code
[XML]$Xaml = [System.IO.File]::ReadAllLines("$($files_location)Xaml\SplashScreen.xaml") 

# Create a synchronized hash table and add the WPF window and its named elements to it
$UI = [System.Collections.Hashtable]::Synchronized(@{})
$UI.Window = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $xaml))
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | 
    ForEach-Object -Process {
        $UI.$($_.Name) = $UI.Window.FindName($_.Name)
    }


# Set some initial values
$UI.MainTextBlock.MaxWidth = $Bounds.Width
$UI.TextBlock2.MaxWidth = $Bounds.Width
$UI.TextBlock3.MaxWidth = $Bounds.Width
$UI.TextBlock4.MaxWidth = $Bounds.Width
$UI.TextBlock2.Text = "Windows Setup Progress 0%"
$UI.TextBlock3.Text = "00:00:00"
$UI.TextBlock4.Text = "This will take a while...don't turn off your pc"
[decimal]$global:ProgressValue = 0
$i = 0
$WindowsVersion = [environment]::OSVersion.Version.Build

# Find the username
If ($env:USERNAME) {
    $GivenName = "$env:USERNAME"
} Else {
    $GivenName = "there"
}

$UI.MainTextBlock.Text = "Hi $GivenName"

# Create some animations
$FadeinAnimation = [System.Windows.Media.Animation.DoubleAnimation]::new(0,1,[System.Windows.Duration]::new([Timespan]::FromSeconds(3)))
$FadeOutAnimation = [System.Windows.Media.Animation.DoubleAnimation]::new(1,0,[System.Windows.Duration]::new([Timespan]::FromSeconds(3)))
$ColourBrighterAnimation = [System.Windows.Media.Animation.ColorAnimation]::new("#012a47","#1271b5",[System.Windows.Duration]::new([Timespan]::FromSeconds(5)))
$ColourDarkerAnimation = [System.Windows.Media.Animation.ColorAnimation]::new("#1271b5","#012a47",[System.Windows.Duration]::new([Timespan]::FromSeconds(5)))

# An array of sentences to display, in order. Leave the first one blank as the 0 index gets skipped.
$TextArray = @(
    ""
    "We're upgrading you to Windows 10 $WindowsVersion"
    "It may take 30-90 minutes"
    "Your pc will restart a few times"
    "Should anything go wrong (unlikely)..."
    "...please contact the Service Desk"
    "Now might be a good time to get a coffee :)"
    "We'll have you up and running again in no time"
)

# Start a dispatcher timer. This is used to control when the sentences are changed.
$TimerCode = {
    
    # The IF statement number should equal the number of sentences in the TextArray
    If ($i -lt $($TextArray.Count -1)) {
        $FadeoutAnimation.Add_Completed({            
            $UI.MaintextBlock.Opacity = 0
            $UI.MaintextBlock.Text = $TextArray[$i]
            $UI.MaintextBlock.BeginAnimation([System.Windows.Controls.TextBlock]::OpacityProperty,$FadeinAnimation)

        })   
        $UI.MaintextBlock.BeginAnimation([System.Windows.Controls.TextBlock]::OpacityProperty,$FadeoutAnimation) 
    }
    # The final sentence to display ongoing
    ElseIf ($i -eq $($TextArray.Count -1)) {        
        $FadeoutAnimation.Add_Completed({            
            $UI.MaintextBlock.Opacity  = 0
            $UI.MaintextBlock.Text = "Windows 10 Upgrade in Progress"
            $UI.MaintextBlock.BeginAnimation([System.Windows.Controls.TextBlock]::OpacityProperty,$FadeinAnimation)
            $UI.ProgressRing.IsActive = $True
        })   
        $UI.MaintextBlock.BeginAnimation([System.Windows.Controls.TextBlock]::OpacityProperty,$FadeoutAnimation)
    }
    Elseif ($i -eq $($TextArray.Count)) {
        $FadeoutAnimation.Add_Completed({            
            $UI.MaintextBlock.Opacity = 0
            $UI.MaintextBlock.Text = "Done"
            $UI.MaintextBlock.BeginAnimation([System.Windows.Controls.TextBlock]::OpacityProperty,$FadeinAnimation)
        })   
        $UI.MaintextBlock.BeginAnimation([System.Windows.Controls.TextBlock]::OpacityProperty,$FadeoutAnimation) 
    }
    else {
        $UI.Window.Close()
    }

    $ColourBrighterAnimation.Add_Completed({            
        $UI.Window.Background.BeginAnimation([System.Windows.Media.SolidColorBrush]::ColorProperty,$ColourDarkerAnimation)
    })   
    $UI.Window.Background.BeginAnimation([System.Windows.Media.SolidColorBrush]::ColorProperty,$ColourBrighterAnimation)

    $Script:i++
    $global:ProgressValue = $ProgressValue + "11.11"

}
$DispatcherTimer = New-Object -TypeName System.Windows.Threading.DispatcherTimer
$DispatcherTimer.Interval = [TimeSpan]::FromSeconds(10)
$DispatcherTimer.Add_Tick($TimerCode)


$Stopwatch = New-Object System.Diagnostics.Stopwatch
$Stopwatch.Start()
$TimerCode2 = {

    $UI.TextBlock3.Text = "$($Stopwatch.Elapsed.Hours.ToString('00')):$($Stopwatch.Elapsed.Minutes.ToString('00')):$($Stopwatch.Elapsed.Seconds.ToString('00'))"
    $UI.ProgressBar.Value  = $ProgressValue
    $UI.TextBlock2.Text = "Windows Setup Progress $ProgressValue%"

}
$DispatcherTimer2 = New-Object -TypeName System.Windows.Threading.DispatcherTimer
$DispatcherTimer2.Interval = [TimeSpan]::FromSeconds(1)
$DispatcherTimer2.Add_Tick($TimerCode2)

# Event: Window loaded
$UI.Window.Add_Loaded({
    
    # Activate the window to bring it to the fore
    $This.Activate()

    # Fill the screen
    $This.Left = $Bounds.Left
    $This.Top = $Bounds.Top
    $This.Height = $Bounds.Height
    $This.Width = $Bounds.Width

    # Hide the taskbar
    #####[TaskBar]::Hide()

    # Hide the mouse cursor
    [System.Windows.Forms.Cursor]::Hide()

    # Keep Display awake
    [DisplayState]::KeepDisplayAwake()

    # Begin animations
    $UI.MaintextBlock.BeginAnimation([System.Windows.Controls.TextBlock]::OpacityProperty,$FadeinAnimation)
    $UI.TextBlock2.BeginAnimation([System.Windows.Controls.TextBlock]::OpacityProperty,$FadeinAnimation)
    $UI.TextBlock3.BeginAnimation([System.Windows.Controls.TextBlock]::OpacityProperty,$FadeinAnimation)
    $UI.TextBlock4.BeginAnimation([System.Windows.Controls.TextBlock]::OpacityProperty,$FadeinAnimation)
    $UI.ProgressRing.BeginAnimation([System.Windows.Controls.TextBlock]::OpacityProperty,$FadeinAnimation)
    $UI.ProgressBar.BeginAnimation([System.Windows.Controls.TextBlock]::OpacityProperty,$FadeinAnimation)
    $ColourBrighterAnimation.Add_Completed({            
        $UI.Window.Background.BeginAnimation([System.Windows.Media.SolidColorBrush]::ColorProperty,$ColourDarkerAnimation)
    })   
    $UI.Window.Background.BeginAnimation([System.Windows.Media.SolidColorBrush]::ColorProperty,$ColourBrighterAnimation)

})



# Event: Window closing (for testing)
$UI.Window.Add_Closing({

    # Restore the taskbar
    #####[Taskbar]::Show()

    # Restore the mouse cursor
    [System.Windows.Forms.Cursor]::Show()

    # Cancel keeping the display awake
    [DisplayState]::Cancel()

    $Stopwatch.Stop()
    $DispatcherTimer.Stop()
    $DispatcherTimer2.Stop()

})

# Event: Close the window on right-click (for testing)
#$UI.Window.Add_MouseRightButtonDown({
#
#    $This.Close()
#
#})

# Display the window
$DispatcherTimer.Start()
$DispatcherTimer2.Start()
$UI.Window.ShowDialog()
