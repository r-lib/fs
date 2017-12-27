
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fs

[![Travis build
status](https://travis-ci.org/r-lib/fs.svg?branch=master)](https://travis-ci.org/r-lib/fs)
![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)
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
#> [1] "/tmp/RtmpDGqPEX/file387035d1042d"

file_create(path(tmp, "my-file.txt"))
dir_list(tmp)
#> [1] "/tmp/RtmpDGqPEX/file387035d1042d/my-file.txt"
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
#> [1] "/tmp/RtmpDGqPEX/file38705969531d/a"
#> [2] "/tmp/RtmpDGqPEX/file38705969531d/b"
#> [3] "/tmp/RtmpDGqPEX/file38705969531d/c"
#> [4] "/tmp/RtmpDGqPEX/file38705969531d/d"
#> [5] "/tmp/RtmpDGqPEX/file38705969531d/e"

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
#>                path permissions        size       creation_time
#>               <chr> <S3: fmode> <S3: bytes>              <dttm>
#> 1 src/RcppExports.o  rw-r--r--       689.9K 2017-12-19 16:11:38
#> 2         src/dir.o  rw-r--r--       482.7K 2017-12-22 08:24:31
#> 3         src/fs.so  rwxr-xr-x       312.9K 2017-12-22 08:24:38
#> 4        src/file.o  rw-r--r--       301.7K 2017-12-22 08:24:33
#> 5          src/uv.o  rw-r--r--       230.9K 2017-12-14 20:11:49
#> 6        src/link.o  rw-r--r--       216.4K 2017-12-22 08:24:35
#> 7        src/path.o  rw-r--r--         213K 2017-12-22 08:24:38
#> 8       src/error.o  rw-r--r--        14.7K 2017-12-22 08:24:31
```
