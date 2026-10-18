# Run from the repo folder:  .\install.ps1
$repo = $PSScriptRoot

# 1. Install tools
$packages = @(
    "JanDeDobbeleer.OhMyPosh",
    "eza-community.eza",
    "DEVCOM.JetBrainsMonoNerdFont",
    "Microsoft.PowerShell",
    "Git.Git"
)
foreach ($p in $packages) {
    winget install --id $p -e --accept-source-agreements --accept-package-agreements
}

# 2. Oh My Posh themes -> home folder
Copy-Item "$repo\themes\*.omp.json" $HOME -Force

# 3. PowerShell profile (backs up the existing one first)
$profileDir = Split-Path $PROFILE
New-Item -ItemType Directory -Force $profileDir | Out-Null
if (Test-Path $PROFILE) { Copy-Item $PROFILE "$PROFILE.bak" -Force }
Copy-Item "$repo\Microsoft.PowerShell_profile.ps1" $PROFILE -Force

# 4. Windows Terminal settings (backs up the existing one first)
$wt = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $wt) { Copy-Item $wt "$wt.bak" -Force }
Copy-Item "$repo\windows-terminal\settings.json" $wt -Force

Write-Host "Done. Close and reopen your terminal." -ForegroundColor Green