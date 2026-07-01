# =========================
# Custom Git Helper Commands
# =========================

function gwhere {
    Write-Host ""
    Write-Host "Current folder:" -ForegroundColor Cyan
    Write-Host (Get-Location).Path

    Write-Host "`nGit root:" -ForegroundColor Cyan
    $root = git rev-parse --show-toplevel 2>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Not inside a Git repository." -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host $root -ForegroundColor Green
    Write-Host ""
}

function gcheck {
    Write-Host ""
    Write-Host "Current folder:" -ForegroundColor Cyan
    Write-Host (Get-Location).Path

    Write-Host "`nGit root:" -ForegroundColor Cyan
    $root = git rev-parse --show-toplevel 2>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Not inside a Git repository. Stop." -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host $root -ForegroundColor Green

    Write-Host "`nBranch:" -ForegroundColor Cyan
    $branch = git branch --show-current
    if ([string]::IsNullOrWhiteSpace($branch)) {
        Write-Host "No branch detected." -ForegroundColor Yellow
    } else {
        Write-Host $branch
    }

    Write-Host "`nRemote:" -ForegroundColor Cyan
    $remote = git remote -v
    if ([string]::IsNullOrWhiteSpace($remote)) {
        Write-Host "No remote connected." -ForegroundColor Yellow
    } else {
        git remote -v
    }

    Write-Host "`nStatus:" -ForegroundColor Cyan
    $status = git status --short
    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Host "Working tree clean." -ForegroundColor Green
    } else {
        git status --short
    }

    Write-Host ""
}

function gstage {
    Write-Host ""

    $root = git rev-parse --show-toplevel 2>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Not inside a Git repository. Stop." -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host "Git root: $root" -ForegroundColor Green

    Write-Host "`nStatus before add:" -ForegroundColor Cyan
    $before = git status --short
    if ([string]::IsNullOrWhiteSpace($before)) {
        Write-Host "No changes to stage." -ForegroundColor Green
        Write-Host ""
        return
    } else {
        git status --short
    }

    Write-Host "`nAdding all changes..." -ForegroundColor Cyan
    git add .

    Write-Host "`nStatus after add:" -ForegroundColor Cyan
    git status --short

    Write-Host ""
}

function gcommit {
    param(
        [Parameter(Mandatory=$true)]
        [string]$msg
    )

    Write-Host ""

    $root = git rev-parse --show-toplevel 2>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Not inside a Git repository. Stop." -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host "Git root: $root" -ForegroundColor Green

    Write-Host "`nCommitting with message:" -ForegroundColor Cyan
    Write-Host $msg

    git commit -m $msg

    Write-Host ""
}

function gpush {
    Write-Host ""

    $root = git rev-parse --show-toplevel 2>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Not inside a Git repository. Stop." -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host "Git root: $root" -ForegroundColor Green

    Write-Host "`nPushing to remote..." -ForegroundColor Cyan
    git push

    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "Push failed." -ForegroundColor Red
        Write-Host "If this is a new repository, run:" -ForegroundColor Yellow
        Write-Host "gsetup https://github.com/USERNAME/REPO.git" -ForegroundColor Yellow
    }

    Write-Host ""
}

function gsetup {
    param(
        [Parameter(Mandatory=$false)]
        [string]$RemoteUrl
    )

    Write-Host ""
    Write-Host "GitHub repository setup..." -ForegroundColor Cyan

    $root = git rev-parse --show-toplevel 2>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Not inside a Git repository. Stop." -ForegroundColor Red
        Write-Host "Run git init first." -ForegroundColor Yellow
        Write-Host ""
        return
    }

    Write-Host "Git root: $root" -ForegroundColor Green

    Write-Host "`nChecking branch..." -ForegroundColor Cyan
    $branch = git branch --show-current

    if ([string]::IsNullOrWhiteSpace($branch)) {
        Write-Host "No branch detected. Make sure you have at least one commit." -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host "Current branch: $branch"

    if ($branch -ne "main") {
        Write-Host "Renaming branch '$branch' -> 'main'..." -ForegroundColor Cyan
        git branch -M main

        if ($LASTEXITCODE -ne 0) {
            Write-Host "Branch rename failed." -ForegroundColor Red
            Write-Host ""
            return
        }

        $branch = "main"
    }

    Write-Host "`nChecking remote origin..." -ForegroundColor Cyan
    $origin = git remote get-url origin 2>$null

    if ([string]::IsNullOrWhiteSpace($origin)) {
        if ([string]::IsNullOrWhiteSpace($RemoteUrl)) {
            Write-Host "No origin remote connected." -ForegroundColor Yellow
            Write-Host "Usage:" -ForegroundColor Cyan
            Write-Host "gsetup https://github.com/USERNAME/REPO.git" -ForegroundColor Yellow
            Write-Host ""
            return
        }

        Write-Host "Adding origin remote..." -ForegroundColor Cyan
        git remote add origin $RemoteUrl

        if ($LASTEXITCODE -ne 0) {
            Write-Host "Failed to add origin remote." -ForegroundColor Red
            Write-Host ""
            return
        }
    } else {
        Write-Host "Origin already connected:" -ForegroundColor Green
        Write-Host $origin

        if (-not [string]::IsNullOrWhiteSpace($RemoteUrl) -and $RemoteUrl -ne $origin) {
            Write-Host ""
            Write-Host "You passed a different remote URL, but origin already exists." -ForegroundColor Yellow
            Write-Host "Current origin was not changed automatically." -ForegroundColor Yellow
            Write-Host "To change it manually:" -ForegroundColor Cyan
            Write-Host "git remote set-url origin $RemoteUrl" -ForegroundColor Yellow
        }
    }

    Write-Host "`nRemote:" -ForegroundColor Cyan
    git remote -v

    Write-Host "`nPushing main and setting upstream..." -ForegroundColor Cyan
    git push -u origin main

    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "Setup push failed. Check GitHub repo URL or authentication." -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host ""
    Write-Host "Repository setup completed." -ForegroundColor Green
    Write-Host "Future pushes can use: gpush" -ForegroundColor Green
    Write-Host ""
}

function gsave {
    param(
        [Parameter(Mandatory=$true)]
        [string]$msg
    )

    Write-Host ""
    Write-Host "Checking repository..." -ForegroundColor Cyan

    $root = git rev-parse --show-toplevel 2>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Not inside a Git repository. Stop." -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host "Git root: $root" -ForegroundColor Green

    Write-Host "`nBranch:" -ForegroundColor Cyan
    $branch = git branch --show-current
    if ([string]::IsNullOrWhiteSpace($branch)) {
        Write-Host "No branch detected." -ForegroundColor Yellow
    } else {
        Write-Host $branch
    }

    Write-Host "`nRemote:" -ForegroundColor Cyan
    $remote = git remote -v
    if ([string]::IsNullOrWhiteSpace($remote)) {
        Write-Host "No remote connected." -ForegroundColor Yellow
    } else {
        git remote -v
    }

    Write-Host "`nStatus before add:" -ForegroundColor Cyan
    $before = git status --short
    if ([string]::IsNullOrWhiteSpace($before)) {
        Write-Host "No changes to commit." -ForegroundColor Green
        Write-Host ""
        return
    } else {
        git status --short
    }

    Write-Host "`nAdding all changes..." -ForegroundColor Cyan
    git add .

    Write-Host "`nStatus after add:" -ForegroundColor Cyan
    git status --short

    Write-Host "`nCommitting with message:" -ForegroundColor Cyan
    Write-Host $msg

    git commit -m $msg

    if ($LASTEXITCODE -ne 0) {
        Write-Host "`nCommit failed. Check the message above." -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host "`nStatus after commit:" -ForegroundColor Cyan
    $after = git status --short
    if ([string]::IsNullOrWhiteSpace($after)) {
        Write-Host "Working tree clean." -ForegroundColor Green
    } else {
        git status --short
    }

    Write-Host ""
}

function glog {
    Write-Host ""

    $root = git rev-parse --show-toplevel 2>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Not inside a Git repository. Stop." -ForegroundColor Red
        Write-Host ""
        return
    }

    git log --oneline --graph --decorate --all -10

    Write-Host ""
}

function gundo-stage {
    Write-Host ""

    $root = git rev-parse --show-toplevel 2>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Not inside a Git repository. Stop." -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host "Unstaging all staged files..." -ForegroundColor Cyan
    git restore --staged .

    Write-Host "`nStatus:" -ForegroundColor Cyan
    $status = git status --short
    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Host "Working tree clean." -ForegroundColor Green
    } else {
        git status --short
    }

    Write-Host ""
}

function ghelp {
    Write-Host ""
    Write-Host "Custom Git commands:" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "gwhere       " -NoNewline -ForegroundColor Yellow
    Write-Host "- show current folder and Git root"

    Write-Host "gcheck       " -NoNewline -ForegroundColor Yellow
    Write-Host "- full repo check: root, branch, remote, status"

    Write-Host "gstage       " -NoNewline -ForegroundColor Yellow
    Write-Host "- git add . with status before/after"

    Write-Host "gcommit msg  " -NoNewline -ForegroundColor Yellow
    Write-Host "- commit staged files with message"

    Write-Host "gsave msg    " -NoNewline -ForegroundColor Yellow
    Write-Host "- add all + commit with message"

    Write-Host "gpush        " -NoNewline -ForegroundColor Yellow
    Write-Host "- push current branch"

    Write-Host "gsetup url   " -NoNewline -ForegroundColor Yellow
    Write-Host "- setup main branch, origin remote, and first push"

    Write-Host "glog         " -NoNewline -ForegroundColor Yellow
    Write-Host "- show last 10 commits"

    Write-Host "gundo-stage  " -NoNewline -ForegroundColor Yellow
    Write-Host "- unstage all staged files"

    Write-Host "ghelp        " -NoNewline -ForegroundColor Yellow
    Write-Host "- show this help"

    Write-Host ""
    Write-Host "Safe workflow:" -ForegroundColor Cyan
    Write-Host "gcheck"
    Write-Host "gsave `"docs: update readme`""
    Write-Host "gpush"

    Write-Host ""
    Write-Host "New repository workflow:" -ForegroundColor Cyan
    Write-Host "git init"
    Write-Host "gsave `"Initial commit`""
    Write-Host "gsetup https://github.com/USERNAME/REPO.git"

    Write-Host ""
    Write-Host "Commit message examples:" -ForegroundColor Cyan
    Write-Host "gsave `"feat: add csv export`""
    Write-Host "gsave `"fix: handle missing file`""
    Write-Host "gsave `"docs: update usage examples`""
    Write-Host "gsave `"refactor: split parser logic`""
    Write-Host ""
}

function gstart {
    Write-Host ""
    Write-Host "Git Helper Commands Loaded" -ForegroundColor Cyan
    Write-Host "--------------------------" -ForegroundColor DarkGray

    Write-Host "gwhere       " -NoNewline -ForegroundColor Yellow
    Write-Host "- show current folder and Git root"

    Write-Host "gcheck       " -NoNewline -ForegroundColor Yellow
    Write-Host "- full repo check"

    Write-Host "gstage       " -NoNewline -ForegroundColor Yellow
    Write-Host "- add all changes"

    Write-Host "gcommit msg  " -NoNewline -ForegroundColor Yellow
    Write-Host "- commit staged files"

    Write-Host "gsave msg    " -NoNewline -ForegroundColor Yellow
    Write-Host "- add all + commit"

    Write-Host "gpush        " -NoNewline -ForegroundColor Yellow
    Write-Host "- push current branch"

    Write-Host "gsetup url   " -NoNewline -ForegroundColor Yellow
    Write-Host "- setup new GitHub repo"

    Write-Host "glog         " -NoNewline -ForegroundColor Yellow
    Write-Host "- show last 10 commits"

    Write-Host "gundo-stage  " -NoNewline -ForegroundColor Yellow
    Write-Host "- unstage files"

    Write-Host "ghelp        " -NoNewline -ForegroundColor Yellow
    Write-Host "- full help"

    Write-Host "--------------------------" -ForegroundColor DarkGray
    Write-Host "Safe flow: " -NoNewline -ForegroundColor Cyan
    Write-Host "gcheck -> gsave `"message`" -> gpush"

    Write-Host "New repo:  " -NoNewline -ForegroundColor Cyan
    Write-Host "git init -> gsave `"Initial commit`" -> gsetup <url>"
    Write-Host ""
}

# =========================
# Python / Dev Helper Commands
# =========================

function pvenv {
    Write-Host ""
    Write-Host "=== Python Virtual Environment Setup ===" -ForegroundColor Cyan

    if (-Not (Test-Path ".venv")) {
        Write-Host "Creating .venv..." -ForegroundColor Yellow
        python -m venv .venv

        if ($LASTEXITCODE -ne 0) {
            Write-Host "Failed to create virtual environment." -ForegroundColor Red
            Write-Host "Check that Python is installed and available as 'python'." -ForegroundColor Yellow
            Write-Host ""
            return
        }

        Write-Host ".venv created successfully." -ForegroundColor Green
    }
    else {
        Write-Host ".venv already exists." -ForegroundColor Green
    }

    $activatePath = ".\.venv\Scripts\Activate.ps1"

    if (Test-Path $activatePath) {
        Write-Host "Activating .venv..." -ForegroundColor Yellow
        & $activatePath
        Write-Host ".venv activated." -ForegroundColor Green
    }
    else {
        Write-Host "Activation script not found: $activatePath" -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host "`nUpgrading pip..." -ForegroundColor Yellow
    python -m pip install --upgrade pip

    if (Test-Path "requirements.txt") {
        Write-Host "`nrequirements.txt found." -ForegroundColor Cyan
        $install = Read-Host "Install dependencies from requirements.txt? (y/n)"

        if ($install -eq "y") {
            Write-Host "Installing dependencies..." -ForegroundColor Yellow
            pip install -r requirements.txt

            if ($LASTEXITCODE -eq 0) {
                Write-Host "Dependencies installed." -ForegroundColor Green
            }
            else {
                Write-Host "Dependency installation failed." -ForegroundColor Red
                Write-Host ""
                return
            }
        }
        else {
            Write-Host "Skipped dependency installation." -ForegroundColor DarkYellow
        }
    }
    else {
        Write-Host "`nNo requirements.txt found. Skipping dependencies." -ForegroundColor DarkYellow
    }

    Write-Host ""
    Write-Host "Done. Current Python:" -ForegroundColor Cyan
    python --version
    Write-Host ""
}

function pon {
    Write-Host ""

    $activatePath = ".\.venv\Scripts\Activate.ps1"

    if (Test-Path $activatePath) {
        & $activatePath
        Write-Host ".venv activated." -ForegroundColor Green
    }
    else {
        Write-Host ".venv not found. Run pvenv first." -ForegroundColor Red
    }

    Write-Host ""
}

function poff {
    Write-Host ""

    if (Get-Command deactivate -ErrorAction SilentlyContinue) {
        deactivate
        Write-Host ".venv deactivated." -ForegroundColor Green
    }
    else {
        Write-Host "No active virtual environment detected." -ForegroundColor Yellow
    }

    Write-Host ""
}

function preqs {
    Write-Host ""

    if (-Not (Test-Path "requirements.txt")) {
        Write-Host "requirements.txt not found." -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host "Installing dependencies from requirements.txt..." -ForegroundColor Cyan
    pip install -r requirements.txt

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Dependencies installed." -ForegroundColor Green
    }
    else {
        Write-Host "Dependency installation failed." -ForegroundColor Red
    }

    Write-Host ""
}

function pfreeze {
    Write-Host ""

    Write-Host "Saving installed packages to requirements.txt..." -ForegroundColor Cyan
    pip freeze > requirements.txt

    if ($LASTEXITCODE -eq 0) {
        Write-Host "requirements.txt updated." -ForegroundColor Green
    }
    else {
        Write-Host "Failed to update requirements.txt." -ForegroundColor Red
    }

    Write-Host ""
}

function pinstall {
    param(
        [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
        [string[]]$Packages
    )

    Write-Host ""

    if ($Packages.Count -eq 0) {
        Write-Host "Usage: pinstall package_name" -ForegroundColor Yellow
        Write-Host "Example: pinstall playwright" -ForegroundColor Yellow
        Write-Host ""
        return
    }

    Write-Host "Installing packages:" -ForegroundColor Cyan
    Write-Host ($Packages -join " ")

    pip install @Packages

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Packages installed." -ForegroundColor Green
    }
    else {
        Write-Host "Package installation failed." -ForegroundColor Red
    }

    Write-Host ""
}

function pplaywright {
    Write-Host ""
    Write-Host "=== Playwright Setup ===" -ForegroundColor Cyan

    Write-Host "Installing playwright package..." -ForegroundColor Yellow
    pip install playwright

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to install playwright package." -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host "`nInstalling Playwright browsers..." -ForegroundColor Yellow
    playwright install

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to install Playwright browsers." -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host "`nPlaywright installed successfully." -ForegroundColor Green
    Write-Host "Recommended next step:" -ForegroundColor Cyan
    Write-Host "pfreeze"
    Write-Host ""
}

function pcheck {
    Write-Host ""
    Write-Host "=== Python Project Check ===" -ForegroundColor Cyan

    Write-Host "`nCurrent folder:" -ForegroundColor Cyan
    Write-Host (Get-Location).Path

    Write-Host "`nPython:" -ForegroundColor Cyan
    python --version

    Write-Host "`nPip:" -ForegroundColor Cyan
    pip --version

    Write-Host "`nVirtual environment:" -ForegroundColor Cyan
    if (Test-Path ".venv") {
        Write-Host ".venv exists." -ForegroundColor Green
    }
    else {
        Write-Host ".venv not found." -ForegroundColor Yellow
    }

    Write-Host "`nrequirements.txt:" -ForegroundColor Cyan
    if (Test-Path "requirements.txt") {
        Write-Host "requirements.txt exists." -ForegroundColor Green
    }
    else {
        Write-Host "requirements.txt not found." -ForegroundColor Yellow
    }

    Write-Host ""
}

function phelp {
    Write-Host ""
    Write-Host "Python / Dev commands:" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "pvenv       " -NoNewline -ForegroundColor Yellow
    Write-Host "- create/activate .venv, upgrade pip, optionally install requirements"

    Write-Host "pon         " -NoNewline -ForegroundColor Yellow
    Write-Host "- activate existing .venv"

    Write-Host "poff        " -NoNewline -ForegroundColor Yellow
    Write-Host "- deactivate active virtual environment"

    Write-Host "preqs       " -NoNewline -ForegroundColor Yellow
    Write-Host "- install dependencies from requirements.txt"

    Write-Host "pfreeze     " -NoNewline -ForegroundColor Yellow
    Write-Host "- save installed packages to requirements.txt"

    Write-Host "pinstall pkg" -NoNewline -ForegroundColor Yellow
    Write-Host "- install one or more packages"

    Write-Host "pplaywright " -NoNewline -ForegroundColor Yellow
    Write-Host "- install Playwright package and browsers"

    Write-Host "pcheck      " -NoNewline -ForegroundColor Yellow
    Write-Host "- show Python, pip, .venv, and requirements status"

    Write-Host "phelp       " -NoNewline -ForegroundColor Yellow
    Write-Host "- show this Python/dev help"

    Write-Host ""
    Write-Host "Typical Python project workflow:" -ForegroundColor Cyan
    Write-Host "pvenv"
    Write-Host "pinstall playwright"
    Write-Host "playwright install"
    Write-Host "pfreeze"

    Write-Host ""
    Write-Host "Fast Playwright workflow:" -ForegroundColor Cyan
    Write-Host "pvenv"
    Write-Host "pplaywright"
    Write-Host "pfreeze"
    Write-Host ""
}

# =========================
# General Developer Helper Menu
# =========================

function devhelp {
    Write-Host ""
    Write-Host "Developer Helper Commands" -ForegroundColor Cyan
    Write-Host "-------------------------" -ForegroundColor DarkGray

    Write-Host ""
    Write-Host "Git commands:" -ForegroundColor Yellow
    Write-Host "gwhere       - show current folder and Git root"
    Write-Host "gcheck       - full repo check"
    Write-Host "gstage       - add all changes"
    Write-Host "gcommit msg  - commit staged files"
    Write-Host "gsave msg    - add all + commit"
    Write-Host "gpush        - push current branch"
    Write-Host "gsetup url   - setup new GitHub repo"
    Write-Host "glog         - show last 10 commits"
    Write-Host "gundo-stage  - unstage files"
    Write-Host "ghelp        - full Git help"

    Write-Host ""
    Write-Host "Python / Dev commands:" -ForegroundColor Yellow
    Write-Host "pvenv        - create/activate .venv"
    Write-Host "pon          - activate .venv"
    Write-Host "poff         - deactivate .venv"
    Write-Host "preqs        - install requirements.txt"
    Write-Host "pfreeze      - update requirements.txt"
    Write-Host "pinstall pkg - install packages"
    Write-Host "pplaywright  - install Playwright + browsers"
    Write-Host "pcheck       - check Python project state"
    Write-Host "phelp        - full Python/dev help"

    Write-Host ""
    Write-Host "Safe Git flow: " -NoNewline -ForegroundColor Cyan
    Write-Host "gcheck -> gsave `"message`" -> gpush"

    Write-Host "Python flow:   " -NoNewline -ForegroundColor Cyan
    Write-Host "pvenv -> pinstall package -> pfreeze"

    Write-Host "Playwright:    " -NoNewline -ForegroundColor Cyan
    Write-Host "pvenv -> pplaywright -> pfreeze"

    Write-Host ""
}

function devstart {
    devhelp
}

# Show general command list when PowerShell starts
devstart
