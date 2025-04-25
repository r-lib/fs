## Updating to new versions of libuv

- Download the tarball from https://dist.libuv.org/dist/
- Extract to a temporary directory
- Add `AM_MAINTAINER_MODE` to configure.ac
- Remove `AC_ENABLE_SHARED` in configure.ac
- Add `-DSUNOS_NO_IFADDRS` in `Makefile.am` for CRAN Solaris support
- Run autogen.sh
- Run ./configure
- Run `make dist`
- Extract the generated tarball into the fs/src/ directory
- Remove unneeded files and directories from the distribution
  `rm -r m4 img docs test aclocal.m4`
- Update `LIBUV` in `Makevars` with the current version
- Fix any `R CMD check` warnings about pragmas
- Add Makefile.mingw for windows builds
- Delete tarballs and temporary directories

A Linux bash script to do all but the `R CMD check` fix and the last cleanup
step above in a clean, temporary is below:

```
# Update/build dist for libuv
LIBUV_VERSION=1.44.2
wget https://dist.libuv.org/dist/v${LIBUV_VERSION}/libuv-v${LIBUV_VERSION}.tar.gz
tar zxvf libuv-v${LIBUV_VERSION}.tar.gz
rm libuv-v${LIBUV_VERSION}.tar.gz
cd libuv-v${LIBUV_VERSION}
echo AM_MAINTAINER_MODE >> configure.ac
grep -v AC_ENABLE_SHARED configure.ac > configure.ac.tmp
mv configure.ac.tmp configure.ac
./autogen.sh
./configure
make dist

# Update fs
cd ..
git clone git@github.com:r-lib/fs.git
cd fs/src
git checkout -b libuv-v${LIBUV_VERSION}
# save Makefile.mingw for later
mv libuv-*/Makefile.mingw .
git rm -r libuv-*
tar zxvf ../../libuv-v${LIBUV_VERSION}/libuv-${LIBUV_VERSION}.tar.gz
cd libuv-${LIBUV_VERSION}
rm -r m4 img docs test aclocal.m4
cd ..

# restore Makefile.mingw
mv Makefile.mingw libuv-${LIBUV_VERSION}

# Update Makevars
sed "s/LIBUV := libuv-.*/LIBUV := libuv-${LIBUV_VERSION}/" Makevars -i.bak
sed "s/LIBUV := libuv-.*/LIBUV := libuv-${LIBUV_VERSION}/" Makevars.win -i.bak
rm Makevars.bak Makevars.win.bak

git add libuv-${LIBUV_VERSION} Makevars Makevars.win
git commit -m "Update to libuv-${LIBUV_VERSION}"
```