# Construct a path to a location within an installed or development package

`path_package` differs from
[`system.file()`](https://rdrr.io/r/base/system.file.html) in that it
always returns an error if the package does not exist. It also returns a
different error if the file within the package does not exist.

## Usage

``` r
path_package(package, ...)
```

## Arguments

- package:

  Name of the package to in which to search

- ...:

  Additional paths appended to the package path by
  [`path()`](https://fs.r-lib.org/reference/path.md).

## Details

`path_package()` also automatically works with packages loaded with
devtools even if the `path_package()` call comes from a different
package.

## Examples

``` r
path_package("base")
#> /opt/R/4.5.3/lib/R/library/base
path_package("stats")
#> /opt/R/4.5.3/lib/R/library/stats
path_package("base", "INDEX")
#> /opt/R/4.5.3/lib/R/library/base/INDEX
path_package("splines", "help", "AnIndex")
#> /opt/R/4.5.3/lib/R/library/splines/help/AnIndex
```
