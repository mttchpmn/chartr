param (
    [Parameter(Mandatory=$true)]
    [ValidateSet('major', 'minor', 'patch', 'build')]
    [string]$VersionType
)

function Increment-Version {
    param (
        [string]$versionString,
        [string]$versionType
    )

    $versionParts = $versionString.Split('+')[0].Split('.')
    $buildNumber = $versionString.Split('+')[1]

    switch ($versionType) {
        'major' { $versionParts[0] = [int]$versionParts[0] + 1; $versionParts[1] = 0; $versionParts[2] = 0 }
        'minor' { $versionParts[1] = [int]$versionParts[1] + 1; $versionParts[2] = 0 }
        'patch' { $versionParts[2] = [int]$versionParts[2] + 1 }
        'build' { $buildNumber = [int]$buildNumber + 1 }
    }

    return ($versionParts -join '.') + '+' + $buildNumber
}

# Read the pubspec.yaml
$pubspecPath = Join-Path $PSScriptRoot '..\pubspec.yaml'
$pubspecContent = Get-Content $pubspecPath -Raw

# Extract the current version
$versionRegex = [regex]'version: ([0-9]+\.[0-9]+\.[0-9]+\+[0-9]+)'
$matches = $versionRegex.Match($pubspecContent)
$currentVersion = $matches.Groups[1].Value

# Increment the version
$newVersion = Increment-Version -versionString $currentVersion -versionType $VersionType

Write-Host "CURRENT VER: $currentVersion NEW VER: $newVersion"

Write-Host "Building RANGR $newVersion"

# Update the pubspec.yaml
$newVersionLine = "version: $newVersion"
$pubspecContent = [regex]::Replace($pubspecContent, $versionRegex, $newVersionLine)
$pubspecContent | Set-Content $pubspecPath

# Build the APK
flutter build apk | Out-Null

# Copy and rename the APK
$apkSourcePath = Join-Path $PSScriptRoot '..\build\app\outputs\flutter-apk\app-release.apk'
$apkDestPath = Join-Path $PSScriptRoot "..\releases\RANGR-$newVersion.apk"
Copy-Item -Path $apkSourcePath -Destination $apkDestPath

Write-Host "APK built and saved to /releases folder"
