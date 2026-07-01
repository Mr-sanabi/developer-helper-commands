# Developer Helper Commands

PowerShell helper commands for Git, Python virtual environments, and local development workflow.

## Features

- Git helper commands
- Python virtual environment setup
- Requirements management
- Playwright setup helper
- Separate Git and Python/dev menus

## Git Commands

- `gcheck` — check repository status
- `gsave "message"` — add all changes and commit
- `gpush` — push current branch
- `gsetup <url>` — connect GitHub remote and push main branch
- `glog` — show recent commits
- `ghelp` — show Git command menu

## Python / Dev Commands

- `pvenv` — create and activate `.venv`
- `pon` — activate existing `.venv`
- `poff` — deactivate active environment
- `preqs` — install dependencies from `requirements.txt`
- `pfreeze` — save installed packages to `requirements.txt`
- `pinstall <package>` — install package and update requirements
- `pplaywright` — install Playwright and browser binaries
- `pcheck` — show Python project status
- `phelp` — show Python/dev menu

## General Commands

- `devhelp` — show Git and Python/dev command overview
- `devstart` — show startup helper menu

## Usage

Add the script content to your PowerShell profile, or source it manually:

```powershell
. .\developer-helper-commands.ps1ы

Then run:

devhelp
Example Workflow

New Python project:

pvenv
pinstall playwright
pplaywright

Git workflow:

gcheck
gsave "feat: add helper commands"
gpush

Потом Git flow:

```powershell
git init
gcheck
gsave "Initial developer helper commands"