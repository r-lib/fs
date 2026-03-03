# Change file access and modification times

Like the touch POSIX utility this will create the file if it does not
exist.

## Usage

``` r
file_touch(path, access_time = Sys.time(), modification_time = access_time)
```

## Arguments

- path:

  A character vector of one or more paths.

- access_time, modification_time:

  The times to set, inputs will be coerced to
  [POSIXct](https://rdrr.io/r/base/DateTimeClasses.html) objects.

## Examples

``` r
file_touch("foo", "2018-01-01")
file_info("foo")[c("access_time", "modification_time", "change_time", "birth_time")]
#> # A tibble: 1 × 4
#>   access_time         modification_time   change_time        
#>   <dttm>              <dttm>              <dttm>             
#> 1 2018-01-01 00:00:00 2018-01-01 00:00:00 2026-03-03 18:32:35
#> # ℹ 1 more variable: birth_time <dttm>
```
