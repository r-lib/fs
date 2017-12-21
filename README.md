
<!-- README.md is generated from README.Rmd. Please edit that file -->
fs
==

[![Travis build status](https://travis-ci.org/r-lib/fs.svg?branch=master)](https://travis-ci.org/r-lib/fs) [![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://img.shields.io/badge/lifecycle-experimental-orange.svg) [![Coverage status](https://codecov.io/gh/r-lib/fs/branch/master/graph/badge.svg)](https://codecov.io/github/r-lib/fs?branch=master)

The goal of **fs** is to provide a uniform interface to file operations using [libuv](http://docs.libuv.org/en/v1.x/fs.html). libuv is used widely in the javascript community underneath [nodejs](https://nodejs.org), so the code is tested by a large community on diverse systems. The name, and some of the interface, is inspired by Rust's [fs module](https://doc.rust-lang.org/std/fs/index.html).

Installation
------------

You can install **fs** from github with:

``` r
# install.packages("devtools")
devtools::install_github("r-lib/fs")
```

Motivation vs base equivalents
------------------------------

-   All **fs** functions are vectorized, accepting multiple paths as input. All functions either return a character vector of paths, or a named integer or logical vector (where the names give the paths).

-   If an operation fails, **fs** throws an error. Base R file manipulation functions tend to generate a warning and return a logical vector of successes and failures. This makes it easy to miss a failure.

-   **fs** functions always convert the input paths to UTF-8 and return results as UTF-8 encoded paths. This gives you path encoding consistency across OSs.

-   **fs** functions use a consistent naming convention. Because base R's functions were gradually added over time there are a number of different conventions used (e.g. `path.expand()` vs `normalizePath()`; `Sys.chmod()` vs `file.access()`).

Usage
-----

**fs** functions all accept vectors of paths as inputs and outputs, so they work well with dplyr verbs in pipelines.

``` r
library(fs)
library(dplyr)
dir_list() %>%
  file_info() %>%
  filter(size > 10000) %>%
  arrange(desc(size)) %>%
  select(path, permissions, size)
#> # A tibble: 102 x 3
#>                                 path permissions   size
#>                                <chr> <S3: fmode>  <dbl>
#>  1             src/libuv/Makefile.in  rw-r--r--  534520
#>  2 src/libuv/autom4te.cache/output.0  rw-r--r--  467591
#>  3 src/libuv/autom4te.cache/output.1  rw-r--r--  467591
#>  4 src/libuv/autom4te.cache/output.2  rw-r--r--  467549
#>  5 src/libuv/autom4te.cache/output.3  rw-r--r--  467549
#>  6                src/libuv/Makefile  rw-r--r--  465140
#>  7               src/libuv/configure  rwxr-xr-x  464640
#>  8                 src/libuv/libtool  rwxr-xr-x  339624
#>  9               src/libuv/ltmain.sh  rw-r--r--  324089
#> 10           src/libuv/m4/libtool.m4  rw-r--r--  305723
#> # ... with 92 more rows
```

### Functions

**fs** functions are divided into four main categories: manipulating paths, files, directories, and links.

### Path functions

-   `path()` - constructs a new path
-   `path_expand()` - expand `~` in a path
-   `path_home()` - home directory path
-   `path_norm()` - normalizes a path
-   `path_split()` - split a path into components
-   `path_temp()` - temporary directory path

### File functions

-   `file_chmod()` - Change file permissions
-   `file_chown()` - Change file ownership
-   `file_copy()` - Copy a file
-   `file_create()` - Create a new empty file
-   `file_delete()` - Delete files
-   `file_exists()` / `file_access()` - Query for file existence and access permissions.
-   `file_info()` - Query file metadata
-   `file_move()` - Move a file

### Directory functions

-   `dir_create()` - Create a new directory
-   `dir_delete()` - Delete an existing directory
-   `dir_exists()` - Query for directory existence
-   `dir_list()` - List objects in a directory
-   `dir_walk()` - Perform an action on objects in a directory

### Link functions

-   `link_create()` - Create a new link
-   `link_exists()` - Query for link existence
-   `link_path()` - Retrieve the path a link points to
