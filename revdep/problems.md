# batchtools

Version: 0.9.11

## In both

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
      OK: 241 SKIPPED: 9 FAILED: 2
      1. Failure: can autodetect published tutorials (@test-tutorials.R#30) 
      2. Failure: can autodetect published tutorials (@test-tutorials.R#31) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

# prodigenr

Version: 0.4.0

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘clipr’ ‘desc’ ‘devtools’
      All declared Imports should be used.
    ```

# pulsar

Version: 0.3.3

## In both

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      > suppressPackageStartupMessages(library(testthat))
      > suppressPackageStartupMessages(library(pulsar))
      > 
      > testthat::test_check("pulsar")
      ── 1. Error: (unknown) (@test_pulsar.R#15)  ────────────────────────────────────
      object 'fp' not found
      1: batchtools:::fp at testthat/test_pulsar.R:15
      2: get(name, envir = asNamespace(pkg), inherits = FALSE)
      
      ══ testthat results  ═══════════════════════════════════════════════════════════
      OK: 36 SKIPPED: 0 FAILED: 1
      1. Error: (unknown) (@test_pulsar.R#15) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

# randomsearch

Version: 0.1.0

## In both

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

