#!/usr/bin/env bash

# Script to load DFIR tools into Ubuntu and Debian systems 
# based on the script made by Dr. Phil Polstra @ppolstra 

function install_pkg() {

    fname=${1}
    lst=$(cat $fname)

    for pkg in $lst
    do
        if (dpkg-query -l | awk '{print $2}' | egrep "^${pkg}$" 2>/dev/null) 
        then 
            echo "${pkg} already installed"
        else 
            echo -n "[*] Trying to install ${pkg}..." 
            if (apt-get -y install ${pkg} 2>/dev/null)  
            then 
                echo "[+] Succeeded!"
            else
                echo "[!] Failed!" 
            fi
        fi
    done 
}

function add_repo() {

    repo_path=${1}
    keyserver=${2}

    cp *.list ${repo_path} 
    gpg --keyserver ${keyserver}--recv 6AF0E1940624A220
    gpg --armor --export 6AF0E1940624A220 | sudo apt-key add -
    gpg --keyserver ${keyserver} --recv B2A668DD0744BEC3
    gpg --armor --export B2A668DD0744BEC3 | sudo apt-key add -
}

function main() {

    filename="pkglist.lst"
    repo="/etc/apt/sources.list.d/"
    keysrv="keyserver.ubuntu.com"

    add_repo $repo $keysrv 
    apt-get update 
    install_pkg $filename 
}

# call main function
# - add (copy) repo files to /etc/apt location 
# - update apt repo
# - install packages found in a file

main | tee install.log


#~end

