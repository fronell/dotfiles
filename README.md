# Installation
## Linux

The steps below delete the existing configuration so be careful!

    cd ~
    git clone git@github.com:fronell/dotfiles.git
    rm -f ~/.bashrc
    rm -f ~/.bash_profile
    rm -f ~/.dircolors
    # bash_profile is sourced by login shells i.e. SSH logins
    ln -s ~/dotfiles/bash_profile .bash_profile
    # bashrc is used by interative non-login shells i.e. terminals in X
    ln -s ~/dotfiles/bash_profile .bashrc
    ln -s ~/dotfiles/dircolors .dircolors

## Windows

The steps below delete the existing configuration so be careful!

From a console with Admin rights (Admin is needed to create symlinks):

    cd %USERPROFILE%
    del .bash_profile
    del .dircolors
    git clone git@github.com:fronell/dotfiles.git
    mklink .bash_profile dotfiles\bash_profile_minigw
    mklink .dircolors dotfiles\dircolors
