This is a resubmission.

I added all copyrights holders explicitly as requested.

Thank you for your time.

## Test environments
* local OS X install, R 3.4.3
* ubuntu 14.04 (on travis-ci), R 3.4.3
* win-builder (devel and release)
* Solaris 10 (in a VM)

## R CMD check results

0 errors | 0 warnings | 2 note

* This is a new release.

* GNU make is a SystemRequirements.
  This is needed by the Makefile for the libuv dependency, it is not practical
  to convert this to a POSIX compatible Makefile.
