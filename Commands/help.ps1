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

Write-Host "NuGet Yard v$($YardContext.YardInfo.Version)"
Write-Host -ForegroundColor Magenta "yard <command> [arguments...]"
Write-Host

# List the available commands
Write-Host "Commands: "
$YardContext.CommandTable.Keys | ForEach-Object {
    Write-Host "   $_"
}