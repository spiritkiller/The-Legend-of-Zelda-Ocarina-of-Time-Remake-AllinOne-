param (
    [string]$LichiiPath = ""
)

if (-not $LichiiPath) {
    exit 0
}

$appDataDir = Join-Path $env:LOCALAPPDATA "Lossless Scaling"
$settingsPath = Join-Path $appDataDir "Settings.xml"

try {
    # Yalnızca kullanıcının sisteminde Lossless Scaling ayar dizini varsa yapılandır
    if (Test-Path $settingsPath) {
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
            $xml.Save($settingsPath)
            Write-Host "[OK] Lossless Scaling OcarinaofTime profili guncellendi."
        }
    }
} catch {
    Write-Warning "Lossless Scaling konfigurasyon guncellemesi atlandi: $_"
}
