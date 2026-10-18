# terminal-config

My Windows terminal setup in one repo: PowerShell 7 profile, Oh My Posh themes, Windows Terminal settings, and an `eza`-powered `ls` with icons. Clone it on a new machine, run one script, done.

## What's inside

```
terminal-config/
├── install.ps1                        # one-shot setup script
├── Microsoft.PowerShell_profile.ps1   # PowerShell profile (aliases, ls/ll/lt, oh-my-posh init)
├── themes/
│   ├── custom_developer.omp.json      # Oh My Posh theme
│   └── minimal_right_info.omp.json    # Oh My Posh theme
└── windows-terminal/
    └── settings.json                  # Windows Terminal font, colors, profiles
```

## What gets installed

Installed with `winget`:

| Tool | Purpose |
|---|---|
| [Oh My Posh](https://ohmyposh.dev) | Prompt theming |
| [eza](https://github.com/eza-community/eza) | Modern `ls` replacement with icons and git info |
| JetBrainsMono Nerd Font | Font that provides the icons |
| PowerShell 7 (`pwsh`) | Shell |
| Git | Version control |

## Quick start (new machine)

```powershell
winget install Git.Git
git clone https://github.com/YOUR_USERNAME/terminal-config.git
cd terminal-config
.\install.ps1
```

Then close the terminal completely and open a new one.

If PowerShell blocks the script, allow it for this session only:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
```

## What the install script does

1. Installs the tools listed above with `winget`.
2. Copies the Oh My Posh themes to your home folder (`$HOME`).
3. Copies the PowerShell profile to `$PROFILE`.
4. Copies the Windows Terminal `settings.json` into place.

Existing profile and Windows Terminal settings are backed up first as `*.bak` next to the original, so nothing gets lost.

## Commands

Defined in the PowerShell profile:

| Command | Output |
|---|---|
| `ls` | Detailed list: icons, hidden files, one item per line, directories first, no symlink targets |
| `ll` | Long format with git status |
| `lt` | Tree view, 2 levels deep |

Note: the custom `ls` returns plain text for viewing, so it can't be used in object pipelines like `ls | Where-Object ...`. Use `Get-ChildItem` for that.

## Manual setup

If you'd rather not run the script:

1. Install the tools above.
2. Copy `themes/*.omp.json` to `~`.
3. Copy `Microsoft.PowerShell_profile.ps1` to the path printed by `$PROFILE`.
4. Copy `windows-terminal/settings.json` to
   `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\`.
5. Set the terminal font to `JetBrainsMono Nerd Font Mono` if it isn't already.

## Updating the repo

After changing your live config, copy the files back into the repo and commit:

```powershell
$repo = "$HOME\terminal-config"
Copy-Item $PROFILE "$repo\Microsoft.PowerShell_profile.ps1" -Force
Copy-Item "$HOME\*.omp.json" "$repo\themes\" -Force
Copy-Item "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "$repo\windows-terminal\settings.json" -Force

cd $repo
git add .
git commit -m "Update terminal config"
git push
```

## Troubleshooting

| Problem | Fix |
|---|---|
| Icons show as empty boxes | Set the terminal font to `JetBrainsMono Nerd Font Mono` (Windows Terminal → Settings → Profiles → Defaults → Appearance). Also set it in VS Code (`terminal.integrated.fontFamily`). |
| `ls` still runs the default listing | The profile must start with `Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue`, because PowerShell aliases take priority over functions. Check with `Get-Command ls`. |
| `eza` or `oh-my-posh` not recognized | Winget updates PATH only for new sessions. Close and reopen the terminal. |
| Theme not loading | Make sure the `oh-my-posh init` line in the profile points to `$HOME\<theme>.omp.json`, not a hardcoded username path. |
| Edited the wrong profile | `pwsh` uses the path printed by `$PROFILE`. Windows PowerShell 5 uses a different one. |

## Notes

- Windows Terminal's `settings.json` can contain personal paths. Review it before making the repo public.
- The Windows Terminal path above is for the Store/winget install. The preview or unpackaged builds use a different folder.
