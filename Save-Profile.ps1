param($yardRoot, [switch]$User, [string]$Name, $YardProfile)

if(!$yardRoot) {
    $yardRoot = & "$PSScriptRoot\Get-YardRoot.ps1"
}
if(!$yardRoot) {
    throw "Not in a Yard directory!"
}

if($User) {
    $Name = "users\$(git config user.email)"
}
$FullName = Join-Path (Convert-Path $yardRoot) ".yard\profiles\$Name.xml"
$parent = Split-Path -Parent $FullName
if(!(Test-Path $parent)) {
    mkdir $parent | Out-Null
}

$YardProfile.Save($FullName)