bindkey -v
HISTSIZE=200
SAVEHIST=200
HISTFILE=~/.history
export PATH=/usr/local/Cellar/python/2.7.1/bin:$PATH # use brew python2.7
export PATH=/usr/local/bin:/usr/local/sbin:$PATH # give brew priority
export PYTHONPATH=/usr/local/lib/python:$PYTHONPATH # for SIP, used by PyQt4
export EDITOR="/usr/local/bin/mvim -f"  # use MacVim for the commits
export WORKON_HOME=$HOME/Envs
#export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python # use brew python2.7
source virtualenvwrapper.sh



#### ALIASES ######
alias ls="ls -G"
alias ll="ls -Gl"
# open a file in a new tab of the latest MacVim window opened
alias vim="mvim --servername `mvim --serverlist|tail -1` --remote-tab-silent"
# git Aliases
alias gb="git branch"
alias gba="git branch -a"
alias gc="git commit -v"
alias gd="git diff | mvim"
alias gl="git pull"
alias gp="git push"
alias gst="git status"
# project aliases
alias jap="cd ~/Documents/Programming/Python/learn_japanese"
alias dream="cd ~/Documents/Programming/Python/LucidDreamingBox"

## PostgreSQL paths
#PATH=/opt/local/lib/postgresql90/bin:$PATH
## PostgreSQL start/stop aliases
#PG_DIR=/opt/local/lib/postgresql90
##DATA_DIR=/Volumes/Data/Users/Pavel/Databases/PostgreSQL
#DATA_DIR=/opt/local/var/db/postgresql90/
#LOG_FILE=/var/log/postgresql.log
#alias pgsql-start="sudo su postgres -c \"$PG_DIR/bin/pg_ctl start -D $DATA_DIR
#-l $LOG_FILE\""
#alias pgsql-stop="sudo su postgres -c \"$PG_DIR/bin/pg_ctl stop -D $DATA_DIR
#-l $LOG_FILE\""


has_virtualenv() {
    if [ -e .venv ]; then
        workon `cat .venv`
    fi
}
venv_cd() {
    cd "$@" && has_virtualenv #&& has_gitbranch
}
alias cd="venv_cd"



# Force 'sudo zsh' to start root as a loging shell to 
# avoid problems with environment clashes:
function sudo {
    if [[ $1 = "zsh" ]]; then
        command sudo /bin/zsh -l
    else
        command sudo "$@"
    fi
}



setprompt () {
    ###
    # Need this so the prompt will work.

    setopt prompt_subst


    ###
    # See if we can use colors.

    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
    done
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"


    ###
    # See if we can use extended characters to look nicer.
    
    typeset -A altchar
    set -A altchar ${(s..)terminfo[acsc]}
    PR_SET_CHARSET="%{$terminfo[enacs]%}"
    PR_SHIFT_IN="%{$terminfo[smacs]%}"
    PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
    PR_HBAR=${altchar[q]:--}
    PR_ULCORNER=${altchar[l]:--}
    PR_LLCORNER=${altchar[m]:--}
    PR_LRCORNER=${altchar[j]:--}
    PR_URCORNER=${altchar[k]:--}

    
    ###
    # Decide if we need to set titlebar text.
    
    case $TERM in
    xterm*)
        PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
        ;;
    screen)
        PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
        ;;
    *)
        PR_TITLEBAR=''
        ;;
    esac
    
    
    ###
    # Decide whether to set a screen title
    if [[ "$TERM" == "screen" ]]; then
    PR_STITLE=$'%{\ekzsh\e\\%}'
    else
    PR_STITLE=''
    fi
    
    
    ###
    # APM detection
    
    if which ibam > /dev/null; then
    PR_APM='$PR_RED${${PR_APM_RESULT[(f)1]}[(w)-2]}%%(${${PR_APM_RESULT[(f)3]}[(w)-1]})$PR_LIGHT_BLUE:'
    elif which apm > /dev/null; then
    PR_APM='$PR_RED${PR_APM_RESULT[(w)5,(w)6]/\% /%%}$PR_LIGHT_BLUE:'
    else
    PR_APM=''
    fi
    
    
    ###
    # Finally, the prompt.

    PROMPT='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
$PR_CYAN$PR_SHIFT_IN$PR_ULCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
$PR_GREEN%(!.%SROOT%s.%n)$PR_GREEN@%m:%l\
$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_HBAR${(e)PR_FILLBAR}$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
$PR_MAGENTA%$PR_PWDLEN<...<%~%<<\
$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_URCORNER$PR_SHIFT_OUT\

$PR_CYAN$PR_SHIFT_IN$PR_LLCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
%(?..$PR_LIGHT_RED%?$PR_BLUE:)\
${(e)PR_APM}$PR_YELLOW%D{%H:%M}\
$PR_LIGHT_BLUE:%(!.$PR_RED.$PR_WHITE)%#$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_NO_COLOUR '

    RPROMPT=' $PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
($PR_YELLOW%D{%a,%b%d}$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'

    PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$PR_LIGHT_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '
}

setprompt

# If I am using vi keys, I want to know what mode I'm currently using.
# zle-keymap-select is executed every time KEYMAP changes.
# From http://zshwiki.org/home/examples/zlewidgets
function zle-keymap-select {
    VIMODE="${${KEYMAP/vicmd/ M:command}/(main|viins)/}"
    zle reset-prompt
}
zle -N zle-keymap-select

# Keeps the paths from growing too big
    
    typeset -U path manpath fpath

# Key bindings

bindkey '^L' push-input 
bindkey '\e[A'  history-search-backward 
bindkey '\e[B'  history-search-forward

# Make sure ~/.zlogin is always read if it exists

if [[ -f ~/.zlogin ]];then
    source ~/.zlogin
fi


