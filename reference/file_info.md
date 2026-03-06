# Query file metadata

Compared to [`file.info()`](https://rdrr.io/r/base/file.info.html) the
full results of a `stat(2)` system call are returned and some columns
are returned as S3 classes to make manipulation more natural. On systems
which do not support all metadata (such as Windows) default values are
used.

## Usage

``` r
file_info(path, fail = TRUE, follow = FALSE)

file_size(path, fail = TRUE)
```

## Arguments

- path:

  A character vector of one or more paths.

- fail:

  Should the call fail (the default) or warn if a file cannot be
  accessed.

- follow:

  If `TRUE`, symbolic links will be followed (recursively) and the
  results will be that of the final file rather than the link.

## Value

A data.frame with metadata for each file. Columns returned are as
follows.

- path:

  The input path, as a
  [`fs_path()`](https://fs.r-lib.org/reference/fs_path.md) character
  vector.

- type:

  The file type, as a factor of file types.

- size:

  The file size, as a
  [`fs_bytes()`](https://fs.r-lib.org/reference/fs_bytes.md) numeric
  vector.

- permissions:

  The file permissions, as a
  [`fs_perms()`](https://fs.r-lib.org/reference/fs_perms.md) integer
  vector.

- modification_time:

  The time of last data modification, as a
  [POSIXct](https://rdrr.io/r/base/DateTimeClasses.html) datetime.

- user:

  The file owner name - as a character vector.

- group:

  The file group name - as a character vector.

- device_id:

  The file device id - as a numeric vector.

- hard_links:

  The number of hard links to the file - as a numeric vector.

- special_device_id:

  The special device id of the file - as a numeric vector.

- inode:

  The inode of the file - as a numeric vector.

- block_size:

  The optimal block for the file - as a numeric vector.

- blocks:

  The number of blocks allocated for the file - as a numeric vector.

- flags:

  The user defined flags for the file - as an integer vector.

- generation:

  The generation number for the file - as a numeric vector.

- access_time:

  The time of last access - as a
  [POSIXct](https://rdrr.io/r/base/DateTimeClasses.html) datetime.

- change_time:

  The time of last file status change - as a
  [POSIXct](https://rdrr.io/r/base/DateTimeClasses.html) datetime.

- birth_time:

  The time when the inode was created - as a
  [POSIXct](https://rdrr.io/r/base/DateTimeClasses.html) datetime.

## See also

[`dir_info()`](https://fs.r-lib.org/reference/dir_ls.md) to display file
information for files in a given directory.

## Examples

``` r
write.csv(mtcars, "mtcars.csv")
file_info("mtcars.csv")
#> # A tibble: 1 × 18
#>   path       type      size permissions modification_time   user  group
#>   <fs::path> <fct> <fs::by> <fs::perms> <dttm>              <chr> <chr>
#> 1 mtcars.csv file     1.74K rw-r--r--   2026-03-06 14:15:55 runn… runn…
#> # ℹ 11 more variables: device_id <dbl>, hard_links <dbl>,
#> #   special_device_id <dbl>, inode <dbl>, block_size <dbl>,
#> #   blocks <dbl>, flags <int>, generation <dbl>, access_time <dttm>,
#> #   change_time <dttm>, birth_time <dttm>

# Files in the working directory modified more than 20 days ago
files <- file_info(dir_ls())
files$path[difftime(Sys.time(), files$modification_time, units = "days") > 20]
#> character(0)

# Cleanup
file_delete("mtcars.csv")
```
