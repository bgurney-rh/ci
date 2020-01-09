#!/bin/bash

# Prepare a system to run the Stratis test suite.
# Current distro: Fedora (29)

PRESTAGE=`pwd`

sudo dnf -y install git \
	make \
	dbus-devel \
	gcc \
	systemd-devel \
	xfsprogs \
	python3-tox \
	python3-pytest \
	dbus-python \
	make \
	device-mapper-persistent-data \
	xfsprogs \
	python3-hypothesis \
	python3-coverage \
	dbus-glib-devel \
	python3-justbytes.noarch \
	python3-setuptools \
	dbus-python-devel \
	python3-pyudev \
	python3-dateutil \
	python3-wcwidth \
	python3-pyparsing \
	python3-psutil \
	dbus-devel.x86_64 \
	systemd-devel.x86_64 \
	glibc-devel.x86_64 \
	dbus-devel.i686 \
	systemd-devel.i686 \
	glibc-devel.i686 \
	openssl-devel

# The instructions for rustup say to run "curl https://sh.rustup.rs -sSf | sh".
# The resulting script has an interactive prompt, which would hang.
# Instead, download it to a shell script, and execute with the "-y" switch
# to automatically install.
curl -o install_rustup.sh https://sh.rustup.rs
chmod +x install_rustup.sh
./install_rustup.sh -y

source $HOME/.cargo/env

rustup default 1.38.0
