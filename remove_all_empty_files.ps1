# PowerShell script to remove all empty files found in the project
$emptyFiles = @(
    'ExeCode-Generation.py',
    'lib/assets/.keep',
    'lib/tasks/.keep',
    'log/.keep',
    'storage/.keep',
    'test/controllers/.keep',
    'test/fixtures/files/.keep',
    'test/helpers/.keep',
    'test/integration/.keep',
    'test/mailers/.keep',
    'test/models/.keep',
    'test/system/.keep',
    'tmp/restart.txt',
    'vendor/.keep',
    'vendor/javascript/.keep'
)
foreach ($file in $emptyFiles) {
    $fullPath = Join-Path $PSScriptRoot $file
    if (Test-Path $fullPath) {
        Remove-Item -Path $fullPath -Force -ErrorAction SilentlyContinue
    }
}
Write-Output "All listed empty files have been removed."
