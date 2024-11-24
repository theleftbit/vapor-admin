##!/bin/bash
# This is a comment!
RED='\0x1b[0;31m'
GREEN='\0x1b[0;32m'
YELLOW='\0x1b[0;33m'
NC='\0x1b[0m' # No Color


  
brew_install() {
    echo "\nInstalling $1 if not installed..."
    if brew list $1 &>/dev/null; then
        echo "${1} is already installed"
    else
        brew install $1 && echo "$1 is installed"
    fi
}


if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform
    brew_install jq
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under GNU/Linux platform
    echo use apt
    REQUIRED_PKG="jq"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
    echo Checking for $REQUIRED_PKG: $PKG_OK
    if [ "" = "$PKG_OK" ]; then
    echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
    sudo apt-get --yes install $REQUIRED_PKG
    fi
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Do something under 32 bits Windows NT platform
    echo win 32
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    # Do something under 64 bits Windows NT platform
    echo win 64
fi

echo Generating project from template....
vapor new $1 --template https://github.com/jhoughjr/vapor-auth-template.git
cd ./$1/
echo "${GREEN}Generating new jwks from mkjwk.org ...${NC}"
 curl -s 'https://mkjwk.org/jwk/rsa?alg=RS256&use=sig&gen=sha256&size=2048' \
 | jq ."jwks" >> ./keypair.jwks

echo "${YELLOW}Done.${NC}"
 
