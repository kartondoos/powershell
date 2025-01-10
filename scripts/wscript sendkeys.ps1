#start cmd 
$wshell = New-Object -ComObject wscript.shell;
$wshell.SendKeys(' start cmd ') 
$wshell.SendKeys("{ENTER}")

#mute /un mute
$obj = new-object -com wscript.shell
$obj.SendKeys([char]173)

#volume donw
$obj = new-object -com wscript.shell
$obj.SendKeys([char]174)

#volume up
$obj = new-object -com wscript.shell
$obj.SendKeys([char]175)