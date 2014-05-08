$current = (Get-Item (Get-Location))

do {
    $depotFile = Join-Path $current.FullName "Depots.xml"
    if(Test-Path $depotFile) {
        Write-Debug "Found YardRoot: $($current.FullName)"
        return $current.FullName
    }
    $current = $current.Parent;
} while($current);

# If we get here, we failed :(