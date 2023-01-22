
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fs

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html#maturing)
[![R-CMD-check](https://github.com/r-lib/fs/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/r-lib/fs/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/r-lib/fs/branch/main/graph/badge.svg)](https://app.codecov.io/gh/r-lib/fs?branch=main)
<!-- badges: end -->

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

- Vectorization. All **fs** functions are vectorized, accepting multiple
  paths as input. Base functions are inconsistently vectorized.

- Predictable return values that always convey a path. All **fs**
  functions return a character vector of paths, a named integer or a
  logical vector, where the names give the paths. Base return values are
  more varied: they are often logical or contain error codes which
  require downstream processing.

- Explicit failure. If **fs** operations fail, they throw an error. Base
  functions tend to generate a warning and a system dependent error
  code. This makes it easy to miss a failure.

- UTF-8 all the things. **fs** functions always convert input paths to
  UTF-8 and return results as UTF-8. This gives you path encoding
  consistency across OSes. Base functions rely on the native system
  encoding.

- Naming convention. **fs** functions use a consistent naming
  convention. Because base R’s functions were gradually added over time
  there are a number of different conventions used (e.g. `path.expand()`
  vs `normalizePath()`; `Sys.chmod()` vs `file.access()`).

### Tidy paths

**fs** functions always return ‘tidy’ paths. Tidy paths

- Always use `/` to delimit directories
- never have multiple `/` or trailing `/`

Tidy paths are also coloured (if your terminal supports it) based on the
file permissions and file type. This colouring can be customized or
extended by setting the `LS_COLORS` environment variable, in the same
output format as [GNU
dircolors](http://www.bigsoft.co.uk/blog/index.php/2008/04/11/configuring-ls_colors).

## Usage

**fs** functions are divided into four main categories:

- `path_` for manipulating and constructing paths
- `file_` for files
- `dir_` for directories
- `link_` for links

Directories and links are special types of files, so `file_` functions
will generally also work when applied to a directory or link.

``` r
library(fs)

# Construct a path to a file with `path()`
path("foo", "bar", letters[1:3], ext = "txt")
#> foo/bar/a.txt foo/bar/b.txt foo/bar/c.txt

# list files in the current directory
dir_ls()
#> DESCRIPTION      LICENSE          LICENSE.md       MAINTENANCE.md   
#> NAMESPACE        NEWS.md          R                README.Rmd       
#> README.md        _pkgdown.yml     cleanup          codecov.yml      
#> cran-comments.md fs.Rproj         inst             man              
#> man-roxygen      revdep           src              tests            
#> vignettes

# create a new directory
tmp <- dir_create(file_temp())
tmp
#> /var/folders/ph/fpcmzfd16rgbbk8mxvy9m2_h0000gn/T/RtmpsYVhMJ/file14eb5f12e1a8

# create new files in that directory
file_create(path(tmp, "my-file.txt"))
dir_ls(tmp)
#> /var/folders/ph/fpcmzfd16rgbbk8mxvy9m2_h0000gn/T/RtmpsYVhMJ/file14eb5f12e1a8/my-file.txt

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
[magrittr](https://magrittr.tidyverse.org) or similar.

``` r
library(magrittr)

paths <- file_temp() %>%
  dir_create() %>%
  path(letters[1:5]) %>%
  file_create()
paths
#> /var/folders/ph/fpcmzfd16rgbbk8mxvy9m2_h0000gn/T/RtmpsYVhMJ/file14eb51c5215df/a
#> /var/folders/ph/fpcmzfd16rgbbk8mxvy9m2_h0000gn/T/RtmpsYVhMJ/file14eb51c5215df/b
#> /var/folders/ph/fpcmzfd16rgbbk8mxvy9m2_h0000gn/T/RtmpsYVhMJ/file14eb51c5215df/c
#> /var/folders/ph/fpcmzfd16rgbbk8mxvy9m2_h0000gn/T/RtmpsYVhMJ/file14eb51c5215df/d
#> /var/folders/ph/fpcmzfd16rgbbk8mxvy9m2_h0000gn/T/RtmpsYVhMJ/file14eb51c5215df/e

paths %>% file_delete()
```

**fs** functions also work well in conjunction with other
[tidyverse](https://www.tidyverse.org/) packages, like
[dplyr](https://dplyr.tidyverse.org) and
[purrr](https://purrr.tidyverse.org).

Some examples…

``` r
suppressMessages(
  library(tidyverse))
```

Filter files by type, permission and size

``` r
dir_info("src", recurse = FALSE) %>%
  filter(type == "file", permissions == "u+r", size > "10KB") %>%
  arrange(desc(size)) %>%
  select(path, permissions, size, modification_time)
#> # A tibble: 11 × 4
#>    path          permissions        size modification_time  
#>    <fs::path>    <fs::perms> <fs::bytes> <dttm>             
#>  1 src/fs.so     rwxr-xr-x        492.6K 2023-01-22 21:52:58
#>  2 src/id.o      rw-r--r--        213.5K 2023-01-22 21:52:41
#>  3 src/dir.o     rw-r--r--        102.7K 2023-01-22 21:52:40
#>  4 src/utils.o   rw-r--r--         89.2K 2023-01-22 21:52:41
#>  5 src/path.o    rw-r--r--         81.7K 2023-01-22 21:52:41
#>  6 src/link.o    rw-r--r--         74.2K 2023-01-22 21:52:41
#>  7 src/getmode.o rw-r--r--         65.3K 2023-01-22 21:52:40
#>  8 src/file.o    rw-r--r--         48.5K 2023-01-22 21:52:40
#>  9 src/error.o   rw-r--r--         18.4K 2023-01-22 21:52:40
#> 10 src/init.o    rw-r--r--         17.4K 2023-01-22 21:52:41
#> 11 src/file.cc   rw-r--r--         11.7K 2023-01-22 21:52:29
```

Tabulate and display folder size.

``` r
dir_info("src", recurse = TRUE) %>%
  group_by(directory = path_dir(path)) %>%
  tally(wt = size, sort = TRUE)
#> # A tibble: 14 × 2
#>    directory                                n
#>    <chr>                          <fs::bytes>
#>  1 src/libuv-1.44.2                     2.85M
#>  2 src/libuv-1.44.2/src/unix            1.28M
#>  3 src                                  1.22M
#>  4 src/libuv-1.44.2/test                1.05M
#>  5 src/libuv-1.44.2/src/win           742.07K
#>  6 src/libuv-1.44.2/m4                 356.7K
#>  7 src/libuv-1.44.2/src               340.12K
#>  8 src/libuv-1.44.2/include/uv        137.44K
#>  9 src/libuv-1.44.2/img               106.71K
#> 10 src/libuv-1.44.2/include            66.23K
#> 11 src/unix                             60.2K
#> 12 src/bsd                             20.02K
#> 13 src/windows                          4.73K
#> 14 src/libuv-1.44.2/test/fixtures         453
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
#> # A tibble: 6 × 5
#>   file           Sepal.Length Sepal.Width Petal.Length Petal.Width
#>   <chr>                 <dbl>       <dbl>        <dbl>       <dbl>
#> 1 setosa.tsv              5.1         3.5          1.4         0.2
#> 2 setosa.tsv              4.9         3            1.4         0.2
#> 3 versicolor.tsv          7           3.2          4.7         1.4
#> 4 versicolor.tsv          6.4         3.2          4.5         1.5
#> 5 virginica.tsv           6.3         3.3          6           2.5
#> 6 virginica.tsv           5.8         2.7          5.1         1.9

file_delete(iris_files)
```

## Feedback wanted!

We hope **fs** is a useful tool for both analysis scripts and packages.
Please open [GitHub issues](https://github.com/r-lib/fs) for any feature
requests or bugs.

In particular, we have found non-ASCII filenames in non-English locales
on Windows to be especially tricky to reproduce and handle correctly.
Feedback from users who use commonly have this situation is greatly
appreciated.

## Code of Conduct

Please note that the fs project is released with a [Contributor Code of
Conduct](https://fs.r-lib.org/dev/CODE_OF_CONDUCT.html). By contributing to
this project, you agree to abide by its terms.
