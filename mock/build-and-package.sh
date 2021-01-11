#!/bin/bash
set -e

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

if [ -d output_rpms ]
then
        echo "output_rpms directory already exists.  Recreating..."
        rm -rvf output_rpms
fi
mkdir output_rpms
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS}/

# Build the stratisd package (along with the rust cargo vendor tarball)
echo "Building stratisd test package..."

tar czvf ~/rpmbuild/SOURCES/${STRATISD_N}-${STRATISD_V}.tar.gz ${STRATISD_N}-${STRATISD_V}
cd ${STRATISD_N}-${STRATISD_V}/
cd ..
echo "Executing rpmbuild for stratisd..."
rpmbuild -bs --target noarch --nodeps stratisd.spec
mock ~/rpmbuild/SRPMS/${STRATISD_N}-${STRATISD_V}-${STRATISD_R}.src.rpm -a https://kojipkgs.fedoraproject.org/repos/rawhide/latest/x86_64

# Build the stratis-cli package
echo "Building stratis-cli test package..."
tar czvf ~/rpmbuild/SOURCES/${STRATIS_CLI_N}-${STRATIS_CLI_V}.tar.gz ${STRATIS_CLI_N}-${STRATIS_CLI_V}
echo "Executing rpmbuild for stratis-cli..."
rpmbuild -bb stratis-cli.spec

# Find all of the stratis-related RPM files output via the rpmbuild
# stage, (including debuginfo and debugsource), and copy them to the
# staging directory.
find ~/rpmbuild/RPMS/ -name stratis*.rpm -exec cp -v {} output_rpms/ \;
