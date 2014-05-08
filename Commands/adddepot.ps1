<#
.SYNOPSIS
    Adds a new Depot to the Yard

.PARAMETER Name
    The name of the depot. This will be appended to the BaseUrl of the Remote when cloning

.PARAMETER Remote
    The remote that contains this depot.

.PARAMETER Path
    (Optional) The path to clone the repository to.
#>

param(
    [Parameter(Mandatory=$true)][string]$Name,
    [Parameter(Mandatory=$true)][string]$Remote,
    [Parameter(Mandatory=$false)][string]$Path)

$depots = & "$PSScriptRoot\..\Load-Depots.ps1"

$root = (Select-Xml "/depots" $depots).Node
if(!$root) {
    throw "Malformed Depots.xml file. Missing 'depots' root node"
}

$remoteXml = (Select-Xml "/depots/remote[@name='$Remote']" $depots).Node
if(!$remoteXml) {
    Write-Warning "Remote '$Remote' could not be found. You may not be able to sync."
}

$depot = $depots.CreateElement("depot");
$depot.SetAttribute("name", $Name);
$depot.SetAttribute("remote", $Remote);
if($Path) {
    $depot.SetAttribute("path", $Path);
}
$root.AppendChild($depot) | Out-Null;

& "$PSScriptRoot\..\Save-Depots.ps1" $depots

Write-Host "Added depot '$Name'."