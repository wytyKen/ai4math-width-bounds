param(
    [ValidateSet('width_bounds', 'width_bounds_v0_2', 'width_bounds_v0_3')]
    [string]$PaperName = 'width_bounds'
)

$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent $PSScriptRoot
$taskPaper = Join-Path $taskRoot 'paper'
$taskTmp = Join-Path $taskRoot "tmp\pdfs\$PaperName"
$taskOutput = Join-Path $taskRoot 'output\pdf'
New-Item -ItemType Directory -Path $taskTmp, $taskOutput -Force | Out-Null
if ($PaperName -eq 'width_bounds') {
    & (Join-Path $taskRoot '.venv\Scripts\python.exe') -X utf8 (Join-Path $PSScriptRoot 'prepare_paper.py')
    if ($LASTEXITCODE -ne 0) { throw 'Paper table preparation failed' }
}
Push-Location $taskPaper
try {
    foreach ($taskPass in 1..2) {
        $taskLog = & pdflatex --disable-installer -interaction=nonstopmode -halt-on-error "-output-directory=$taskTmp" "$PaperName.tex" 2>&1
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
Copy-Item -LiteralPath (Join-Path $taskTmp "$PaperName.pdf") -Destination (Join-Path $taskOutput "$PaperName.pdf") -Force
Get-Item -LiteralPath (Join-Path $taskOutput "$PaperName.pdf") | Select-Object FullName,Length
