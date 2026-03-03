# Change file permissions

Change file permissions

## Usage

``` r
file_chmod(path, mode)
```

## Arguments

- path:

  A character vector of one or more paths.

- mode:

  A character representation of the mode, in either hexidecimal or
  symbolic format.

## Details

**Cross-compatibility warning:** File permissions differ on Windows from
POSIX systems. Windows does not use an executable bit, so attempting to
change this will have no effect. Windows also does not have user groups,
so only the user permissions (`u`) are relevant.

## Examples

``` r
file_create("foo", mode = "000")
file_chmod("foo", "777")
file_info("foo")$permissions
#> [1] rwxrwxrwx

file_chmod("foo", "u-x")
file_info("foo")$permissions
#> [1] rw-rwxrwx

file_chmod("foo", "a-wrx")
file_info("foo")$permissions
#> [1] ---------

file_chmod("foo", "u+wr")
file_info("foo")$permissions
#> [1] rw-------

# It is also vectorized
files <- c("foo", file_create("bar", mode = "000"))
file_chmod(files, "a+rwx")
file_info(files)$permissions
#> [1] rwxrwxrwx rwxrwxrwx

file_chmod(files, c("644", "600"))
file_info(files)$permissions
#> [1] rw-r--r-- rw-------
```
