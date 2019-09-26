#!/bin/bash
#
# Build a minimal static DASH binary (without its GPLv2 part) and a root filesystem.
#
# @see http://gondor.apana.org.au/~herbert/dash/
# @see http://man7.org/linux/man-pages/man7/signal.7.html
#

set -euo pipefail

echo "=== Fetching dash source..."
git clone git://git.kernel.org/pub/scm/utils/dash/dash.git
cd dash

echo "=== Fixing signames.c mechanism..."
cp  ../new-signames.c  src/signames.c
rm  src/mksignames.c
sed -i -e 's/mksignames.c//'  src/Makefile.am
sed -i -e 's/mksignames//'    src/Makefile.am
 

echo "=== Building dash..."
./autogen.sh
./configure --enable-static
make


echo
echo "=== Checking dash binary..."
! ldd src/dash

echo
echo "=== Building root filesystem ..."

mkdir -p rootfs/bin
cp ../LICENSE-OF-THIS-PATCHED-DASH    rootfs/

cp src/dash   rootfs/bin
cd rootfs/bin
ln -s dash sh

echo
echo "=== Done!"
