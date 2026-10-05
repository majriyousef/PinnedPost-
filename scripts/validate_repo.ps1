param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$required = @(
    'CLAUDE.md',
    'README.md',
    'knowledge/leonie-model.md',
    'knowledge/operations-status.md',
    'sops/02-chatting.md',
    'sops/07-quality-safety.md',
    'references/feedpost-master/00_START_HIER/CLAUDE_MASTER_FEEDPOST_WISSEN.md'
)

$failures = @()
foreach ($relative in $required) {
    $path = Join-Path $repoRoot $relative
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        $failures += "missing required file: $relative"
    }
}

$textFiles = Get-ChildItem -LiteralPath $repoRoot -File -Recurse |
    Where-Object {
        $_.FullName -notmatch '[\\/]\.git[\\/]' -and
        $_.FullName -notmatch '[\\/]references[\\/]'
    }

foreach ($file in $textFiles) {
    try {
        $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction Stop
    } catch {
        continue
    }
    if ($content -match '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----') {
        $failures += "possible private key in $($file.FullName.Substring($repoRoot.Length + 1))"
    }
    if ($content -match '\bsk-[A-Za-z0-9_-]{20,}\b') {
        $failures += "possible API key in $($file.FullName.Substring($repoRoot.Length + 1))"
    }
}

if ($failures.Count -gt 0) {
    Write-Output 'VALIDATION FAILED'
    $failures | ForEach-Object { Write-Output "- $_" }
    exit 1
}

Write-Output 'VALIDATION OK'
exit 0

