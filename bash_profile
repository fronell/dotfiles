# Java
export JAVA_HOME=/usr/local/bin/java

# Sudo prompt
export SUDO_PS1="[ROOT! \W]# "

# Path
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# Disable known hosts prompt
alias sssh='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

# Set our default editor
export EDITOR=vim

# Load ssh private key passphrase into memory
# Reference: http://www.benknowscode.com/2012/09/using-password-protected-keys-in-linux_8145.html
function loadsshkey()
{
 eval `ssh-agent`
 ssh-add .ssh/id_rsa
}

# Prevent history getting overwritten from multipel bash sessions
shopt -s histappend
PROMPT_COMMAND='history -a'

# Keeps multiline commands together in the history
shopt -s cmdhist

# Allows for spelling mistakes when cd'ing to a directory
shopt -s cdspell

# Env specific settings
unamestr=`uname`
if [[ "$unamestr" == 'Darwin' ]]; then
  export CLICOLOR=1
  export LSCOLORS="ExGxFxDxCxDxDxhbhdacEc"

  alias diff='colordiff'
  alias grep='grep --color=auto'
elif [[ "$unamestr" == 'Linux' ]]; then
  # enable color support of ls and also add handy aliases (only for Linux)
  # Reference: https://github.com/nandykins/gentoo-conf/blob/master/.bashrc
  if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias diff='colordiff'
  
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
  fi
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Sets the prompt including git or svn info
. ~/dotfiles/git_svn_bash_prompt
