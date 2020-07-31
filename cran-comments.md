This version fixes warnings in the libuv library from gcc-9

## Test environments
* local OS X install, R 3.6.3
* ubuntu 16.04 (on GitHub Actions), R 3.6.3, 3.5, 3.4, 3.3, 3.2
* win-builder (devel and release)
* Solaris 10 (on R-Hub and a cloud instance via SSH)

## R CMD check results

0 errors | 0 warnings | 1 note

* GNU make is a SystemRequirements.
  This is needed by the Makefile for the libuv dependency, it is not practical
  to convert this to a POSIX compatible Makefile.

## Downstream dependencies

I ran `R CMD check` on all 65 reverse dependencies
(https://github.com/r-lib/fs/tree/master/revdep) there were no regressions detected.
