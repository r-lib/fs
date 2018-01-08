
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fs

[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://tidyverse.org)
[![Travis build
status](https://travis-ci.org/r-lib/fs.svg?branch=master)](https://travis-ci.org/r-lib/fs)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/r-lib/fs?branch=master&svg=true)](https://ci.appveyor.com/project/r-lib/fs)
[![Coverage
status](https://codecov.io/gh/r-lib/fs/branch/master/graph/badge.svg)](https://codecov.io/github/r-lib/fs?branch=master)

<p align="center">

<img src="https://i.imgur.com/NAux1Xc.png" width = "75%"/>

</p>

The goal of **fs** is to provide a uniform interface to file and
directory operations, built on top of the
[libuv](http://docs.libuv.org/en/v1.x/fs.html) C library. libuv is used
by [nodejs](https://nodejs.org), so is widely used in the javascript
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
    input. Base functions are inconsistently vectorized.

  - All **fs** functions return a character vector of paths, a named
    integer or a logical vector (where the names give the paths). Base
    return values are more varied.

  - If **fs** operations fail, they throw an error. Base R file
    manipulation functions tend to generate a warning and return a
    logical vector of successes and failures. This makes it easy to miss
    a failure.

  - **fs** functions always convert the input paths to UTF-8 and return
    results as UTF-8. This gives you path encoding consistency across
    OSs.

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

# list files in the current directory
dir_ls()
#> DESCRIPTION  LICENSE.md   NAMESPACE    R            README.Rmd   
#> README.html  README.md    _pkgdown.yml appveyor.yml codecov.yml  
#> demo.json    doc          docs         fs.Rproj     man          
#> man-roxygen  script.R     src          test.R       tests        
#> tools

# create a new directory
tmp <- dir_create(file_temp())
tmp
#> /tmp/filedd463d6d7e0f

# create new files in that directory
file_create(path(tmp, "my-file.txt"))
dir_ls(tmp)
#> /tmp/filedd463d6d7e0f/my-file.txt

# remove files from the directory
file_delete(path(tmp, "my-file.txt"))
dir_ls(tmp)
#> character(0)

# remove the directory
dir_delete(tmp)
```

**fs** is designed to work well with the pipe, although it doesn’t
provide the pipe itself because it’s a low-level infrastructure package
so has minimal dependencies. You’ll need to attach magrittr or similar.

``` r
library(magrittr)

paths <- file_temp() %>%
  dir_create() %>%
  path(letters[1:5]) %>%
  file_create()
paths
#> /tmp/filedd464dbb3467/a /tmp/filedd464dbb3467/b /tmp/filedd464dbb3467/c 
#> /tmp/filedd464dbb3467/d /tmp/filedd464dbb3467/e

paths %>% file_delete()
```

**fs** functions also work well in conjunction with dplyr, purrr and
other tidyverse packages.

``` r
suppressMessages(
  library(tidyverse))
```

Filter files by type, permission and size

``` r
dir_info("src", recursive = FALSE) %>%
  filter(type == "file", permissions == "u+r", size > "10KB") %>%
  arrange(desc(size)) %>%
  select(path, permissions, size, creation_time)
#> # A tibble: 9 x 4
#>   path                permissions        size creation_time      
#>   <fs::filename>      <fs::perms> <fs::bytes> <dttm>             
#> 1 src/RcppExports.o   rw-r--r--        646.1K 2018-01-05 08:20:05
#> 2 src/dir.o           rw-r--r--        452.6K 2018-01-07 22:10:14
#> 3 src/fs.so           rwxr-xr-x        419.2K 2018-01-07 22:10:14
#> 4 src/id.o            rw-r--r--        388.5K 2018-01-03 07:40:08
#> 5 src/file.o          rw-r--r--        311.7K 2018-01-03 09:43:07
#> 6 src/path.o          rw-r--r--        244.8K 2018-01-05 08:34:28
#> 7 src/link.o          rw-r--r--        219.6K 2018-01-03 09:43:06
#> 8 src/error.o         rw-r--r--         17.3K 2018-01-03 07:40:04
#> 9 src/RcppExports.cpp rw-r--r--         11.2K 2018-01-05 08:18:33
```

Display folder size

``` r
dir_info("src", recursive = TRUE) %>%
  group_by(directory = path_dir(path)) %>%
  tally(wt = size, sort = TRUE)
#> # A tibble: 53 x 2
#>    directory                                        n
#>    <fs::filename>                         <fs::bytes>
#>  1 src                                          2.67M
#>  2 src/libuv                                    2.53M
#>  3 src/libuv/autom4te.cache                     2.13M
#>  4 src/libuv/src/unix                           1.08M
#>  5 src/libuv/test                             865.36K
#>  6 src/libuv/src/win                           683.1K
#>  7 src/libuv/m4                               334.61K
#>  8 src/libuv/docs/src/static                  328.32K
#>  9 src/libuv/include                          192.33K
#> 10 src/libuv/docs/src/static/diagrams.key     184.04K
#> # ... with 43 more rows
```

Read a collection of files into one data frame. `dir_ls()` returns a
named vector, so it can be used directly with `purrr::map_df(.id)`.

``` r
# Create separate files for each species
iris %>%
  split(.$Species) %>%
  map(select, -Species) %>%
  iwalk(~ write_tsv(.x, paste0(.y, ".tsv")))

# Show the files
iris_files <- dir_ls(glob = "*.tsv")
iris_files
#> setosa.tsv     versicolor.tsv virginica.tsv

# Read the data into a single table, including the filenames.
iris_files %>%
  map_df(read_tsv, .id = "file", col_types = cols(), n_max = 2)
#> # A tibble: 6 x 5
#>   file           Sepal.Length Sepal.Width Petal.Length Petal.Width
#>   <chr>                 <dbl>       <dbl>        <dbl>       <dbl>
#> 1 setosa.tsv             5.10        3.50         1.40       0.200
#> 2 setosa.tsv             4.90        3.00         1.40       0.200
#> 3 versicolor.tsv         7.00        3.20         4.70       1.40 
#> 4 versicolor.tsv         6.40        3.20         4.50       1.50 
#> 5 virginica.tsv          6.30        3.30         6.00       2.50 
#> 6 virginica.tsv          5.80        2.70         5.10       1.90

file_delete(iris_files)
```
