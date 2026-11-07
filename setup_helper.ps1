param (
    [string]$LichiiPath = ""
)

if (-not $LichiiPath) {
    exit 0
}

$appDataDir = Join-Path $env:LOCALAPPDATA "Lossless Scaling"
$settingsPath = Join-Path $appDataDir "Settings.xml"
$templatePath = Join-Path $PSScriptRoot "LosslessScaling\Settings.xml"

try {
    if (-not (Test-Path $appDataDir)) {
        New-Item -ItemType Directory -Force -Path $appDataDir | Out-Null
    }

    if (-not (Test-Path $settingsPath)) {
        if (Test-Path $templatePath) {
            $content = Get-Content $templatePath -Raw -Encoding UTF8
            $content = $content.Replace("{LICHII_PATH}", $LichiiPath)
            Set-Content -Path $settingsPath -Value $content -Encoding UTF8
        }
    } else {
        [xml]$xml = Get-Content $settingsPath -Encoding UTF8
        $profile = $xml.Settings.GameProfiles.Profile | Where-Object { $_.Title -eq "OcarinaofTime" }
        if ($profile) {
            $profile.Path = $LichiiPath
            $profile.AutoScale = "true"
            $profile.AutoScaleDelay = "3"
            $profile.ScalingType = "Off"
            $profile.FrameGeneration = "LSFG2"
            $profile.LSFG2Mode = "X2"
            $profile.MaxFrameLatency = "1"
            $profile.WindowedMode = "false"
        } else {
            # Create new profile node
            $templateContent = Get-Content $templatePath -Raw -Encoding UTF8
            [xml]$templateXml = $templateContent.Replace("{LICHII_PATH}", $LichiiPath)
            $newProfile = $xml.ImportNode($templateXml.Settings.GameProfiles.Profile[1], $true)
            $xml.Settings.GameProfiles.AppendChild($newProfile) | Out-Null
        }
        $xml.Save($settingsPath)
    }
} catch {
    Write-Warning "Lossless Scaling configuration update failed: $_"
}
