# Oscar Lewis 
# .zshrc using zcommet

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Clone zcomet if necessary
if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
  command git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR:-${HOME}}/.zcomet/bin
fi

# Source zcomet
source ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh

# Load a prompt
# zcomet load agkozak/agkozak-zsh-prompt
zcomet load romkatv/powerlevel10k

# Personal Options
setopt autocd

# History in zsh directory:
export HISTSIZE=12000
export SAVEHIST=10000
export HISTFILE=${ZDOTDIR:-${HOME}}/.zhistory
export HISTTIMEFORMAT="[%F %T]"
setopt hist_find_no_dups
setopt extended_history
setopt share_history

# Load some plugins
zcomet load agkozak/zsh-z
zcomet load ohmyzsh plugins/gitfast
zcomet load ohmyzsh plugins/golang

# Load a code snippet - no need to download an entire repo
zcomet snippet https://github.com/jreese/zsh-titles/blob/master/titles.plugin.zsh

# Lazy-load some plugins
zcomet trigger zhooks agkozak/zhooks
zcomet trigger zsh-prompt-benchmark romkatv/zsh-prompt-benchmark
zcomet trigger pyenv ohmyzsh plugins/pyenv

# Lazy-load Prezto's archive module without downloading all of Prezto's
# submodules
zcomet trigger --no-submodules archive unarchive lsarchive \
    sorin-ionescu/prezto modules/archive

# Load zsh-autocomplete
zcomet load marlonrichert/zsh-autocomplete

# It is good to load these popular plugins last, and in this order:
# zcomet load zsh-users/zsh-syntax-highlighting
zcomet load zdharma-continuum/fast-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions

# One line prompt
AGKOZAK_MULTILINE=0

# Run compinit and compile its cache
zcomet compinit

# To customize prompt, run `p10k configure` or edit ~/.zsh/.p10k.zsh.
[[ ! -f ~/.zsh/.p10k.zsh ]] || source ~/.zsh/.p10k.zsh
