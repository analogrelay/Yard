<#
.SYNOPSIS
    Displays help for yard commands
#>
param($Command)

if($Command) {
    $cmd = $YardContext.CommandTable[$Command]
    if($cmd) {
        # Create a psuedo function
        Set-Item "function:\yard $Command" ([String]::Join([Environment]::NewLine, (cat $cmd)))
        Get-Help "yard $Command"
        del "function:\yard $Command"
        exit
    }
    Write-Host -ForegroundColor Yellow "Unknown command $Command"
}

Write-Host "Git Yard v$($YardContext.YardInfo.Version)"
Write-Host -ForegroundColor Magenta "yard <command> [arguments...]"
Write-Host

$maxCmd = $YardContext.CommandTable.Keys | select -ExpandProperty Length | sort -descending | select -first 1
function RenderCommand($cmd) {
    $desc = "";
    if($cmd.Description) {
        $desc = " - $($cmd.Description)"
    }
    Write-Host "   $($cmd.Name.PadRight($maxCmd))$desc"
}

# List the available commands
Write-Host "Built-In Commands: "
$YardContext.CommandTable.Keys | where { $YardContext.CommandTable[$_].BuiltIn } | ForEach-Object {
    RenderCommand $YardContext.CommandTable[$_]
}

$yardCommands = $YardContext.CommandTable.Keys | where { !$YardContext.CommandTable[$_].BuiltIn }
if($yardCommands) {
    Write-Host
    Write-Host "Commands defined in this Yard: "
    $yardCommands | ForEach-Object {
        RenderCommand $YardContext.CommandTable[$_]
    }
}