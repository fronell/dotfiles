#!/bin/bash
#
# DESCRIPTION:
#
#   Set the bash prompt according to:
#    * the branch/status of the current git repository
#    * the branch of the current subversion repository
#    * the return value of the previous command
# 
# USAGE:
#
#   1. Save this file as ~/.git_svn_bash_prompt
#   2. Add the following line to the end of your ~/.profile or ~/.bash_profile:
#        . ~/.git_svn_bash_prompt
#
# AUTHOR:
# 
#   Scott Woods <scott@westarete.com>
#   West Arete Computing
#
#   Based on work by halbtuerke and lakiolen.
#
#   http://gist.github.com/31967
 
 
# The various escape codes that we can use to color our prompt.
        RED="\[\033[0;31m\]"
  LIGHT_RED="\[\033[1;31m\]"
      GREEN="\[\033[0;32m\]"
LIGHT_GREEN="\[\033[1;32m\]"
       BLUE="\[\033[0;34m\]"
 LIGHT_BLUE="\[\033[0;36m\]"
     PURPLE="\[\033[1;34m\]"
     YELLOW="\[\033[0;33m\]"
      WHITE="\[\033[1;37m\]"
     VIOLET="\[\033[0;35m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"
 
# Detect whether the current directory is a git repository.
function is_git_repository {
  git branch > /dev/null 2>&1
}
 
# Detect whether the current directory is a subversion repository.
function is_svn_repository {
  test -d .svn
}
 
# Determine the branch/state information for this git repository.
function set_git_branch {
  # Capture the output of the "git status" command.
  git_status="$(git status 2> /dev/null)"
 
  # Set color based on clean/staged/dirty.
  if [[ ${git_status} =~ "working directory clean" ]]; then
    state="${GREEN}"
  elif [[ ${git_status} =~ "Changes not staged for commit" ]]; then
    state="${RED}"
  # Broke out into separate match because | wouldn't work
  elif [[ ${git_status} =~ "Untracked files" ]]; then
    state="${RED}"
  elif [[ ${git_status} =~ "Changes to be committed" ]]; then
    state="${YELLOW}"
  else
    state="${COLOR_NONE}"
  fi
  
  # Set arrow icon based on status against remote.
  if [[ ${git_status} =~ "Your branch is ahead" ]]; then
    #remote="↑"
    remote="<"
  elif [[ ${git_status} =~ "Your branch is behind" ]]; then
    #remote="↓"
    remote=">"
  elif [[ ${git_status} =~ "Your branch is up-to-date" ]]; then
    remote="="
  else
    remote="?"
  fi
 
  # Get the name of the branch.
  branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"

  # Set the final branch string.
  BRANCH="${state}[Git(${remote}${branch})]${COLOR_NONE}"
}

# Minimal function until I figure out what I want
function set_svn_branch {
  # Capture the output of the "svn status" command.
  svn_status="$(svn status 2> /dev/null)"

  # Set color based on clean/dirty.
  if [[ ${svn_status} == "" ]]; then
    state="${GREEN}"
  elif [[ ${svn_status} != "" ]]; then
    state="${RED}"
  else
    state="${COLOR_NONE}"
  fi

  # Set the final branch string.
  BRANCH="${state}[SVN]${COLOR_NONE}"
}
 
# Determine the branch information for this subversion repository. No support
# for svn status, since that needs to hit the remote repository.
#function set_svn_branch {
#  # Capture the output of the "git status" command.
#  svn_info="$(svn info | egrep '^URL: ' 2> /dev/null)"
# 
#  # Get the name of the branch.
#  branch_pattern="^URL: .*/(branches|tags)/([^/]+)"
#  trunk_pattern="^URL: .*/trunk(/.*)?$"
#  if [[ ${svn_info} =~ $branch_pattern ]]; then
#    branch=${BASH_REMATCH[2]}
#  elif [[ ${svn_info} =~ $trunk_pattern ]]; then
#    branch='trunk'
#  fi
# 
#  # Set the final branch string.
#  BRANCH="(${branch}) "
#}
 
# Shows the return status of the last command ran
# A green 0 if good, otherwise the return code in red
# It can also be used to set the $ as green or red to indicate the return status
# if we want a shorter prompt
# Reference: http://stackoverflow.com/questions/24562629/setting-a-variable-within-a-bash-ps1
function format_last_status () {
  if test $1 -eq 0 ; then
    LAST_STATUS="${VIOLET}|${GREEN}$1${VIOLET}|${COLOR_NONE}"
    # PROMPT_SYMBOL="\$"
  else
    LAST_STATUS="${VIOLET}|${RED}$1${VIOLET}|${COLOR_NONE}"
    # PROMPT_SYMBOL="${RED}\$${COLOR_NONE}"
  fi
}

# Set the full bash prompt.
function set_bash_prompt () {
  # We do this first so we don't lose the return value of the last command.
  format_last_status $?
 
  # Set the BRANCH variable.
  if is_git_repository ; then
    set_git_branch
  elif is_svn_repository ; then
    set_svn_branch
  else
    BRANCH=''
  fi
  
  # Set the terminal window titles to the PWD
  # Reference: http://superuser.com/questions/84710/window-title-in-bash
  TERMINAL_TITLE='\[\e]2;$PWD\a\]'

  # Set the bash prompt variable.
  # \w is needed to show the PWD in the prompt itself
  #PS1="$PURPLE\w\[\e]2;$PWD\a\]${BRANCH}$VIOLET[\j]$LIGHT_BLUE\$$COLOR_NONE "
  PS1="$PURPLE\w${TERMINAL_TITLE}${BRANCH}$VIOLET[\j]${LAST_STATUS}$LIGHT_BLUE\$$COLOR_NONE "
}
 
# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt
