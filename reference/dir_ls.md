# List files

`dir_ls()` is equivalent to the `ls` command. It returns filenames as a
named `fs_path` character vector. The names are equivalent to the
values, which is useful for passing onto functions like
[`purrr::map_dfr()`](https://purrr.tidyverse.org/reference/map_dfr.html).

`dir_info()` is equivalent to `ls -l` and a shortcut for
`file_info(dir_ls())`.

`dir_map()` applies a function `fun()` to each entry in the path and
returns the result in a list.

`dir_walk()` calls `fun` for its side-effect and returns the input
`path`.

## Usage

``` r
dir_ls(
  path = ".",
  all = FALSE,
  recurse = FALSE,
  type = "any",
  glob = NULL,
  regexp = NULL,
  invert = FALSE,
  fail = TRUE,
  ...,
  recursive
)

dir_map(
  path = ".",
  fun,
  all = FALSE,
  recurse = FALSE,
  type = "any",
  fail = TRUE
)

dir_walk(
  path = ".",
  fun,
  all = FALSE,
  recurse = FALSE,
  type = "any",
  fail = TRUE
)

dir_info(
  path = ".",
  all = FALSE,
  recurse = FALSE,
  type = "any",
  regexp = NULL,
  glob = NULL,
  fail = TRUE,
  ...
)
```

## Arguments

- path:

  A character vector of one or more paths.

- all:

  If `TRUE` hidden files are also returned.

- recurse:

  If `TRUE` recurse fully, if a positive number the number of levels to
  recurse.

- type:

  File type(s) to return, one or more of "any", "file", "directory",
  "symlink", "FIFO", "socket", "character_device" or "block_device".

- glob:

  A wildcard aka globbing pattern (e.g. `*.csv`) passed on to
  [`grep()`](https://rdrr.io/r/base/grep.html) to filter paths.

- regexp:

  A regular expression (e.g. `[.]csv$`) passed on to
  [`grep()`](https://rdrr.io/r/base/grep.html) to filter paths.

- invert:

  If `TRUE` return files which do *not* match

- fail:

  Should the call fail (the default) or warn if a file cannot be
  accessed.

- ...:

  Additional arguments passed to
  [grep](https://rdrr.io/r/base/grep.html).

- recursive:

  (Deprecated) If `TRUE` recurse fully.

- fun:

  A function, taking one parameter, the current path entry.

## Examples

``` r
dir_ls(R.home("share"), type = "directory")
#> /opt/R/4.5.2/lib/R/share/R
#> /opt/R/4.5.2/lib/R/share/Rd
#> /opt/R/4.5.2/lib/R/share/dictionaries
#> /opt/R/4.5.2/lib/R/share/encodings
#> /opt/R/4.5.2/lib/R/share/java
#> /opt/R/4.5.2/lib/R/share/licenses
#> /opt/R/4.5.2/lib/R/share/make
#> /opt/R/4.5.2/lib/R/share/sh
#> /opt/R/4.5.2/lib/R/share/texmf

# Create a shorter link
link_create(system.file(package = "base"), "base")

dir_ls("base", recurse = TRUE, glob = "*.R")
#> base/demo/error.catching.R base/demo/is.things.R      
#> base/demo/recursion.R      base/demo/scoping.R        

# If you need the full paths input an absolute path
dir_ls(path_abs("base"))
#> /tmp/Rtmph08SZU/base/CITATION    /tmp/Rtmph08SZU/base/DESCRIPTION 
#> /tmp/Rtmph08SZU/base/INDEX       /tmp/Rtmph08SZU/base/Meta        
#> /tmp/Rtmph08SZU/base/R           /tmp/Rtmph08SZU/base/demo        
#> /tmp/Rtmph08SZU/base/help        /tmp/Rtmph08SZU/base/html        

dir_map("base", identity)
#> [[1]]
#> [1] "base/CITATION"
#> 
#> [[2]]
#> [1] "base/DESCRIPTION"
#> 
#> [[3]]
#> [1] "base/INDEX"
#> 
#> [[4]]
#> [1] "base/Meta"
#> 
#> [[5]]
#> [1] "base/R"
#> 
#> [[6]]
#> [1] "base/demo"
#> 
#> [[7]]
#> [1] "base/help"
#> 
#> [[8]]
#> [1] "base/html"
#> 

dir_walk("base", str)
#>  chr "base/CITATION"
#>  chr "base/DESCRIPTION"
#>  chr "base/INDEX"
#>  chr "base/Meta"
#>  chr "base/R"
#>  chr "base/demo"
#>  chr "base/help"
#>  chr "base/html"

dir_info("base")
#> # A tibble: 8 × 18
#>   path         type    size permissions modification_time   user  group
#>   <fs::path>   <fct> <fs::> <fs::perms> <dttm>              <chr> <chr>
#> 1 …se/CITATION file     643 rw-r--r--   2025-10-31 10:25:18 root  root 
#> 2 …DESCRIPTION file     383 rw-r--r--   2025-10-31 10:25:18 root  root 
#> 3 base/INDEX   file   24.2K rw-r--r--   2025-10-31 10:25:18 root  root 
#> 4 base/Meta    dire…     4K rwxr-xr-x   2026-03-11 11:32:00 root  root 
#> 5 base/R       dire…     4K rwxr-xr-x   2026-03-11 11:32:00 root  root 
#> 6 base/demo    dire…     4K rwxr-xr-x   2026-03-11 11:32:00 root  root 
#> 7 base/help    dire…     4K rwxr-xr-x   2026-03-11 11:32:00 root  root 
#> 8 base/html    dire…     4K rwxr-xr-x   2026-03-11 11:32:00 root  root 
#> # ℹ 11 more variables: device_id <dbl>, hard_links <dbl>,
#> #   special_device_id <dbl>, inode <dbl>, block_size <dbl>,
#> #   blocks <dbl>, flags <int>, generation <dbl>, access_time <dttm>,
#> #   change_time <dttm>, birth_time <dttm>

# Cleanup
link_delete("base")
```
