
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fs

[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://tidyverse.org/lifecycle/#maturing)
[![Travis build
status](https://travis-ci.org/r-lib/fs.svg?branch=master)](https://travis-ci.org/r-lib/fs)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/r-lib/fs?branch=master&svg=true)](https://ci.appveyor.com/project/r-lib/fs)
[![Coverage
status](https://codecov.io/gh/r-lib/fs/branch/master/graph/badge.svg)](https://codecov.io/github/r-lib/fs?branch=master)

<p align="center">

<img src="https://i.imgur.com/NAux1Xc.png" width = "75%"/>

</p>

**fs** provides a cross-platform, uniform interface to file system
operations. It shares the same back-end component as
[nodejs](https://nodejs.org), the
[libuv](http://docs.libuv.org/en/v1.x/fs.html) C library, which brings
the benefit of extensive real-world use and rigorous cross-platform
testing. The name, and some of the interface, is partially inspired by
Rust’s [fs module](https://doc.rust-lang.org/std/fs/index.html).

## Installation

You can install the released version of **fs** from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("fs")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("r-lib/fs")
```

## Comparison vs base equivalents

**fs** functions smooth over some of the idiosyncrasies of file handling
with base R functions:

  - Vectorization. All **fs** functions are vectorized, accepting
    multiple paths as input. Base functions are inconsistently
    vectorized.

  - Predictable return values that always convey a path. All **fs**
    functions return a character vector of paths, a named integer or a
    logical vector, where the names give the paths. Base return values
    are more varied: they are often logical or contain error codes which
    require downstream processing.

  - Explicit failure. If **fs** operations fail, they throw an error.
    Base functions tend to generate a warning and a system dependent
    error code. This makes it easy to miss a failure.

  - UTF-8 all the things. **fs** functions always convert input paths to
    UTF-8 and return results as UTF-8. This gives you path encoding
    consistency across OSes. Base functions rely on the native system
    encoding.

  - Naming convention. **fs** functions use a consistent naming
    convention. Because base R’s functions were gradually added over
    time there are a number of different conventions used (e.g.
    `path.expand()` vs `normalizePath()`; `Sys.chmod()` vs
    `file.access()`).

### Tidy paths

**fs** functions always return ‘tidy’ paths. Tidy paths

  - Always use `/` to delimit directories
  - never have multiple `/` or trailing `/`

Tidy paths are also coloured (if your terminal supports it) based on the
file permissions and file type. This colouring can be customised or
extended by setting the `LS_COLORS` environment variable, in the same
output format as [GNU
dircolors](http://www.bigsoft.co.uk/blog/index.php/2008/04/11/configuring-ls_colors).

## Usage

**fs** functions are divided into four main categories:

  - `path_` for manipulating paths
  - `file_` for files
  - `dir_` for directories
  - `link_` for links

Directories and links are special types of files, so `file_` functions
will generally also work when applied to a directory or link.

``` r
library(fs)

# list files in the current directory
dir_ls()
#> DESCRIPTION          LICENSE.md           NAMESPACE            
#> NEWS.md              R                    README.Rmd           
#> README.md            _pkgdown.yml         appveyor.yml         
#> codecov.yml          cran-comments.md     docs                 
#> fs.Rcheck            fs.Rproj             fs_1.0.0.9000.tar.gz 
#> inst                 man                  man-roxygen          
#> src                  tests

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

**fs** is designed to work well with the pipe, though because it is a
minimal-dependency infrastructure package it doesn’t provide the pipe
itself. You will need to attach
[magrittr](http://magrittr.tidyverse.org) or similar.

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

**fs** functions also work well in conjunction with other
[tidyverse](https://www.tidyverse.org/) packages, like
[dplyr](http://dplyr.tidyverse.org) and
[purrr](http://purrr.tidyverse.org).

Some examples…

``` r
suppressMessages(
  library(tidyverse))
```

Filter files by type, permission and size

``` r
dir_info("src", recursive = FALSE) %>%
  filter(type == "file", permissions == "u+r", size > "10KB") %>%
  arrange(desc(size)) %>%
  select(path, permissions, size, modification_time)
#> # A tibble: 9 x 4
#>   path                permissions        size modification_time  
#>   <fs::path>          <fs::perms> <fs::bytes> <dttm>             
#> 1 src/RcppExports.o   rw-r--r--        761.7K 2018-01-23 16:08:06
#> 2 src/dir.o           rw-r--r--        468.3K 2018-01-23 16:08:05
#> 3 src/id.o            rw-r--r--        377.7K 2018-01-23 16:08:05
#> 4 src/fs.so           rwxr-xr-x          333K 2018-01-23 16:08:11
#> 5 src/file.o          rw-r--r--        313.3K 2018-01-23 16:08:05
#> 6 src/path.o          rw-r--r--        241.6K 2018-01-23 16:08:05
#> 7 src/link.o          rw-r--r--        215.8K 2018-01-23 16:08:05
#> 8 src/error.o         rw-r--r--         17.3K 2018-01-23 16:08:01
#> 9 src/RcppExports.cpp rw-r--r--         10.9K 2018-01-22 17:59:06
```

Tabulate and display folder size.

``` r
dir_info("src", recursive = TRUE) %>%
  group_by(directory = path_dir(path)) %>%
  tally(wt = size, sort = TRUE)
#> # A tibble: 54 x 2
#>    directory                                        n
#>    <fs::path>                             <fs::bytes>
#>  1 src                                           2.7M
#>  2 src/libuv                                    2.43M
#>  3 src/libuv/src/unix                           1.09M
#>  4 src/libuv/autom4te.cache                     1.08M
#>  5 src/libuv/test                             865.36K
#>  6 src/libuv/src/win                          683.14K
#>  7 src/libuv/docs/src/static                  328.32K
#>  8 src/libuv/m4                               319.95K
#>  9 src/libuv/include                          192.33K
#> 10 src/libuv/docs/src/static/diagrams.key     184.04K
#> # ... with 44 more rows
```

Read a collection of files into one data frame.

`dir_ls()` returns a named vector, so it can be used directly with
`purrr::map_df(.id)`.

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

# Read the data into a single table, including the filenames
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

## Feedback wanted\!

We hope **fs** is a useful tool for both analysis scripts and packages.
Please open [GitHub issues](https://github.com/r-lib/fs) for any feature
requests or bugs.

In particular, we have found non-ASCII filenames in non-English locales
on Windows to be especially tricky to reproduce and handle correctly.
Feedback from users who use commonly have this situation is greatly
appreciated.
