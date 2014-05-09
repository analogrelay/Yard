[CmdletBinding(DefaultParameterSetName="ListProfiles")]
param(
    [Parameter(Mandatory=$true, ParameterSetName="UserProfileAppend")]
    [Parameter(Mandatory=$true, ParameterSetName="NamedProfileAppend")]
    [switch]$Append,

    [Parameter(Mandatory=$true, ParameterSetName="UserProfileRemove")]
    [Parameter(Mandatory=$true, ParameterSetName="NamedProfileRemove")]
    [switch]$Remove,

    [Parameter(Mandatory=$true, Position=0, ParameterSetName="NamedProfileShow")]
    [Parameter(Mandatory=$true, Position=0, ParameterSetName="NamedProfileAppend")]
    [Parameter(Mandatory=$true, Position=0, ParameterSetName="NamedProfileRemove")]
    [Parameter(Mandatory=$true, Position=0, ParameterSetName="NamedProfileCreate")]
    [string]$Name,

    [Parameter(Mandatory=$true, ParameterSetName="UserProfileShow")]
    [Parameter(Mandatory=$true, ParameterSetName="UserProfileCreate")]
    [Parameter(Mandatory=$true, ParameterSetName="UserProfileAppend")]
    [Parameter(Mandatory=$true, ParameterSetName="UserProfileRemove")]
    [switch]$User,

    [Parameter(Mandatory=$true, Position=0, ParameterSetName="UserProfileAppend")]
    [Parameter(Mandatory=$true, Position=1, ParameterSetName="NamedProfileAppend")]
    [Parameter(Mandatory=$true, Position=0, ParameterSetName="UserProfileCreate")]
    [Parameter(Mandatory=$true, Position=1, ParameterSetName="NamedProfileCreate")]
    [Parameter(Mandatory=$true, Position=0, ParameterSetName="UserProfileRemove")]
    [Parameter(Mandatory=$true, Position=1, ParameterSetName="NamedProfileRemove")]
    [string[]]$Depots)

if($PSCmdlet.ParameterSetName -eq "ListProfiles") {
    throw "List!"
}
else {
    # Load the current value for the relevant profile
    $YardProfile = & "$PSScriptRoot\..\Load-Profile.ps1" -User:$User -Name $Name

    function adddepot($name) {
        Write-Host "+ $name"
        $root = (Select-Xml "/profile" $YardProfile).Node
        $depot = $YardProfile.CreateElement("depot");
        $depot.SetAttribute("ref", $name);
        $root.AppendChild($depot) | Out-Null;
    }

    function rmdepot($name) {
        Write-Host "- $name"
        $root = (Select-Xml "/profile" $YardProfile).Node
        $node = (Select-Xml "/profile/depot[@ref='$name']" $YardProfile).Node
        if($node) {
            $root.RemoveChild($node)
        }
    }

    function clprofile {
        Write-Host "- *"
        $root = (Select-Xml "/profile" $YardProfile).Node
        $root.RemoveAll()
    }

    # Make the changes
    if(($PSCmdlet.ParameterSetName -eq "NamedProfileShow") -or ($PSCmdlet.ParameterSetName -eq "UserProfileShow")) {
        $YardProfile.profile.depot.ref
    }
    elseif(($PSCmdlet.ParameterSetName -eq "NamedProfileCreate") -or ($PSCmdlet.ParameterSetName -eq "UserProfileCreate")) {
        clprofile
        $Depots | ForEach-Object {
            adddepot $_
        }
    } elseif(($PSCmdlet.ParameterSetName -eq "NamedProfileAppend") -or ($PSCmdlet.ParameterSetName -eq "UserProfileAppend")) {
        $Depots | ForEach-Object {
            adddepot $_
        }
    } elseif(($PSCmdlet.ParameterSetName -eq "NamedProfileRemove") -or ($PSCmdlet.ParameterSetName -eq "UserProfileRemove")) {
        $Depots | ForEach-Object {
            rmdepot $_
        }
    }

    # Save the profile back
    & "$PSScriptRoot\..\Save-Profile.ps1" -User:$User -Name $Name -YardProfile $YardProfile
}