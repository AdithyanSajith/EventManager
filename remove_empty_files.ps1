# PowerShell script to remove empty .keep files
Remove-Item -Path "app\assets\images\.keep" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "app\models\concerns\.keep" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "app\controllers\concerns\.keep" -Force -ErrorAction SilentlyContinue
