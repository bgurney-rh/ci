#!/bin/bash
set -e

export STRATIS_DBUS_TIMEOUT=300000

if [ ! -e stratisd.spec -o ! -e stratis-cli.spec ]
then
	echo "Both stratisd.spec and stratis-cli.spec must be present."
	exit 4
fi

BASEDEPPKGS=(
	python3-dbus-client-gen
	python3-dbus-python-client-gen
	python3-justbytes
	python3-psutil
	rpm-build
	rpmdevtools
	keyutils
	asciidoc
	python3-devel
	dbus-devel
	systemd-devel
	rust
	cargo
	openssl-devel
	clang
	llvm
	llvm-devel
	cryptsetup-devel
	libblkid-devel
	make
)

dnf -y install "${BASEDEPPKGS[@]}"

STRATISD_N=$(rpmspec -P stratisd.spec | grep ^Name | awk {'print $2'})
STRATISD_V=$(rpmspec -P stratisd.spec | grep ^Version | awk {'print $2'})
STRATISD_R=$(rpmspec -P stratisd.spec | grep ^Release | awk {'print $2'})
STRATISD_RPMBASENAME="${STRATISD_N}-${STRATISD_V}-${STRATISD_R}"
echo "stratisd package target: $STRATISD_RPMBASENAME"
STRATIS_CLI_N=$(rpmspec -P stratis-cli.spec | grep ^Name | awk {'print $2'})
STRATIS_CLI_V=$(rpmspec -P stratis-cli.spec | grep ^Version | awk {'print $2'})
STRATIS_CLI_R=$(rpmspec -P stratis-cli.spec | grep ^Release | awk {'print $2'})
STRATIS_CLI_RPMBASENAME="${STRATIS_CLI_N}-${STRATIS_CLI_V}-${STRATIS_CLI_R}"
echo "stratis-cli package target: $STRATIS_CLI_RPMBASENAME"

./reset-upstream-stratis-repos.sh

echo "Starting build and package process..."
./build-and-package.sh
