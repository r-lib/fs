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
- Add Makefile.mingw for windows builds   <---??? needs more explanation
- Delete tarballs and temporary directories
