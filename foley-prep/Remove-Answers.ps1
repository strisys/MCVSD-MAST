# Get the location where this script is saved
$currentPath = $PSScriptRoot

# Find all directories named "answers" recursively
$targets = Get-ChildItem -Path $currentPath -Filter "answers" -Recurse -Directory

if ($targets) {
    Write-Host "Found $($targets.Count) directories to delete." -ForegroundColor Cyan
    
    foreach ($dir in $targets) {
        Write-Host "Deleting: $($dir.FullName)" -ForegroundColor Yellow
        # Remove-Item deletes the folder and everything inside (-Recurse)
        Remove-Item -Path $dir.FullName -Recurse -Force
    }
    
    Write-Host "Cleanup complete." -ForegroundColor Green
} else {
    Write-Host "No directories named 'answers' were found." -ForegroundColor Gray
}

pause