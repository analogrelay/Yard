param($yardRoot)

# List built-in commands
$commands = @{};
dir "$PSScriptRoot\Commands\*.ps1" | ForEach-Object {
    $name = [System.IO.Path]::GetFileNameWithoutExtension($_.Name);
    $commands[$name] = [PSCustomObject]@{
        Name = $name;
        File = $_.FullName;
        BuiltIn = $true
    }
}

# Now list depot commands if there is one
if(!$yardRoot) {
    $yardRoot = & "$PSScriptRoot\Get-YardRoot.ps1"
}
if($yardRoot) {
    $depotsXml = & "$PSScriptRoot\Load-Depots.ps1" -yardRoot:$yardRoot
    if($depotsXml) {
        $depotsXml.depots.command | Where { ![String]::IsNullOrEmpty($_.name) } | ForEach-Object {
            if($_.file) {
                $commands[$_.name] = [PSCustomObject]@{
                    Name = $_.name;
                    File = Join-Path $yardRoot $_.file;
                    BuiltIn = $false
                }
            }
        }
    }
}

$commands.Keys | ForEach-Object {
    $cmd = $commands[$_]
    
    # Get Description if possible
    if([System.IO.Path]::GetExtension($cmd.File) -eq ".ps1") {
        $halp = Get-Help $cmd.File
        if($halp -and $halp.Synopsis) {
            Add-Member Description $halp.Synopsis -InputObject $cmd
        }
    } else {
        Add-Member Description "Invokes the $($cmd.File) command." -InputObject $cmd
    }
}

$commands