<#
.SYNOPSIS
    Lists remotes in the current depot
#>

$yardRoot = & "$PSScriptRoot\..\Get-YardRoot.ps1"
$depots = & "$PSScriptRoot\..\Load-Depots.ps1" $yardRoot

$depots.depots.depot | ForEach-Object {
    $path = $_.path;
    if(!$path) {
        $path = $_.name
    }
    $path = Join-Path $yardRoot $path

    # Locate the remote
    $url = $null;
    $remoteXml = (Select-Xml "/depots/remote[@name='$($_.remote)']" $depots).Node
    if($remoteXml) {
        $base = $remoteXml.baseUrl
        if(!$base.EndsWith("/")) {
            $base += "/"
        }
        $url = $base + $_.name
    }

    [PSCustomObject]@{
        Name = $_.name;
        Remote = $_.remote;
        Url = $url;
        Path = $path;
    }
}