$ErrorActionPreference = "Stop"

$installDir = Join-Path $HOME ".developer-helper-commands"
$target = Join-Path $installDir "developer-helper-commands.ps1"
$source = Join-Path $PSScriptRoot "developer-helper-commands.ps1"
$marker = "# developer-helper-commands"
$profileLine = ". `"$target`" $marker"

New-Item -ItemType Directory -Path $installDir -Force | Out-Null
Copy-Item $source $target -Force
New-Item -ItemType File -Path $PROFILE -Force | Out-Null

$profileContent = Get-Content $PROFILE -Raw
if ($profileContent -notmatch [regex]::Escape($marker)) {
    Add-Content -Path $PROFILE -Value "`n$profileLine"
}

Write-Host "Developer helper commands installed. Restart PowerShell or run: . `$PROFILE" -ForegroundColor Green
