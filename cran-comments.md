This is a resubmission.

I have now included the libuv license and copyright holders in the file LICENSE
in the package root directory. The copyright holders listed in the previous
reply are contributors to the libuv library and are now included in this file.

As mentioned in my comments in the previous submission, and in the
SystemRequirements field in the DESCRIPTION, this package requires libbsd to be
installed on linux systems (libbsd: libbsd-dev (deb), libbsd-devel (yum)). The
package was failing to install on your system because you did not install this
dependency before trying to install fs.

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
