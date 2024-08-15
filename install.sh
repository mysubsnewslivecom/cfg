#!/bin/bash

function log(){
    # Ansi color code variables
    red="\e[0;91m"
    blue="\e[0;94m"
    # expand_bg="\e[K"
    # blue_bg="\e[0;104m${expand_bg}"
    # red_bg="\e[0;101m${expand_bg}"
    # green_bg="\e[0;102m${expand_bg}"
    green="\e[0;92m"
    white="\e[0;97m"
    bold="\e[1m"
    uline="\e[4m"
    reset="\e[0m"
    cur_date="$(date '+%d %B %Y %H:%M:%S')"
    message="$1"
    printf "❯ [${cur_date}] ${green}%s${reset}\n" "${message}"
}

function config {
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

function main(){

    git clone --bare git@gitlab.com:learn2ping/configurations/cfg.git $HOME/.cfg
    mkdir -p $HOME/.config-backup
    config checkout
    if [ $? = 0 ]; then
    log "Checked out config.";
    else
        log "Backing up pre-existing dot files.";
        config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $HOME/.config-backup/{}
    fi;
    config checkout
    config config status.showUntrackedFiles no

}

TIMEFORMAT='Elapsed time: %3lR'
time main
