# dockerfiler

<details>

* Version: 0.2.1
* GitHub: https://github.com/ThinkR-open/dockerfiler
* Source code: https://github.com/cran/dockerfiler
* Date/Publication: 2023-01-18 08:40:15 UTC
* Number of recursive dependencies: 71

Run `revdep_details(, "dockerfiler")` for more info

</details>

## Newly broken

*   checking tests ...
    ```
      Running ‘testthat.R’
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      
      ══ Skipped tests ═══════════════════════════════════════════════════════════════
      • On CRAN (2)
      • interactive() is not TRUE (1)
      
      ══ Failed tests ════════════════════════════════════════════════════════════════
      ── Failure ('test-dock_from_desc.R:83'): dock_from_desc works ──────────────────
      grepl(i, tpf) is not TRUE
      
      `actual`:   FALSE
      `expected`: TRUE 
      
      [ FAIL 1 | WARN 1 | SKIP 3 | PASS 55 ]
      Error: Test failures
      Execution halted
    ```

