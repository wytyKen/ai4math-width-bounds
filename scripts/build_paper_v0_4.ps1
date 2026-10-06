# Build the separate v0.4 manuscript with the existing local TeX installation.
# The frozen release is never overwritten; rebuild in a fresh working copy.
$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent $PSScriptRoot
$taskPaper = Join-Path $taskRoot 'paper'
$taskTmp = Join-Path $taskRoot 'tmp\pdfs\width_bounds_v0_4'
$taskOutput = Join-Path $taskRoot 'output\pdf'
if (Test-Path -LiteralPath (Join-Path $taskRoot 'output\ai4math_research_delivery_v0_4.zip')) {
    throw 'v0.4 is frozen. Rebuild in a fresh working copy, preserving the original PDF.'
}
New-Item -ItemType Directory -Path $taskTmp, $taskOutput -Force | Out-Null
Push-Location $taskPaper
try {
    foreach ($taskPass in 1..2) {
        $taskLog = & pdflatex --disable-installer -interaction=nonstopmode -halt-on-error "-output-directory=$taskTmp" 'width_bounds_v0_4.tex' 2>&1
        $taskExit = $LASTEXITCODE
        $taskLog | Set-Content -LiteralPath (Join-Path $taskTmp "compile-$taskPass.txt") -Encoding utf8
        if ($taskExit -ne 0) {
            $taskLog | Select-Object -Last 35
            throw "LaTeX pass $taskPass failed"
        }
    }
} finally {
    Pop-Location
}
Copy-Item -LiteralPath (Join-Path $taskTmp 'width_bounds_v0_4.pdf') -Destination (Join-Path $taskOutput 'width_bounds_v0_4.pdf') -Force
Get-Item -LiteralPath (Join-Path $taskOutput 'width_bounds_v0_4.pdf') | Select-Object FullName,Length
