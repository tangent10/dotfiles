# Source global definitions (if any)
if [ -f /etc/bashrc ]; then
     . /etc/bashrc    # --> Read /etc/bashrc, if present.
fi

export PS1='${debian_chroot:+($debian_chroot)}\u:\W|$ '

alias ls="ls -A"

# git
export GIT_EDITOR="vim"

# wsl utils
alias clip='/mnt/c/Windows/System32/clip.exe'
alias count="wc -l"
alias pw=pwd
alias pwclip='pwd | tr "\n" " " | /mnt/c/Windows/System32/clip.exe'
alias explorer='/mnt/c/Windows/explorer.exe'

# docker crap [2021-08-29 Sun 15:08:24]
DOCKER_HOST=tcp://localhost:2375

#---------------------
# ..........
#---------------------
export PATH="$PATH:/home/ghostlapdev/.foundry/bin"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/anaconda3/condabin:$PATH"
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/ghostlapdev/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/ghostlapdev/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/ghostlapdev/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/ghostlapdev/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

function shrug()
{
  echo -n "¯\_(ツ)_/¯" | clip.exe
  echo "¯\_(ツ)_/¯"
}

. "$HOME/.cargo/env"
