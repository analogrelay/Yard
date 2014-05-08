param([xml]$Depots, $yardRoot)

if(!$yardRoot) {
    $yardRoot = & "$PSScriptRoot\Get-YardRoot.ps1"
}

if($yardRoot) {
    $Depots.Save((Convert-Path "$yardRoot\Depots.xml"))
} else {
    throw "Current location is not in a Yard!"
}