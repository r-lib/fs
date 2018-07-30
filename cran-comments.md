This fixes an issue with the tests leaving files on disk because of permissions
set during the tests. As requested by Kurt

## Test environments
* local OS X install, R 3.5.0
* ubuntu 14.04 (on travis-ci), R 3.5.0
* win-builder (devel and release)
* Solaris 10 (in a VM)

## R CMD check results

0 errors | 0 warnings | 1 note

* GNU make is a SystemRequirements.
  This is needed by the Makefile for the libuv dependency, it is not practical
  to convert this to a POSIX compatible Makefile.

## Downstream dependencies

I ran `R CMD check` on all 10 reverse dependencies
(https://github.com/r-lib/fs/tree/master/revdep) there were no regressions
detected.
