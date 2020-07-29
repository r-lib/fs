## Updating to new versions of libuv

- Download the tarball from https://dist.libuv.org/dist/
- Extract to a temporary directory
- Add `AM_MAINTAINER_MODE` to configure.ac
- Remove `AM_ENABLE_SHARED` in configure.ac
- Run autogen.sh
- Run ./configure
- Run `make dist`
- Extract the generated tarball into this directory
- Remove unneeded files from distribution
  `rm -r m4 img docs test aclocal.m4`
- Update `LIBUV` in `Makevars` with the current version
- Fix any `R CMD check` warnings about pragmas
- Add Makefile.mingw for windows builds
- Delete tarballs
