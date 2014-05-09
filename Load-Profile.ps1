param($yardRoot, [switch]$User, [string]$Name)

if(!$yardRoot) {
    $yardRoot = & "$PSScriptRoot\Get-YardRoot.ps1"
}
if(!$yardRoot) {
    throw "Not in a Yard directory!"
}

if($User) {
    $Name = "users\$(git config user.email)"
}
$FullName = Join-Path $yardRoot "$Name.xml"

if(Test-Path $FullName) {
    [xml](cat "$FullName")
} else {
    [xml](
@"
<?xml version="1.0" ?>
<profile />
"@
)
}