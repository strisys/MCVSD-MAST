# 1. FORCE the working directory to the folder where this script lives
Set-Location $PSScriptRoot

# 2. Get the current branch name safely
$currentBranch = (git symbolic-ref --short HEAD 2>$null)

# Fallback if symbolic-ref is empty
if ([string]::IsNullOrWhiteSpace($currentBranch)) {
    $currentBranch = (git branch --show-current 2>$null)
}

# 3. Check for Null before using .Trim() to prevent the "InvalidOperation" error
if ($null -ne $currentBranch) {
    $currentBranch = $currentBranch.Trim()
} else {
    $currentBranch = "NOT_A_GIT_REPO"
}

# 4. Check if we are on the 'main' branch
if ($currentBranch -eq "main") {
    Write-Host "Confirmed: Operating on 'main' branch." -ForegroundColor Cyan
    
    $targets = Get-ChildItem -Path $PSScriptRoot -Filter "answers" -Recurse -Directory

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
        Write-Host "No folders named 'answers' found in $PSScriptRoot." -ForegroundColor Gray
    }
} else {
    Write-Host "ABORTED: Current branch is '$currentBranch'." -ForegroundColor Red
    if ($currentBranch -eq "NOT_A_GIT_REPO") {
        Write-Host "Make sure this script is inside your Git project folder." -ForegroundColor Yellow
    }
}

Write-Host "`nPress Enter to exit..." -ForegroundColor White
Read-Host