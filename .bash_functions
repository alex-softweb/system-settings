#! /usr/bin/env bash

# ruby
heroku-push() { gps -r heroku $@ m; heroku run rake db:migrate; }
delayed-emails() { rake jobs:clear; rake jobs:work; }

# bash
on-mac() { [[ $(uname) == 'Darwin' ]] && echo true; }
on-docker() { [ $HOME == '/home/docker' ] && echo true; }
on-vagrant() { [ $HOME == '/home/vagrant' ] && echo true; }
add_to_path() { [[ $PATH != *$1* ]] && PATH=$PATH:$1; }
dpks() { cmd="dpkg --get-selections | grep $1"; echo $cmd; eval $cmd; }
pag() { cmd="ps aux | grep $1 | grep -v grep"; echo $cmd; eval $cmd; }
pagm() { cmd="ps aux --sort -rss | less"; echo $cmd; eval $cmd; }
les() { $@ | less; }
hel() { $@ --help; }
xin() { $@ | xclip -selection clipboard; }
hss() { ssh $1@192.168.6.$2; }
vnc() { vncviewer 192.168.6.$1 ; }
rmt() { mv $1 ~/.trash; }
brk() { sleep $@; notify-send -u critical 'Break!!'; }
automux_installed() { gem list | grep automux 1> /dev/null; }

# git
gcm() { git commit -m "$(echo $@)"; }
ggrp() { cmd="git log --oneline --grep='$@'"; echo $cmd; eval $cmd; }
gstshow() { git stash show -p stash@{$1} $2; }
gstapply() { git stash apply stash@{$1} $2; }
gcr() { git branch $1 origin/$1; }
g-clone() { git clone git://github.com/$1.git; }
g-author() { git commit --amend --reset-author; }
g-set-upstream() { git branch --set-upstream $1 origin/$1; }

gaf() {
  git add -f $@

  printf '\033[0;34m'
  echo '              ***###***'
  printf '\033[0m'

  git status
  git diff --cached
}

# misc

dump-development-db() {
  if [ $1 ]; then
    db_path=$1
  else
    db_path=$HOME/gitbasket/db/$(development-db-name).sql
  fi

  pg_dump $(development-db-name) > $db_path
}
load-development-db() {
  if [ $1 ]; then
    db_path=$1
  else
    db_path=~/gitbasket/db/$(development-db-name).sql
  fi

  rake db:drop RAILS_ENV=development; rake db:create; psql $(development-db-name) < $db_path
}

vga-connect() {
  if [[ $1 == 'r' ]]; then
    direction='right'
  else
    direction='left'
  fi

  xrandr --output HDMI1 --off; xrandr --output VGA1 --auto --$direction-of eDP1; xmodmap ~/.Xmodmap
}

rr() {
  if [ $@ ]; then
    rake routes CONTROLLER=$@
  else
    rake routes
  fi
}

set-rvm-gemset() {
  if [ -e .ruby-version ] && [ -e .ruby-gemset ]; then
    rvm use $(cat .ruby-version)@$(cat .ruby-gemset) 2> /dev/null
  fi
}

if $(on-mac)
then
  ntf() { $@; terminal-notifier-notify -message 'Process finished...'; tmux display-message 'Process finished...'; }
else
  ntf() { $@; notify-send -t 3000 'Process finished...'; }
fi
