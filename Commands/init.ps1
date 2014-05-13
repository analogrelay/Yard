<#
.SYNOPSIS
    Creates a new Yard in the current directory
#>

$DepotsFile = Join-Path (Get-Location) "Depots.xml"
$GitIgnoreFile = Join-Path (Get-Location) ".gitignore"
$ReadMeFile = Join-Path (Get-Location) "README.md"

if(Test-Path $DepotsFile) {
    throw "There is already a Depots.xml file in this location!"
}
else {
    git init
    @"
<?xml version="1.0" encoding="UTF-8"?>
<depots>
</depots>
"@ | Out-File -FilePath $DepotsFile -Encoding UTF8
    @"
# Yard Git Ignore file. Ignore EVERYTHING except Yard-related files.
*

!Depots.xml
!.yard
!.gitignore
!README.md
"@ | Out-File -FilePath $GitIgnoreFile -Encoding UTF8

    @"
This is a Yard Repo. Clone it and run 'yard sync' to clone all the depots referenced in this repository.
"@ | Out-File -FilePath $ReadMeFile -Encoding UTF8

    git add -A
    git commit -m "Initial Commit"
}