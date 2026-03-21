# Copy files, directories or links

`file_copy()` copies files.

`link_copy()` creates a new link pointing to the same location as the
previous link.

`dir_copy()` copies the directory recursively at the new location.

## Usage

``` r
file_copy(path, new_path, overwrite = FALSE)

dir_copy(path, new_path, overwrite = FALSE)

link_copy(path, new_path, overwrite = FALSE)
```

## Arguments

- path:

  A character vector of one or more paths.

- new_path:

  A character vector of paths to the new locations.

- overwrite:

  Overwrite files if they exist. If this is `FALSE` and the file exists
  an error will be thrown.

## Value

The new path (invisibly).

## Details

The behavior of `dir_copy()` differs slightly than that of
[`file.copy()`](https://rdrr.io/r/base/files.html) when
`overwrite = TRUE`. The directory will always be copied to `new_path`,
even if the name differs from the basename of `path`.

## Examples

``` r
file_create("foo")
file_copy("foo", "bar")
try(file_copy("foo", "bar"))
#> Error : [EEXIST] Failed to copy 'foo' to 'bar': file already exists
file_copy("foo", "bar", overwrite = TRUE)
file_delete(c("foo", "bar"))

dir_create("foo")
# Create a directory and put a few files in it
files <- file_create(c("foo/bar", "foo/baz"))
file_exists(files)
#> foo/bar foo/baz 
#>    TRUE    TRUE 

# Copy the directory
dir_copy("foo", "foo2")
file_exists(path("foo2", path_file(files)))
#> foo2/bar foo2/baz 
#>     TRUE     TRUE 

# Create a link to the directory
link_create(path_abs("foo"), "loo")
link_path("loo")
#> /tmp/RtmpZmSuX8/foo
link_copy("loo", "loo2")
link_path("loo2")
#> /tmp/RtmpZmSuX8/foo

# Cleanup
dir_delete(c("foo", "foo2"))
link_delete(c("loo", "loo2"))
```
