Add-Type -AssemblyName System.Speech

$synth = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$synth.Speak("Hey, today its $(Get-Date), You are great!")
$synth.Speak("you will not beleve it!")