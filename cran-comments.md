This release fixes test failures with strict latin-1 locales that was missed in
the previous release. It also fixes a permission issue that made cleaning up
the temporary directory fail, and a sanitizer issue.

## Test environments
* local OS X install, R 3.5.1
* ubuntu 14.04 (on travis-ci), R 3.5.1
* win-builder (devel and release)
* Solaris 10 (in a VM)

## R CMD check results

0 errors | 0 warnings | 1 note

* GNU make is a SystemRequirements.
  This is needed by the Makefile for the libuv dependency, it is not practical
  to convert this to a POSIX compatible Makefile.

## Downstream dependencies

I ran `R CMD check` on all 28 reverse dependencies
(https://github.com/r-lib/fs/tree/master/revdep) there was 1 regression
detected.

- reprex - Pull Request sent to fix it, which has now been merged (https://github.com/tidyverse/reprex/pull/253)
