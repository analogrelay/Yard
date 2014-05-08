<#
.SYNOPSIS
    Synchronizes all repositories in the current Yard

.PARAMETER Depots
    A comma-separated list of depots to sync. If this is not specified, only the depots you ALREADY HAVE will be updated.
    If this IS specified, those depots will be CLONED if they haven't already been cloned and UPDATED.
#>
param(
    [Parameter(Mandatory=$false)][string[]]$Depots)

function enter($dir) {
    Write-Debug "Entering $dir"
    exec cd $dir
}

# Capture the current directory
$returnDirectory = (Get-Location)
$dirty = @();
try {
    $depotList = & "$PSScriptRoot\depots.ps1";
    if($Depots -and ($Depots.Length -gt 0)) {
        $depotList = $depotList | where { $Depots -contains $_.Name }
    }

    $depotList | ForEach-Object {
        $depot = $_
        Write-Host -ForegroundColor Green "* Syncing $($_.name) *"
        if(!(Test-Path $_.Path)) {
            exec git clone $_.Url $_.Path
        }
        else {
            enter $_.Path
            $modifications = @(exec git status | where { $_ -like "*modified:*" })
            if($modifications.Length -gt 0) {
                $dirty += @($_)
            }
            else {
                exec git checkout master 2>&1 | Out-Null
                exec git pull origin master 2>&1 | ForEach-Object {
                    if($_ -like "*You have unstaged changes*") {
                        $dirty += @($depot)
                    }
                    $out = $_;
                    if($out -is [System.Management.Automation.ErrorRecord]) {
                        $out= $out.Exception.Message
                    }
                    $out | Write-Verbose
                }
            }
        }
    }
} finally {
    # Return to the start directory
    exec cd $returnDirectory
}

if($dirty.Length -gt 0) {
    Write-Warning "The following depots had local changes and couldn't be synced. Commit or stash your local changes and try again."
    $dirty | ForEach-Object {
        Write-Warning "* $($_.Name)"
    }
}