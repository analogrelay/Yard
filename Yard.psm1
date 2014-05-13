# Integrate the git hook
$env:PATH = "$($env:PATH);$PSScriptRoot\bin"

$commands = @{};
dir "$PSScriptRoot\Commands\*.ps1" | ForEach-Object {
    $commands[[System.IO.Path]::GetFileNameWithoutExtension($_.Name)] = $_.FullName
}

$Manifest = Invoke-Expression ([String]::Join([Environment]::NewLine, (cat "$PSScriptRoot\Yard.psd1")))

$YardInfo = [PSCustomObject]@{
    Version = $Manifest.ModuleVersion;
    ModuleManifest = $Manifest;
}

if(!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Warning "Yard depends on git but we couldn't find it on your PATH. Some commands may fail in weird ways!"
}

function exec {
    param($cmd)
    Write-Host -ForegroundColor Magenta "yard> $cmd $args"
    & $cmd @args
}

function Invoke-YardCommand {
    param($Command)
    if(!$Command) {
        $Command = "help"
    }

    # Build a Yard Context
    $Context = [PSCustomObject]@{
        Command = $Command;
        CommandTable = $commands;
        YardInfo = $YardInfo;
        IsCmd = $Cmd
    };

    # Find the command
    $cmd = $commands[$Command]
    if(!$cmd) {
        $cmd = $commands["help"];
        if(!$cmd) {
            throw "Could not find help command!"
        }
    }

    Write-Debug "Invoking Command: $cmd"

    $global:YardContext = $Context
    & $cmd @args
    del variable:\YardContext
}
Set-Alias yard Invoke-YardCommand
Export-ModuleMember -Function Invoke-YardCommand -Alias yard