# .Net methods for hiding/showing the console in the background
Add-Type -Name Window -Namespace Console -MemberDefinition '

[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
# Hide = 0,
# ShowNormal = 1,
# ShowMinimized = 2,
# ShowMaximized = 3,
# Maximize = 3,
# ShowNormalNoActivate = 4,
# Show = 5,
# Minimize = 6,
# ShowMinNoActivate = 7,
# ShowNoActivate = 8,
# Restore = 9,
# ShowDefault = 10,
# ForceMinimized = 11

[Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 4)