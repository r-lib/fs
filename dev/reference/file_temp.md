# Create names for temporary files

`file_temp()` returns the name which can be used as a temporary file.

## Usage

``` r
file_temp(pattern = "file", tmp_dir = tempdir(), ext = "")

file_temp_push(path)

file_temp_pop()

path_temp(...)
```

## Arguments

- pattern:

  A character vector with the non-random portion of the name.

- tmp_dir:

  The directory the file will be created in.

- ext:

  The file extension of the temporary file.

- path:

  A character vector of one or more paths.

- ...:

  Additional paths appended to the temporary directory by
  [`path()`](https://fs.r-lib.org/dev/reference/path.md).

## Details

`file_temp_push()` can be used to supply deterministic entries in the
temporary file stack. This can be useful for reproducibility in like
example documentation and vignettes.

`file_temp_pop()` can be used to explicitly remove an entry from the
internal stack, however generally this is done instead by calling
`file_temp()`.

`path_temp()` constructs a path within the session temporary directory.

## Examples

``` r
path_temp()
#> /tmp/RtmpP520iT
path_temp("does-not-exist")
#> /tmp/RtmpP520iT/does-not-exist

file_temp()
#> /tmp/filedd461c46df20
file_temp(ext = "png")
#> /tmp/RtmpP520iT/file1e7f31b1b743.png
file_temp("image", ext = "png")
#> /tmp/RtmpP520iT/image1e7f7f28be0f.png


# You can make the temp file paths deterministic
file_temp_push(letters)
file_temp()
#> a
file_temp()
#> b

# Or explicitly remove values
while (!is.null(file_temp_pop())) next
file_temp_pop()
#> NULL
```
