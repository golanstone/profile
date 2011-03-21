# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot= }" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "${force_color_prompt= }" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
PS1='\$'

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTIGNORE="&:[ ]*:@(?|??|???|????|?????|??????|???????|????????|?????????)"
# [ \t]* ignores commands begin with !
shopt -s cmdhist


export GREP_OPTIONS='--color=auto'

# default mode
umask 002

# functions
function gcd () { mkdir -p "$@" && eval cd "\"\$$#\""; }
function calc () { awk "BEGIN {print ($*) }"; }
function mx() { awk 'BEGIN{getline; mx=$1;} { if($1>mx){mx=$1;} } END{ print mx; }' -; }
function mn() { awk 'BEGIN{getline; mn=$1;} { if($1<mn){mn=$1;} } END{ print mn; }' -; }
function sm() { awk 'BEGIN{sm=0;} {sm+=$1;} END {print sm;}' -; }
function max() { if [ $# -eq 0 ]; then mx; else echo "$@" | tr ' ' '\n' | mx; fi }
function min() { if [ $# -eq 0 ]; then mn; else echo "$@" | tr ' ' '\n' | mn; fi }
function sum() { if [ $# -eq 0 ]; then sm; else echo "$@" | tr ' ' '\n' | sm; fi }

# chr() - converts decimal value to its ASCII character representation
# ord() - converts ASCII character to its decimal value
function chr() { printf \\$(printf '%03o' $1); }
function ord() { printf '%d' "'$1"; }
# faster version as it avoids a subshell
# function chr () { printf \\$(($1/64*100+$1%64/8*10+$1%8)); } 

# hex() - converts ASCII character to a hexadecimal value
# unhex() - converts a hexadecimal value to an ASCII character
function hex() { printf '%x' "'$1"; }
function unhex() { printf \\x"$1"; }

function extract () 
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xvjf $1     ;;
            *.tar.gz)   tar xvzf $1     ;;
            *.bz2)      bunzip2 $1      ;;
            *.rar)      unrar x $1      ;;
            *.gz)       gunzip $1       ;;
            *.tar)      tar xvf $1      ;;
            *.tbz2)     tar xvjf $1     ;;
            *.tgz)      tar xvzf $1     ;;
            *.zip)      unzip $1        ;;
            *.Z)        uncompress $1   ;;
            *.7z)       7z x $1         ;;
            *)          echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file";
    fi
}

function sel() {
    target="$1"
    cmdexpr="-n"
    lastline=0
    shift
    for i in "$@"; do
        cmdexpr="$cmdexpr -e '${i}p'"
        if [ "$i" -gt "$lastline" ]; then
            lastline="$i"
        fi
    done
    cmdexpr="$cmdexpr -e '${lastline}q'"
    eval "cat -n $target | sed $cmdexpr"
}

# alias
alias nau='nautilus'
alias l='ls -hls'      # show detailed info
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias h='history'
alias p='ps -ef'

alias g='gcd'
alias e='exit'
alias s='screen'
alias r='screen -D -R'
alias f='pushd'
alias b='popd'
alias d='dirs -v'

alias gdb='libtool --mode=execute gdb'
alias pdb='python -m pdb'
alias smth='luit -encoding gbk telnet bbs.newsmth.net'

# options
set -o emacs
set -o nounset 
shopt -s extglob
shopt -s cdable_vars



#######################################################
# options and properties at chm-laptop@home
#######################################################

# names 
poj=/media/Documents/Programming/algo/poj/
stl=/media/Documents/Programming/cpp/stl/
coq=/media/Documents/Research/language
ac=/media/Documents/Active
wm=/media/Documents/Research/watermark
doc=/media/Documents/Document
eng=/media/Documents/English/notes
nlp=/media/Documents/Research/nlp


# path
PATH=$PATH:~/hadoop/bin:/home/chm/software/apache-maven-3.0.2/bin
JAVA_PATH=/usr/lib/jvm/java-6-sun

# hadoop
export HADOOP_CONF_DIR=/home/chm/hadoop/conf
export HADOOP_HOME=/home/chm/hadoop

alias g42='luit -encoding gbk ssh -o GSSAPIAuthentication=no root@10.10.123.42'
alias g3='luit -encoding gbk ssh -o GSSAPIAuthentication=no root@10.10.123.3'
alias ghadoop='luit -encoding gbk ssh -o GSSAPIAuthentication=no ime@10.12.11.200'
alias gdev='luit -encoding gbk ssh -o GSSAPIAuthentication=no root@10.10.65.75'
alias scp='scp -o GSSAPIAuthentication=no'
