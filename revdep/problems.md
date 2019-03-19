# batchtools

Version: 0.9.11

## In both

*   checking whether package ‘batchtools’ can be installed ... WARNING
    ```
    Found the following significant warnings:
      Warning: package ‘data.table’ was built under R version 3.5.2
    See ‘.../revdep/checks.noindex/batchtools/new/batchtools.Rcheck/00install.out’ for details.
    ```

*   checking package dependencies ... NOTE
    ```
    Package suggested but not available for checking: ‘doMPI’
    ```

*   checking Rd cross-references ... NOTE
    ```
    Package unavailable to check Rd xrefs: ‘Rmpi’
    ```

# haven

Version: 2.1.0

## In both

*   checking for GNU extensions in Makefiles ... NOTE
    ```
    GNU make is a SystemRequirements.
    ```

# mleap

Version: 0.1.3

## In both

*   checking whether package ‘mleap’ can be installed ... ERROR
    ```
    Installation failed.
    See ‘.../revdep/checks.noindex/mleap/new/mleap.Rcheck/00install.out’ for details.
    ```

## Installation

### Devel

```
* installing *source* package ‘mleap’ ...
** package ‘mleap’ successfully unpacked and MD5 sums checked
** R
** inst
** byte-compile and prepare package for lazy loading
** help
*** installing help indices
** building package indices
** testing if installed package can be loaded
Error: package or namespace load failed for ‘mleap’:
 .onLoad failed in loadNamespace() for 'mleap', details:
  call: NULL
  error: .onLoad failed in loadNamespace() for 'rJava', details:
  call: dyn.load(file, DLLpath = DLLpath, ...)
  error: unable to load shared object '.../revdep/library.noindex/mleap/rJava/libs/rJava.so':
  dlopen(.../revdep/library.noindex/mleap/rJava/libs/rJava.so, 6): Library not loaded: /Library/Java/JavaVirtualMachines/jdk-9.jdk/Contents/Home/lib/server/libjvm.dylib
  Referenced from: .../revdep/library.noindex/mleap/rJava/libs/rJava.so
  Reason: image not found
Error: loading failed
Execution halted
ERROR: loading failed
* removing ‘.../revdep/checks.noindex/mleap/new/mleap.Rcheck/mleap’

```
### CRAN

```
* installing *source* package ‘mleap’ ...
** package ‘mleap’ successfully unpacked and MD5 sums checked
** R
** inst
** byte-compile and prepare package for lazy loading
** help
*** installing help indices
** building package indices
** testing if installed package can be loaded
Error: package or namespace load failed for ‘mleap’:
 .onLoad failed in loadNamespace() for 'mleap', details:
  call: NULL
  error: .onLoad failed in loadNamespace() for 'rJava', details:
  call: dyn.load(file, DLLpath = DLLpath, ...)
  error: unable to load shared object '.../revdep/library.noindex/mleap/rJava/libs/rJava.so':
  dlopen(.../revdep/library.noindex/mleap/rJava/libs/rJava.so, 6): Library not loaded: /Library/Java/JavaVirtualMachines/jdk-9.jdk/Contents/Home/lib/server/libjvm.dylib
  Referenced from: .../revdep/library.noindex/mleap/rJava/libs/rJava.so
  Reason: image not found
Error: loading failed
Execution halted
ERROR: loading failed
* removing ‘.../revdep/checks.noindex/mleap/old/mleap.Rcheck/mleap’

```
# mlflow

Version: 0.8.0

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘aws.s3’
      All declared Imports should be used.
    ```

# pkgcache

Version: 1.0.3

## In both

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      1: read_packages_file(pf[1], mirror = "m1", repodir = "r1", platform = "source", rversion = "*") at testthat/test-packages-gz.R:88
      2: as_tibble(read.dcf.gz(path)) at .../revdep/checks.noindex/pkgcache/new/pkgcache.Rcheck/00_pkg_src/pkgcache/R/packages-gz.R:19
      3: read.dcf.gz(path) at .../revdep/checks.noindex/pkgcache/new/pkgcache.Rcheck/00_pkg_src/pkgcache/R/packages-gz.R:19
      4: gzfile(x, open = "r") at .../revdep/checks.noindex/pkgcache/new/pkgcache.Rcheck/00_pkg_src/pkgcache/R/utils.R:32
      
      ══ testthat results  ═══════════════════════════════════════════════════════════
      OK: 282 SKIPPED: 25 FAILED: 5
      1. Error: load_primary_pkgs (@test-metadata-cache.R#177) 
      2. Error: update_replica_rds (@test-metadata-cache.R#236) 
      3. Error: read_packages_file (@test-packages-gz.R#63) 
      4. Error: packages_parse_deps (@test-packages-gz.R#71) 
      5. Error: merge_packages_data (@test-packages-gz.R#88) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

# pkgdown

Version: 1.3.0

## In both

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      1/1 mismatches
      [1] 0 - 1 == -1
      
      ── 3. Failure: can autodetect published tutorials (@test-tutorials.R#31)  ──────
      out$name not equal to "test-1".
      Lengths differ: 0 is not 1
      
      ══ testthat results  ═══════════════════════════════════════════════════════════
      OK: 281 SKIPPED: 8 FAILED: 3
      1. Failure: intermediate files cleaned up automatically (@test-build_home.R#22) 
      2. Failure: can autodetect published tutorials (@test-tutorials.R#30) 
      3. Failure: can autodetect published tutorials (@test-tutorials.R#31) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

*   checking package dependencies ... NOTE
    ```
    Package suggested but not available for checking: ‘devtools’
    ```

*   checking Rd cross-references ... NOTE
    ```
    Package unavailable to check Rd xrefs: ‘devtools’
    ```

# prodigenr

Version: 0.4.0

## In both

*   checking package dependencies ... ERROR
    ```
    Package required but not available: ‘devtools’
    
    See section ‘The DESCRIPTION file’ in the ‘Writing R Extensions’
    manual.
    ```

# randomsearch

Version: 0.2.0

## In both

*   checking whether package ‘randomsearch’ can be installed ... WARNING
    ```
    Found the following significant warnings:
      Warning: package ‘ParamHelpers’ was built under R version 3.5.2
      Warning: package ‘checkmate’ was built under R version 3.5.2
    See ‘.../revdep/checks.noindex/randomsearch/new/randomsearch.Rcheck/00install.out’ for details.
    ```

# reprex

Version: 0.2.1

## In both

*   checking package dependencies ... NOTE
    ```
    Package suggested but not available for checking: ‘devtools’
    ```

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘tools’
      All declared Imports should be used.
    ```

*   checking Rd cross-references ... NOTE
    ```
    Package unavailable to check Rd xrefs: ‘devtools’
    ```

# rfbCNPJ

Version: 0.1.1

## In both

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 27 marked UTF-8 strings
    ```

# rmarkdown

Version: 1.12

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 10.6Mb
      sub-directories of 1Mb or more:
        R     2.0Mb
        rmd   8.2Mb
    ```

# workflowr

Version: 1.2.0

## In both

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      ══ testthat results  ═══════════════════════════════════════════════════════════
      OK: 836 SKIPPED: 116 FAILED: 10
      1.  Failure: authenticate_git can create HTTPS credentials (@test-wflow_git_push_pull.R#144) 
      2.  Failure: authenticate_git can create HTTPS credentials (@test-wflow_git_push_pull.R#145) 
      3.  Failure: authenticate_git can create HTTPS credentials (@test-wflow_git_push_pull.R#146) 
      4.  Failure: wflow_git_remote can add a remote. (@test-wflow_git_remote.R#54) 
      5.  Failure: wflow_git_remote can add a second remote. (@test-wflow_git_remote.R#61) 
      6.  Failure: wflow_use_github automates local GitHub configuration (@test-wflow_use_github.R#32) 
      7.  Failure: wflow_use_github can be used post GitLab (@test-wflow_use_github.R#74) 
      8.  Failure: wflow_use_github can be run twice (@test-wflow_use_github.R#176) 
      9.  Failure: wflow_use_github can be run after wflow_git_remote (@test-wflow_use_github.R#192) 
      10. Failure: wflow_use_github can be run after using GitLab remote (@test-wflow_use_github.R#210) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

*   checking package dependencies ... NOTE
    ```
    Package suggested but not available for checking: ‘devtools’
    ```

