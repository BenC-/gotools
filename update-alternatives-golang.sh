#!/bin/bash
#
# Use the following script using sudo to install multiple golang installations on your debian 
# update-alternatives creates, removes, maintains and displays information about the symbolic links comprising the alternatives system
# Usage : sudo ./full_golang_install.sh
#

if [[ $(id -u) -ne 0 ]] ; then echo "This script should not be run using sudo or as the root user" ; exit 1 ; fi

## Configuration and init
ARCH="linux-amd64"
URL="https://storage.googleapis.com/golang/go"
VERSIONS=("1.4.2" "1.4.3" "1.5" "1.5.1" "1.5.2" "1.5.3")

update-alternatives --quiet --remove-all go
rm -rf /tmp/golang
rm -rf /usr/local/go*

## Download tarballs and install
for i in ${!VERSIONS[@]}
do
	echo "Downloading version ${VERSIONS[$i]}..."
	wget --quiet $URL${VERSIONS[$i]}.${ARCH}.tar.gz -P /tmp/golang
	tar -C /usr/local -xzf /tmp/golang/go${VERSIONS[$i]}.${ARCH}.tar.gz 
	mv /usr/local/go /usr/local/go${VERSIONS[$i]}
	update-alternatives --quiet --install /usr/local/go go /usr/local/go${VERSIONS[$i]} $i
	rm /tmp/golang/go${VERSIONS[$i]}.${ARCH}.tar.gz  
done

# Cleanup
rm -rf /tmp/golang

echo "Following golang versions installed"
update-alternatives --list go

echo "Use: sudo update-alternatives --config go"
echo "To switch between golang versions"
