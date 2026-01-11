# 1. Get the current branch name
$currentBranch = git branch --show-current

# 2. Check if we are on the 'main' branch
if ($currentBranch -eq "main") {
    Write-Host "Confirmed: Operating on 'main' branch." -ForegroundColor Cyan
    
    # Define the starting path (where the script is located)
    $searchPath = $PSScriptRoot

    # Find all subdirectories named "answers"
    $targets = Get-ChildItem -Path $searchPath -Filter "answers" -Recurse -Directory

    if ($targets) {
        Write-Host "Found $($targets.Count) directories to delete." -ForegroundColor Yellow
        
        foreach ($dir in $targets) {
            try {
                Write-Host "Deleting: $($dir.FullName)" -ForegroundColor Gray
                Remove-Item -Path $dir.FullName -Recurse -Force -ErrorAction Stop
            } catch {
                Write-Host "Error deleting $($dir.FullName): $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        Write-Host "Done! All 'answers' folders removed." -ForegroundColor Green
    } else {
        Write-Host "No folders named 'answers' were found in $searchPath." -ForegroundColor Gray
    }

} else {
    # If not on main, skip the deletion
    Write-Host "ABORTED: Current branch is '$currentBranch'." -ForegroundColor Red
    Write-Host "This script is restricted to run only on the 'main' branch." -ForegroundColor Red
}

# 3. Keep the window open
Write-Host "`nPress Enter to exit..." -ForegroundColor White
Read-Host