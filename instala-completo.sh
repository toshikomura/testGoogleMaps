#!/bin/bash

wget https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer
bash rvm-installer
rm -f rvm-installer
source "/usr/local/rvm/scripts/rvm"
rvm requirements
rvm install 1.9.3
rvm --default use 1.9.3
rvm use 1.9.3
echo '
	[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm" # This loads RVM
	source /etc/profile
	rvm use 1.9.3' >> ~/.bashrc
source /etc/profile
gem install rails --version "3.2.12"
gem install bundle
