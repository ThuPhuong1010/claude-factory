# check-parallel.ps1
# Runs at SessionStart — detects parallel mode signals and outputs systemMessage if needed

$projectRoot = Split-Path -Parent $PSScriptRoot

# Read PARALLEL MODE status
$activeFile = Join-Path $projectRoot "tracklog\active.md"
if (-not (Test-Path $activeFile)) { exit 0 }

$activeContent = Get-Content $activeFile -Raw -ErrorAction SilentlyContinue
if ($activeContent -match "PARALLEL MODE: ON") { exit 0 }  # Already ON, nothing to do

# Check signals
$signals = @()

# Signal 1: tasks.md mentions Antigravity
$tasksFile = Join-Path $projectRoot "context\tasks.md"
if (Test-Path $tasksFile) {
    $tasksContent = Get-Content $tasksFile -Raw -ErrorAction SilentlyContinue
    if ($tasksContent -match "Antigravity") {
        $signals += "context/tasks.md có task gán cho Antigravity"
    }
}

# Signal 2: input.md mentions parallel/Antigravity
$inputFile = Join-Path $projectRoot "context\input.md"
if (Test-Path $inputFile) {
    $inputContent = Get-Content $inputFile -Raw -ErrorAction SilentlyContinue
    if ($inputContent -match "Antigravity|song song|parallel|hai tool") {
        $signals += "context/input.md đề cập làm việc song song"
    }
}

if ($signals.Count -eq 0) { exit 0 }

# Output systemMessage for Claude to pick up
$signalList = $signals -join "; "
Write-Output "PARALLEL_SIGNAL_DETECTED: $signalList"
