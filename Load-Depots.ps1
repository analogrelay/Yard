param($yardRoot)

if(!$yardRoot) {
    $yardRoot = & "$PSScriptRoot\Get-YardRoot.ps1"
}

if($yardRoot) {
    [xml](cat "$yardRoot\Depots.xml")
} else {
    throw "Current location is not in a Yard!"
}