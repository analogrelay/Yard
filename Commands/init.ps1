<#
.SYNOPSIS
    Creates a new Yard in the current directory
#>

$DepotsFile = Join-Path (Get-Location) "Depots.xml"

if(Test-Path $DepotsFile) {
    throw "There is already a Depots.xml file in this location!"
}
else {
    @"
<?xml version="1.0" encoding="UTF-8"?>
<depots>
</depots>
"@ | Out-File -FilePath $DepotsFile -Encoding UTF8
}