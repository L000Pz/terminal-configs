Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
oh-my-posh init pwsh --config "$HOME\.config\oh-my-posh\atomic-round.omp.json" | Invoke-Expression
function ls { eza -lh --icons --tree --level=1 --group-directories-first --git --time-style=long-iso --total-size @args }
function ll { eza -l --icons --git --group-directories-first @args }
function lt { eza --tree --icons --level=2 @args }