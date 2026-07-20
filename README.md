# Developer Helper Commands

A focused PowerShell toolkit for the Git and Python workflows used across my projects.

## Commands

| Area | Commands | Purpose |
|---|---|---|
| Git | `gwhere`, `gcheck`, `gstage`, `gcommit`, `gsave`, `gpush`, `gsetup`, `glog` | Repository inspection and daily save/push workflow |
| Python | `pvenv`, `pon`, `poff`, `preqs`, `pfreeze`, `pinstall`, `pplaywright`, `pcheck` | Virtual environments and dependency management |
| Help | `ghelp`, `phelp`, `devhelp`, `devstart` | Discover available helpers |

## Install

Run PowerShell from this repository:

```powershell
.\install.ps1
```

The installer copies the helper script into a stable directory and adds one guarded source line to your PowerShell profile. Restart PowerShell, then run:

```powershell
devhelp
gcheck
```

## Manual use

Source the script only for the current session:

```powershell
. .\developer-helper-commands.ps1
```

## Typical workflow

```powershell
gcheck
gsave "feat: finish parser"
gpush
```

`gsave` stages all changes in the current repository. Always inspect `gcheck` first so generated files or unrelated edits are not committed accidentally.

## Uninstall

```powershell
.\uninstall.ps1
```

The uninstaller removes the managed profile entry and installed helper script. It does not delete this repository or any Git data.

## Requirements

- PowerShell 7+ recommended
- Git available on `PATH`
- Python available on `PATH` for Python helpers

## License

MIT
