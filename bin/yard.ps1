param([switch]$Cmd)
Import-Module "$PSScriptRoot\..\Yard.psd1"
yard -Cmd:$Cmd @args
Remove-Module Yard