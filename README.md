
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fs

![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)
[![Travis build
status](https://travis-ci.org/r-lib/fs.svg?branch=master)](https://travis-ci.org/r-lib/fs)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/r-lib/fs?branch=master&svg=true)](https://ci.appveyor.com/project/r-lib/fs)
[![Coverage
status](https://codecov.io/gh/r-lib/fs/branch/master/graph/badge.svg)](https://codecov.io/github/r-lib/fs?branch=master)

The goal of **fs** is to provide a uniform interface to file and
directory operations, built on top of the
[libuv](http://docs.libuv.org/en/v1.x/fs.html) C library. libuv is used
by [nodejs](https://nodejs.org), so is widely in the javascript
community and tested by a large community on diverse systems. The name,
and some of the interface, is inspired by Rust’s [fs
module](https://doc.rust-lang.org/std/fs/index.html).

## Installation

You can install **fs** from github with:

``` r
# install.packages("devtools")
devtools::install_github("r-lib/fs")
```

## Motivation vs base equivalents

  - All **fs** functions are vectorized, accepting multiple paths as
    input. All functions either return a character vector of paths, or a
    named integer or logical vector (where the names give the paths).

  - If an operation fails, **fs** throws an error. Base R file
    manipulation functions tend to generate a warning and return a
    logical vector of successes and failures. This makes it easy to miss
    a failure.

  - **fs** functions always convert the input paths to UTF-8 and return
    results as UTF-8 encoded paths. This gives you path encoding
    consistency across OSs.

  - **fs** functions use a consistent naming convention. Because base
    R’s functions were gradually added over time there are a number of
    different conventions used (e.g. `path.expand()` vs
    `normalizePath()`; `Sys.chmod()` vs `file.access()`).

## Usage

**fs** functions are divided into four main categories: manipulating
paths (`path_`), files (`file_`), directories (`dir_`), and links
(`link_`). Directories and links are special types of files, so `file_`
functions will generally also work when applied to a directory or link.

``` r
library(fs)

tmp <- dir_create(tempfile())
tmp
#> [1] "/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T//Rtmpl6TqFq/file176e060777196"

file_create(path(tmp, "my-file.txt"))
dir_list(tmp)
#> [1] "/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T//Rtmpl6TqFq/file176e060777196/my-file.txt"
file_delete(path(tmp, "my-file.txt"))
dir_list(tmp)
#> character(0)

dir_delete(tmp)
```

**fs** is designed to work well with the pipe, although it doesn’t
provide the pipe itself because it’s a low-level infrastructure package.
You’ll need to attach magrittr or similar.

``` r
library(magrittr)

paths <- tempfile() %>%
  dir_create() %>%
  path(letters[1:5]) %>%
  file_create() 
paths
#> [1] "/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T//Rtmpl6TqFq/file176e040424c86/a"
#> [2] "/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T//Rtmpl6TqFq/file176e040424c86/b"
#> [3] "/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T//Rtmpl6TqFq/file176e040424c86/c"
#> [4] "/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T//Rtmpl6TqFq/file176e040424c86/d"
#> [5] "/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T//Rtmpl6TqFq/file176e040424c86/e"

paths %>% file_delete()
```

`dir_info()` returns a data frame, which works particularly nicely in
conjunction with dplyr and the S3 helper classes for permissions and
file sizes.

``` r
library(dplyr)

dir_info("src", recursive = FALSE) %>%
  as_tibble() %>%
  filter(type == "file", permissions == "u+r", size > "10KB") %>%
  arrange(desc(size)) %>%
  select(path, permissions, size, creation_time)
#> # A tibble: 8 x 4
#>                path    permissions           size       creation_time
#>               <chr> <S3: fs_perms> <S3: fs_bytes>              <dttm>
#> 1        src/fs.dll     rw-rw-rw-         1003.5K 2017-12-27 14:36:06
#> 2 src/RcppExports.o     rw-r--r--          601.2K 2017-12-27 14:56:23
#> 3         src/dir.o     rw-r--r--          452.6K 2017-12-27 14:56:23
#> 4         src/fs.so     rwxr-xr-x          367.1K 2017-12-27 14:56:41
#> 5        src/file.o     rw-r--r--          292.4K 2017-12-27 14:56:23
#> 6        src/link.o     rw-r--r--          219.6K 2017-12-27 14:56:26
#> 7        src/path.o     rw-r--r--          216.8K 2017-12-27 14:56:23
#> 8       src/error.o     rw-r--r--           17.3K 2017-12-27 14:56:23
```
