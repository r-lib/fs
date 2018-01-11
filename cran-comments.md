On linux systems this package requires the libbsd-dev package to be installed
on the system. I have verified the package checks successfully on the following
systems.

## Test environments
* local OS X install, R 3.4.3
* ubuntu 14.04 (on travis-ci), R 3.4.3
* win-builder (devel and release)
* Solaris 10 (in a VM)

## R CMD check results

0 errors | 0 warnings | 2 note

* This is a new release.

* GNU make is a SystemRequirements.
  This is needed by the libuv dependency, it is not practical to convert this
  to a POSIX Makefile.
