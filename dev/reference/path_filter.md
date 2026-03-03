# Filter paths

Filter paths

## Usage

``` r
path_filter(path, glob = NULL, regexp = NULL, invert = FALSE, ...)
```

## Arguments

- path:

  A character vector of one or more paths.

- glob:

  A wildcard aka globbing pattern (e.g. `*.csv`) passed on to
  [`grep()`](https://rdrr.io/r/base/grep.html) to filter paths.

- regexp:

  A regular expression (e.g. `[.]csv$`) passed on to
  [`grep()`](https://rdrr.io/r/base/grep.html) to filter paths.

- invert:

  If `TRUE` return files which do *not* match

- ...:

  Additional arguments passed to
  [grep](https://rdrr.io/r/base/grep.html).

## Examples

``` r
path_filter(c("foo", "boo", "bar"), glob = "*oo")
#> foo boo 
path_filter(c("foo", "boo", "bar"), glob = "*oo", invert = TRUE)
#> bar

path_filter(c("foo", "boo", "bar"), regexp = "b.r")
#> bar
```
