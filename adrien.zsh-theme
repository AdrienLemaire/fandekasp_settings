
autoload -Uz vcs_info


# set some colors
for COLOR in BLUE RED GREEN YELLOW WHITE BLACK CYAN; do
    eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'
    eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
PR_RESET="%{${reset_color}%}";

# Checks if working tree is dirty
+vi-parse_git_dirty() {
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo ""
  fi
}
+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+='T'
    fi
}
#
# Show remote ref name and number of commits ahead-of or behind
function +vi-git-st() {
    local ahead behind remote
    local -a gitstatus

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    if [[ -n ${remote} ]] ; then
        # for git prior to 1.7
        # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
        ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l | sed 's/[^[:digit:]]//g')
        (( $ahead )) && gitstatus+=( "${c3}+${ahead}${c2}" )

        # for git prior to 1.7
        # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l | sed 's/[^[:digit:]]//g')
        (( $behind )) && gitstatus+=( "${c4}-${behind}${c2}" )
        if [ ${ahead} != 0 ] || [ ${behind} != 0 ] ; then
            #hook_com[revision]="${hook_com[revision]}...[${remote} ${(j:/:)gitstatus}]"
            hook_com[branch]="${hook_com[branch]}[${remote} ${(j:/:)gitstatus}]"
        else
            hook_com[branch]="${hook_com[branch]}${ZSH_THEME_GIT_PROMPT_CLEAN}"
        fi
    fi
}




# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stangedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
ZSH_THEME_GIT_PROMPT_DIRTY=" ${PR_RED}%B✘${PR_YELLOW}"
ZSH_THEME_GIT_PROMPT_CLEAN=" ${PR_GREEN}✔${PR_YELLOW}"
ZSH_THEME_GIT_PROMPT_AHEAD="YES"
FMT_BRANCH="${PR_RED}‹%b ${PR_YELLOW}%5.5i...%u${PR_RED}›${PR_YELLOW}%c%m${PR_RESET}" # e.g. master¹²
FMT_ACTION="(${PR_CYAN}%a${PR_RESET}%)"   # e.g. (rebase-i)
FMT_PATH="${PR_YELLOW}%R/%S"              # e.g. ~/repo/subdir

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' get-revision true
zstyle ':vcs_info:*:prompt:*' unstagedstr '¹'  # display ¹ if there are unstaged changes
zstyle ':vcs_info:*:prompt:*' stagedstr '²'    # display ² if there are staged changes
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}" "${FMT_PATH}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"              "${FMT_PATH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""                             "%~"
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-st #parse_git_dirty

function precmd {
    vcs_info 'prompt'
    [[ -n $vcs_info_msg_0_ ]] && psvar[1]="$vcs_info_msg_0_"
}





function lprompt {
    local brackets=$1
    local color1=$2
    local color2=$3

    local bracket_open="${color1}${brackets[1]}${PR_RESET}"
    local bracket_close="${color1}${brackets[2]}"

    local git='$vcs_info_msg_0_'
    local cwd="${color2}%B%1~%b"

    PROMPT="╭─${PR_RESET}${git}${PR_RESET}
╰─%B${PR_BLUE}-(${PR_YELLOW}%T${PR_BLUE})-${PR_RESET}$%b "
}

function rprompt {
    local brackets=$1
    local color1=$2
    local color2=$3

    local bracket_open="${color1}${brackets[1]}${PR_RESET}"
    local bracket_close="${color1}${brackets[2]}${PR_RESET}"
    local colon="${PR_YELLOW}:"
    local at="${color1}@${PR_RESET}"

    local user_host="${color2}%n${at}${color2}%m"
    local vcs_cwd='${${vcs_info_msg_1_%%.}/$HOME/~}'
    local cwd="${color2}%B%20<..<${vcs_cwd}%<<%b"
    local inner="${user_host}${colon}${cwd}"

    RPROMPT="${PR_RESET}${bracket_open}${inner}${bracket_close}${PR_RESET}"
}

lprompt '[]' $BR_BRIGHT_BLACK $PR_WHITE
rprompt '()' $BR_BRIGHT_BLACK $PR_WHITE

