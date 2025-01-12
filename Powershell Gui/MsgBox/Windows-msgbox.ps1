Add-Type -AssemblyName PresentationCore,PresentationFramework #to show dialog box 
function Windows-MsgBox
{
    param(
    [Parameter(Position=0)]
    [string]$Title ='This is a placeholder for the titel',

    [Parameter(Position=1)]
    [string]$Prompt = "This is a placeholder for text",
    
    [Parameter(Position=2)] [ValidateSet('OK', 'OKCancel', 'YesNoCancel', 'YesNo')] 
    [string]$ButtonType ='YesNoCancel',

    [Parameter(Position=3)] [ValidateSet('None','Hand','Error','Stop','Question','Exclamation','Warning','Asterisk','Information')] 
    [string]$Image ='Question'
    )
# [enum]::GetNames([System.Windows.MessageBoxOptions]) align options

# [enum]::GetNames([System.Windows.MessageBoxButton])
switch ($ButtonType) {
            'OK' {$ButtonType = [System.Windows.MessageBoxButton]::OK}
            'OKCancel' {$ButtonType = [System.Windows.MessageBoxButton]::OKCancel}
            'YesNoCancel' {$ButtonType = [System.Windows.MessageBoxButton]::YesNoCancel}
            'YesNo' {$ButtonType = [System.Windows.MessageBoxButton]::YesNo}
}

# [enum]::GetNames([System.Windows.MessageBoxImage])
switch ($Image) {
            'None' {$Image = [System.Windows.MessageBoxImage]::None }
            'Hand' {$Image = [System.Windows.MessageBoxImage]::Hand}
            'Error' {$Image = [System.Windows.MessageBoxImage]::Error}
            'Stop' {$Image = [System.Windows.MessageBoxImage]::Stop}
            'Question' {$Image = [System.Windows.MessageBoxImage]::Question}
            'Exclamation' {$Image = [System.Windows.MessageBoxImage]::Exclamation}
            'Warning' {$Image = [System.Windows.MessageBoxImage]::Warning}
            'Asterisk' {$Image = [System.Windows.MessageBoxImage]::Asterisk}
            'Information' {$Image = [System.Windows.MessageBoxImage]::Information}
}

$Result = [System.Windows.MessageBox]::Show($Title,$Prompt,$ButtonType,$Image)
Write-Host "You have clicked $($Result)."

}
Windows-MsgBox #run with default values
Windows-MsgBox -Title "Title" -Prompt "Prompt" -ButtonType YesNo -Image Asterisk