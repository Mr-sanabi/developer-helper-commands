$ErrorActionPreference = "Stop"

$marker = "# developer-helper-commands"
$installDir = Join-Path $HOME ".developer-helper-commands"

if (Test-Path $PROFILE) {
    $lines = Get-Content $PROFILE | Where-Object { $_ -notmatch [regex]::Escape($marker) }
    Set-Content -Path $PROFILE -Value $lines
}

if (Test-Path $installDir) {
    Remove-Item $installDir -Recurse -Force
}

Write-Host "Developer helper commands uninstalled." -ForegroundColor Green
