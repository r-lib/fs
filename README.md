
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fs

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html#maturing)
[![R build
status](https://github.com/r-lib/fs/workflows/R-CMD-check/badge.svg)](https://github.com/r-lib/fs/actions)
[![Coverage
status](https://codecov.io/gh/r-lib/fs/branch/master/graph/badge.svg)](https://codecov.io/github/r-lib/fs?branch=master)
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

-   Vectorization. All **fs** functions are vectorized, accepting
    multiple paths as input. Base functions are inconsistently
    vectorized.

-   Predictable return values that always convey a path. All **fs**
    functions return a character vector of paths, a named integer or a
    logical vector, where the names give the paths. Base return values
    are more varied: they are often logical or contain error codes which
    require downstream processing.

-   Explicit failure. If **fs** operations fail, they throw an error.
    Base functions tend to generate a warning and a system dependent
    error code. This makes it easy to miss a failure.

-   UTF-8 all the things. **fs** functions always convert input paths to
    UTF-8 and return results as UTF-8. This gives you path encoding
    consistency across OSes. Base functions rely on the native system
    encoding.

-   Naming convention. **fs** functions use a consistent naming
    convention. Because base R’s functions were gradually added over
    time there are a number of different conventions used
    (e.g. `path.expand()` vs `normalizePath()`; `Sys.chmod()` vs
    `file.access()`).

### Tidy paths

**fs** functions always return ‘tidy’ paths. Tidy paths

-   Always use `/` to delimit directories
-   never have multiple `/` or trailing `/`

Tidy paths are also coloured (if your terminal supports it) based on the
file permissions and file type. This colouring can be customized or
extended by setting the `LS_COLORS` environment variable, in the same
output format as [GNU
dircolors](http://www.bigsoft.co.uk/blog/index.php/2008/04/11/configuring-ls_colors).

## Usage

**fs** functions are divided into four main categories:

-   `path_` for manipulating and constructing paths
-   `file_` for files
-   `dir_` for directories
-   `link_` for links

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
#> README.md        _pkgdown.yml     codecov.yml      cran-comments.md 
#> fs.Rproj         inst             man              man-roxygen      
#> revdep           src              tests            vignettes

# create a new directory
tmp <- dir_create(file_temp())
tmp
#> /var/folders/9x/_8jnmxwj3rq1t90mlr6_0k1w0000gn/T/Rtmp8qNYF8/file553519e91baa

# create new files in that directory
file_create(path(tmp, "my-file.txt"))
dir_ls(tmp)
#> /var/folders/9x/_8jnmxwj3rq1t90mlr6_0k1w0000gn/T/Rtmp8qNYF8/file553519e91baa/my-file.txt

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
#> /var/folders/9x/_8jnmxwj3rq1t90mlr6_0k1w0000gn/T/Rtmp8qNYF8/file5535783c1027/a
#> /var/folders/9x/_8jnmxwj3rq1t90mlr6_0k1w0000gn/T/Rtmp8qNYF8/file5535783c1027/b
#> /var/folders/9x/_8jnmxwj3rq1t90mlr6_0k1w0000gn/T/Rtmp8qNYF8/file5535783c1027/c
#> /var/folders/9x/_8jnmxwj3rq1t90mlr6_0k1w0000gn/T/Rtmp8qNYF8/file5535783c1027/d
#> /var/folders/9x/_8jnmxwj3rq1t90mlr6_0k1w0000gn/T/Rtmp8qNYF8/file5535783c1027/e

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
#> # A tibble: 12 × 4
#>    path          permissions        size modification_time  
#>    <fs::path>    <fs::perms> <fs::bytes> <dttm>             
#>  1 src/fs.so     rwxr-xr-x        267.7K 2021-11-29 17:54:31
#>  2 src/id.o      rw-r--r--        159.2K 2021-11-29 17:54:10
#>  3 src/dir.o     rw-r--r--         96.7K 2021-11-29 17:54:10
#>  4 src/path.o    rw-r--r--         94.2K 2021-11-29 17:54:10
#>  5 src/link.o    rw-r--r--           76K 2021-11-29 17:54:10
#>  6 src/utils.o   rw-r--r--         75.1K 2021-11-29 17:54:10
#>  7 src/getmode.o rw-r--r--           67K 2021-11-29 17:54:10
#>  8 src/file.o    rw-r--r--         61.5K 2021-11-29 17:54:10
#>  9 src/error.o   rw-r--r--         19.8K 2021-11-29 17:54:10
#> 10 src/init.o    rw-r--r--         17.3K 2021-11-29 17:54:10
#> 11 src/fs.o      rw-r--r--         12.1K 2021-11-29 17:54:10
#> 12 src/file.cc   rw-r--r--         11.5K 2021-11-29 17:54:06
```

Tabulate and display folder size.

``` r
dir_info("src", recurse = TRUE) %>%
  group_by(directory = path_dir(path)) %>%
  tally(wt = size, sort = TRUE)
#> # A tibble: 11 × 2
#>    directory                             n
#>    <chr>                       <fs::bytes>
#>  1 src/libuv-1.38.1                  2.67M
#>  2 src/libuv-1.38.1/src/unix         1.37M
#>  3 src                              986.5K
#>  4 src/libuv-1.38.1/src/win        729.66K
#>  5 src/libuv-1.38.1/src            329.28K
#>  6 src/libuv-1.38.1/include/uv     138.27K
#>  7 src/libuv-1.38.1/include         64.03K
#>  8 src/unix                         63.43K
#>  9 src/bsd                          20.02K
#> 10 src/windows                       4.73K
#> 11 src/libuv-1.38.1/test                64
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
