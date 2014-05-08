<#
.SYNOPSIS
    Adds a new Remote source to the Yard

.PARAMETER Name
    The name of the remote

.PARAMETER BaseUrl
    The base URL to use when cloning repositories from this remote.
#>

param(
    [Parameter(Mandatory=$true)][string]$Name,
    [Parameter(Mandatory=$true)][string]$BaseUrl)

$depots = & "$PSScriptRoot\..\Load-Depots.ps1"

$remote = $depots.CreateElement("remote");
$remote.SetAttribute("name", $Name);
$remote.SetAttribute("baseUrl", $BaseUrl);

$depot = (Select-Xml "/depots" $depots).Node
if(!$depot) {
    throw "Malformed Depots.xml file. Missing 'depots' root node"
}
$depot.AppendChild($remote) | Out-Null;

& "$PSScriptRoot\..\Save-Depots.ps1" $depots

Write-Host "Added remote '$Name'."