bindkey -v
HISTSIZE=200
SAVEHIST=200
HISTFILE=~/.history
export PATH=/usr/local/Cellar/python/2.7.1/bin:$PATH # use brew python2.7
export PATH=/usr/local/bin:/usr/local/sbin:$PATH # give brew priority
export PATH=/usr/local/share/npm/bin:$PATH # for npm, I have to write a
                                          # bootstrap script because it's
                                          # specific to a virtualenv
export PATH=/Users/Fandekasp/.gem/ruby/1.8/bin:$PATH # for gem
export PYTHONPATH=/usr/local/lib/python:$PYTHONPATH # for SIP, used by PyQt4
export EDITOR="/usr/local/bin/mvim -f"  # use MacVim for the commits
export MANPATH="/usr/local/Cellar/node/0.2.6/share/man" # for man

export WORKON_HOME=$HOME/Envs
#export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python # use brew python2.7
source virtualenvwrapper.sh
export VMAIL_VIM=mvim
PATH=$PATH:/opt/symas/bin:$HOME/bin
export PATH
MANPATH=/opt/symas/share/man:$MANPATH
export MANPATH



#### ALIASES ######
alias ls="ls -G"
alias ll="ls -Gl"
alias firefox="/Applications/Firefox.app/Contents/MacOS/firefox-bin -ProfileManager"
# open a file in a new tab of the latest MacVim window opened.
# if problem of sorting, pipe to 'sort' after the tail
alias vim="mvim --servername `mvim --serverlist|tail -1` --remote-tab-silent"
# git Aliases
alias gb="git branch"
alias gba="git branch -a"
alias gc="git commit -v"
alias gd="git diff | mvim"
alias gl="git pull"
alias gp="git push"
alias gst="git status"
alias gg="git grep"
# project aliases
alias jap="cd ~/Documents/Programming/Python/learn_japanese"
alias dream="cd ~/Documents/Programming/Python/LucidDreamingBox"
alias aquasys="cd ~/Documents/Programming/aquasys"


#### ALIASES AQUASYS
alias ssh-projects="ssh adrien.lemaire@projects.aquasys.co.jp"
alias ssh-services-test="ssh adrien.lemaire@services-test.aquasys.co.jp"
alias ssh-www="ssh adrien.lemaire@www.aquasys.co.jp"

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


#compdef manage.py

typeset -ga nul_args
nul_args=(
  '--settings=-[the python path to a settings module]:file:_files'
  '--pythonpath=-[a directory to add to the python path]::directory:_directories'
  '--traceback[print traceback on exception]'
  "--version[show program's version number and exit]"
  {-h,--help}'[show this help message and exit]'
)

_managepy-adminindex(){
    _arguments -s : \
        $nul_args \
        '*::directory:_directories' && ret=0
}

_managepy-createcachetable(){
    _arguments -s : \
        $nul_args && ret=0
}

_managepy-dbshell(){
    _arguments -s : \
        $nul_args && ret=0
}

_managepy-diffsettings(){
    _arguments -s : \
        $nul_args && ret=0
}

_managepy-dumpdata(){
    _arguments -s : \
        '--format=-[specifies the output serialization format for fixtures]:format:(json yaml xml)' \
        '--indent=-[specifies the indent level to use when pretty-printing output]:' \
        $nul_args \
        '*::appname:_applist' && ret=0
}

_managepy-flush(){
    _arguments -s : \
        '--verbosity=-[verbosity level; 0=minimal output, 1=normal output, 2=all output]:Verbosity:((0\:minimal 1\:normal 2\:all))' \
        '--noinput[tell Django to NOT prompt the user for input of any kind]' \
        $nul_args && ret=0
}

_managepy-help(){
    _arguments -s : \
        '*:command:_managepy_cmds' \
        $nul_args && ret=0
}

_managepy_cmds(){
    local line
    local -a cmd
    _call_program help-command ./manage.py help \
        |& sed -n '/^ /s/[(), ]/ /gp' \
        | while read -A line; do cmd=($line $cmd) done
    _describe -t managepy-command 'manage.py command' cmd
}

_managepy-inspectdb(){
    _arguments -s : \
        $nul_args && ret=0
}

_managepy-loaddata(){
    _arguments -s : \
        '--verbosity=-[verbosity level; 0=minimal output, 1=normal output, 2=all output]:Verbosity:((0\:minimal 1\:normal 2\:all))' \
        '*::file:_files' \
        $nul_args && ret=0
}

_managepy-reset(){
  _arguments -s : \
    '--noinput[tells Django to NOT prompt the user for input of any kind.]' \
    '*::appname:_applist' \
    $nul_args && ret=0
}

_managepy-runfcgi(){
  local state
  
  local fcgi_opts
  fcgi_opts=(
    'protocol[fcgi, scgi, ajp, ... (default fcgi)]:protocol:(fcgi scgi ajp)'
    'host[hostname to listen on..]:'
    'port[port to listen on.]:'
    'socket[UNIX socket to listen on.]::file:_files'
    'method[prefork or threaded (default prefork)]:method:(prefork threaded)'
    'maxrequests[number of requests a child handles before it is killed and a new child is forked (0 = no limit).]:'
    'maxspare[max number of spare processes / threads.]:'
    'minspare[min number of spare processes / threads.]:'
    'maxchildren[hard limit number of processes / threads.]:'
    'daemonize[whether to detach from terminal.]:boolean:(False True)'
    'pidfile[write the spawned process-id to this file.]:file:_files'
    'workdir[change to this directory when daemonizing.]:directory:_files'
    'outlog[write stdout to this file.]:file:_files'
    'errlog[write stderr to this file.]:file:_files'
  )
  
  _arguments -s : \
    $nul_args \
    '*: :_values "FCGI Setting" $fcgi_opts' && ret=0
}

_managepy-runserver(){
  _arguments -s : \
    '--noreload[tells Django to NOT use the auto-reloader.]' \
    '--adminmedia[specifies the directory from which to serve admin media.]:directory:_files' \
    $nul_args && ret=0
}

_managepy-shell(){
  _arguments -s : \
    '--plain[tells Django to use plain Python, not IPython.]' \
    $nul_args && ret=0
}

_managepy-sql(){}
_managepy-sqlall(){}
_managepy-sqlclear(){}
_managepy-sqlcustom(){}
_managepy-sqlflush(){}
_managepy-sqlindexes(){}
_managepy-sqlinitialdata(){}
_managepy-sqlreset(){}
_managepy-sqlsequencereset(){}
_managepy-startapp(){}

_managepy-syncdb() {
  _arguments -s : \
    '--verbosity=-[verbosity level; 0=minimal output, 1=normal output, 2=all output.]:Verbosity:((0\:minimal 1\:normal 2\:all))' \
    '--noinput[tells Django to NOT prompt the user for input of any kind.]' \
    $nul_args && ret=0
}

_managepy-test() {
  _arguments -s : \
    '--verbosity=-[verbosity level; 0=minimal output, 1=normal output, 2=all output.]:Verbosity:((0\:minimal 1\:normal 2\:all))' \
    '--noinput[tells Django to NOT prompt the user for input of any kind.]' \
    '*::appname:_applist' \
    $nul_args && ret=0
}

_managepy-testserver() {
  _arguments -s : \
    '--verbosity=-[verbosity level; 0=minimal output, 1=normal output, 2=all output.]:Verbosity:((0\:minimal 1\:normal 2\:all))' \
    '--addrport=-[port number or ipaddr:port to run the server on.]' \
    '*::fixture:_files' \
    $nul_args && ret=0
}

_managepy-validate() {
  _arguments -s : \
    $nul_args && ret=0
}

_managepy-commands() {
  local -a commands
  
  commands=(
    'adminindex:prints the admin-index template snippet for the given app name(s).'
    'createcachetable:creates the table needed to use the SQL cache backend.'
    'dbshell:runs the command-line client for the current DATABASE_ENGINE.'
    "diffsettings:displays differences between the current settings.py and Django's default settings."
    'dumpdata:Output the contents of the database as a fixture of the given format.'
    'flush:Executes ``sqlflush`` on the current database.'
    'help:manage.py help.'
    'inspectdb:Introspects the database tables in the given database and outputs a Django model module.'
    'loaddata:Installs the named fixture(s) in the database.'
    'reset:Executes ``sqlreset`` for the given app(s) in the current database.'
    'runfcgi:Run this project as a fastcgi (or some other protocol supported by flup) application,'
    'runserver:Starts a lightweight Web server for development.'
    'shell:Runs a Python interactive interpreter.'
    'sql:Prints the CREATE TABLE SQL statements for the given app name(s).'
    'sqlall:Prints the CREATE TABLE, custom SQL and CREATE INDEX SQL statements for the given model module name(s).'
    'sqlclear:Prints the DROP TABLE SQL statements for the given app name(s).'
    'sqlcustom:Prints the custom table modifying SQL statements for the given app name(s).'
    'sqlflush:Returns a list of the SQL statements required to return all tables in the database to the state they were in just after they were installed.'
    'sqlindexes:Prints the CREATE INDEX SQL statements for the given model module name(s).'
    "sqlinitialdata:RENAMED: see 'sqlcustom'"
    'sqlreset:Prints the DROP TABLE SQL, then the CREATE TABLE SQL, for the given app name(s).'
    'sqlsequencereset:Prints the SQL statements for resetting sequences for the given app name(s).'
    "startapp:Creates a Django app directory structure for the given app name in this project's directory."
    "syncdb:Create the database tables for all apps in INSTALLED_APPS whose tables haven't already been created."
    'test:Runs the test suite for the specified applications, or the entire site if no apps are specified.'
    'testserver:Runs a development server with data from the given fixture(s).'
    'validate:Validates all installed models.'
  )
  
  _describe -t commands 'manage.py command' commands && ret=0
}

_applist() {
  local line
  local -a apps
  _call_program help-command "python -c \"import os.path as op, re, settings, sys;\\
                                          bn=op.basename(op.abspath(op.curdir));[sys\\
                                          .stdout.write(str(re.sub(r'^%s\.(.*?)$' %
                                          bn, r'\1', i)) + '\n') for i in settings.\\
                                          INSTALLED_APPS if re.match(r'^%s' % bn, i)]\"" \
                             | while read -A line; do apps=($line $apps) done
  _values 'Application' $apps && ret=0
}

_managepy() {
  local curcontext=$curcontext ret=1
  
  if ((CURRENT == 2)); then
    _managepy-commands
  else
    shift words
    (( CURRENT -- ))
    curcontext="${curcontext%:*:*}:managepy-$words[1]:"
    _call_function ret _managepy-$words[1]
  fi
}

_managepy "$@"

## fixme - the load process here seems a bit bizarre

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

WORDCHARS=''

autoload -U compinit
compinit -i

zmodload -i zsh/complist

## case-insensitive (all),partial-word and then substring completion
if [ "x$CASE_SENSITIVE" = "xtrue" ]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unset CASE_SENSITIVE
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi

zstyle ':completion:*' list-colors ''

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# Load known hosts file for auto-completion with ssh and scp commands
if [ -f ~/.ssh/known_hosts ]; then
  zstyle ':completion:*' hosts $( sed 's/[, ].*$//' $HOME/.ssh/known_hosts )
  zstyle ':completion:*:*:(ssh|scp):*:*' hosts `sed 's/^\([^ ,]*\).*$/\1/' ~/.ssh/known_hosts`
fi

