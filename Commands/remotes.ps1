<#
.SYNOPSIS
    Lists remotes in the current depot
#>

$depots = & "$PSScriptRoot\..\Load-Depots.ps1"

$depots.depots.remote | ForEach-Object {
    [PSCustomObject]@{
        Name = $_.name;
        Url = $_.baseUrl;
    }
}