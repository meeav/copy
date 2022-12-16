Write-Host "testing tag"

Function TagSemantic ($tagPrefix) {
    $currentTags = @(git tag --list "$($tagPrefix)*")
    Write-Host $commitMessage
    Write-Host $currentTags
    if ($currentTags.Count -eq 0) {
        $tag = "$($tagPrefix)_v0.0.1"
    }
    else {
        $currentVersions = $currentTags | ForEach-Object { [System.Version]$_.Split('_v')[1] } | Sort-Object -Descending
        $lastVersion = $currentVersions[0]
        if ($commitMessage.Contains("major")) {
            $tag = "$($tagPrefix)_v$($lastVersion.Major+1).0.0"
        }
        elseif ($commitMessage.Contains("minor")) {
            $tag = "$($tagPrefix)_v$($lastVersion.Major).$($lastVersion.Minor+1).0"
        }
        else {
            $tag = "$($tagPrefix)_v$($lastVersion.Major).$($lastVersion.Minor).$($lastVersion.Build+1)"
        }
    }
    Write-Host "Applying semantic tag $tag"
    git tag $tag -m "auto-generated tag"
}
git config user.name "GitHub Actions Automatic Tagging"
git config user.email "<>"
$lastTag = "v0.1.0"
Write-Host "Last tag is $lastTag"
$changedFiles = @(git diff --name-only "$($lastTag)..HEAD")
Write-Host $changedFiles
TagSemantic('testtag_')
git push --follow-tags
