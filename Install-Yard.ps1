# Add to user-level variables
$current = [Environment]::GetEnvironmentVariable("PATH", "User")
[Environment]::SetEnvironmentVariable("PATH", "$current;$PSScriptRoot\bin", "User")

# Add to current process variables
$env:PATH = "$($env:PATH);$PSScriptRoot\bin"