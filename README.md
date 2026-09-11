# Developer Helper Commands

PowerShell shortcuts for my Git and Python workflow. PowerShell 7+ is recommended; Git and Python must be on `PATH`.

## Run

```powershell
.\install.ps1
```

The installer copies the helpers and updates your PowerShell profile. Restart PowerShell, then run `devhelp` to list commands.
For this session only, use `. .\developer-helper-commands.ps1` instead of installing.

```powershell
gcheck
gsave "feat: finish parser"
gpush
```

**`gsave` stages all changes. Inspect `gcheck` first to avoid committing unrelated files or secrets.**
Python shortcuts include `pvenv`, `pon`, `poff`, and `preqs`; use `phelp` for details.

## Uninstall

Run `.\uninstall.ps1`. It removes the installed helper and managed profile entry, not your repositories.

[MIT license](LICENSE)
