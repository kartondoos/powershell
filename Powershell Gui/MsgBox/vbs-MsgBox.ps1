Add-Type -AssemblyName Microsoft.VisualBasic
function vbs-MsgBox
{
    param(
    [Parameter(Position=0)]
    [string]$Title ='This is a placeholder for the titel',

    [Parameter(Position=1)]
    [string]$Prompt = "This is a placeholder for text",

    [Parameter(Position=2)] [ValidateSet('Information', 'Question', 'Critical', 'Exclamation')] 
    [string]$Icon ='Information',

    [Parameter(Position=3)] [ValidateSet('OKOnly', 'OKCancel', 'AbortRetryIgnore', 'YesNoCancel', 'YesNo', 'RetryCancel')] 
    [string]$BoxType ='YesNoCancel',

    [Parameter(Position=4)] [ValidateSet(1,2,3)] 
    [int]$DefaultButton = 1
    )

switch ($Icon) {
            'Question' {$vb_icon = [microsoft.visualbasic.msgboxstyle]::Question}
            'Critical' {$vb_icon = [microsoft.visualbasic.msgboxstyle]::Critical}
            'Exclamation' {$vb_icon = [microsoft.visualbasic.msgboxstyle]::Exclamation}
            'Information' {$vb_icon = [microsoft.visualbasic.msgboxstyle]::Information}
}
switch ($BoxType) {
            'OKOnly' {$vb_box = [microsoft.visualbasic.msgboxstyle]::OKOnly}
            'OKCancel' {$vb_box = [microsoft.visualbasic.msgboxstyle]::OkCancel}
            'AbortRetryIgnore' {$vb_box = [microsoft.visualbasic.msgboxstyle]::AbortRetryIgnore}
            'YesNoCancel' {$vb_box = [microsoft.visualbasic.msgboxstyle]::YesNoCancel}
            'YesNo' {$vb_box = [microsoft.visualbasic.msgboxstyle]::YesNo}
            'RetryCancel' {$vb_box = [microsoft.visualbasic.msgboxstyle]::RetryCancel}
}
switch ($Defaultbutton) {
            1 {$vb_defaultbutton = [microsoft.visualbasic.msgboxstyle]::DefaultButton1}
            2 {$vb_defaultbutton = [microsoft.visualbasic.msgboxstyle]::DefaultButton2}
            3 {$vb_defaultbutton = [microsoft.visualbasic.msgboxstyle]::DefaultButton3}
}

$popuptype = $vb_icon -bor $vb_box -bor $vb_defaultbutton
$Result= [Microsoft.VisualBasic.Interaction]::MsgBox($prompt,$popuptype,$title)
Write-Host "You have clicked $($Result)."
}

vbs-MsgBox #run with default values
vbs-MsgBox -Title "Title" -Prompt "Prompt" -Icon Critical -BoxType YesNoCancel -DefaultButton 1