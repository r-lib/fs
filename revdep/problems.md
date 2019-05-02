# reprex

<details>

* Version: 0.2.1
* Source code: https://github.com/cran/reprex
* URL: https://reprex.tidyverse.org, https://github.com/tidyverse/reprex#readme
* BugReports: https://github.com/tidyverse/reprex/issues
* Date/Publication: 2018-09-16 04:30:09 UTC
* Number of recursive dependencies: 75

Run `revdep_details(,"reprex")` for more info

</details>

## Newly broken

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      ── 1. Failure: make_filebase() works from absolute infile, outfile (@test-filepa
      fs::path_dir(x) not equal to path_temp().
      Classes differ: character is not fs_path/character
      
      ── 2. Failure: make_filebase() works from absolute infile, outfile (@test-filepa
      fs::path_dir(x) not equal to path_temp().
      Classes differ: character is not fs_path/character
      
      ══ testthat results  ═══════════════════════════════════════════════════════════
      OK: 25 SKIPPED: 55 WARNINGS: 0 FAILED: 2
      1. Failure: make_filebase() works from absolute infile, outfile (@test-filepaths.R#25) 
      2. Failure: make_filebase() works from absolute infile, outfile (@test-filepaths.R#29) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘tools’
      All declared Imports should be used.
    ```

