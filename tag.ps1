Write-Host "testing tag"

function New-Tag {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        [string] $Tag)
    process {
        if ($PSCmdlet.ShouldProcess("git tag $Tag")) {
            Write-Verbose "git tag $Tag"
            git tag $Tag
        }
    }
}

function New-SemverTag {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(ParameterSetName = "BreakingChange")]
        [switch] $BreakingChange = $false,
        [Parameter(ParameterSetName = "NewFeature")]
        [switch] $NewFeature = $false,
        [Parameter(ParameterSetName = "BugFix")]
        [switch] $BugFix = $false)

    $v = Get-Version
    [int] $Major = $v.Major;
    [int] $Minor = $v.Minor;
    [int] $Build = $v.Build;

    $oldTag = 'v{0}.{1}.{2}' -f $Major, $Minor, $Build

    if ($BreakingChange) {
        $Major += 1;
        $Minor = 0;
        $Build = 0;
    }

    if ($NewFeature) {
        $Minor += 1;
        $Build = 0;
    }

    if ($BugFix) {
        $Build += 1;
    }

    $newTag = 'v{0}.{1}.{2}' -f $Major, $Minor, $Build
    $message = "Moving from $oldTag to $newTag"

    if ($PsCmdlet.ShouldProcess($message)) {
        Write-Host $message
        New-Tag $newTag
    }
}
