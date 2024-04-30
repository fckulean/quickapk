# Set your path which contains adb.exe

$adb_path = "C:\adb"

# Main script

if (Test-Path "$PSScriptRoot/apks" -PathType Container) {
    return $null
} else {
    ni "$PSScriptRoot/apks" -ItemType "directory"
}

function Prog {Param($name,[double]$perc,$bgcl) 
    Write-Host "$('#'*([Math]::Round($perc/5)))" -BackgroundColor $bgcl -ForegroundColor Black -NoNewline
    Write-Host "$('#'*([Math]::Round(20-($perc/5))))" -BackgroundColor DarkGray -NoNewline -ForegroundColor Black
    Write-Host " " -NoNewline
    Write-Host "$perc% - $name" -BackgroundColor $bgcl -ForegroundColor Black
}

Clear
Write-Host "quickapk 1.0 - https://github.com/fckulean/quickapk"
Write-Host "apks to install: $((gci apks).length)"
$input = Read-Host "Confirm [Y/N]"
if ($input -eq "y") {
    Write-Host "Installing $((gci apks).length) apks on device..." -ForegroundColor Yellow
    $apks = gci apks
    $counter = 0
    foreach ($apk in $apks) {
        iex "$adb_path/adb.exe install '$PSScriptRoot/apks/$apk'" | Out-Null
        $counter = $counter + 1
        Clear
        $percent = $([Math]::Round($counter/$($apks.length)*100))
        Prog "Installing - $counter/$($apks.length) - $apk" $percent Green
    }
} else {
    Write-Host "Cancelled!" -ForegroundColor Red
}