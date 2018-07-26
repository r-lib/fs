# batchtools

Version: 0.9.10

## In both

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      > test_check("batchtools")
      ── 1. Failure: findConfFile (@test_findConfFile.R#7)  ──────────────────────────
      findConfFile() not equal to fs::path_abs(fn).
      1/1 mismatches
      x[1]: "/private/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T/Rtmpvc79h0/batch
      x[1]: tools.conf.R"
      y[1]: "/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T/Rtmpvc79h0/batchtools.co
      y[1]: nf.R"
      
      ══ testthat results  ═══════════════════════════════════════════════════════════
      OK: 1455 SKIPPED: 7 FAILED: 1
      1. Failure: findConfFile (@test_findConfFile.R#7) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

*   checking whether package ‘batchtools’ can be installed ... WARNING
    ```
    Found the following significant warnings:
      Warning: package ‘data.table’ was built under R version 3.4.4
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

Version: 1.1.2

## In both

*   checking for GNU extensions in Makefiles ... NOTE
    ```
    GNU make is a SystemRequirements.
    ```

# pkgdown

Version: 1.1.0

## In both

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      nrow(out) not equal to 1.
      1/1 mismatches
      [1] 0 - 1 == -1
      
      ── 2. Failure: can autodetect published tutorials (@test-tutorials.R#31)  ──────
      out$name not equal to "test-1".
      Lengths differ: 0 is not 1
      
      ══ testthat results  ═══════════════════════════════════════════════════════════
      OK: 239 SKIPPED: 9 FAILED: 2
      1. Failure: can autodetect published tutorials (@test-tutorials.R#30) 
      2. Failure: can autodetect published tutorials (@test-tutorials.R#31) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

# prodigenr

Version: 0.4.0

## In both

*   checking package dependencies ... ERROR
    ```
    Package required and available but unsuitable version: ‘utils’
    
    See section ‘The DESCRIPTION file’ in the ‘Writing R Extensions’
    manual.
    ```

# randomsearch

Version: 0.1.0

## In both

*   checking whether package ‘randomsearch’ can be installed ... WARNING
    ```
    Found the following significant warnings:
      Warning: package ‘ParamHelpers’ was built under R version 3.4.4
    See ‘.../revdep/checks.noindex/randomsearch/new/randomsearch.Rcheck/00install.out’ for details.
    ```

*   checking Rd cross-references ... NOTE
    ```
    Package unavailable to check Rd xrefs: ‘mlrMBO’
    ```

# rfbCNPJ

Version: 0.1.1

## In both

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 27 marked UTF-8 strings
    ```

