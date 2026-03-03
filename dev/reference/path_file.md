# Manipulate file paths

- `path_file()` returns the filename portion of the path

- `path_dir()` returns the directory portion of the path

- `path_ext()` returns the last extension (if any) for a path

- `path_ext_remove()` removes the last extension and returns the rest of
  the path

- `path_ext_set()` replaces the extension with a new extension. If there
  is no existing extension the new extension is appended

## Usage

``` r
path_file(path)

path_dir(path)

path_ext(path)

path_ext_remove(path)

path_ext_set(path, ext)

path_ext(path) <- value
```

## Arguments

- path:

  A character vector of one or more paths.

- ext, value:

  The new file extension.

## Details

Note because these are not full file paths they return regular character
vectors, not [`fs_path`](https://fs.r-lib.org/dev/reference/fs_path.md)
objects.

## See also

[`base::basename()`](https://rdrr.io/r/base/basename.html),
[`base::dirname()`](https://rdrr.io/r/base/basename.html)

## Examples

``` r
path_file("dir/file.zip")
#> [1] "file.zip"

path_dir("dir/file.zip")
#> [1] "dir"

path_ext("dir/file.zip")
#> [1] "zip"

path_ext("file.tar.gz")
#> [1] "gz"

path_ext_remove("file.tar.gz")
#> [1] "file.tar"

# Only one level of extension is removed
path_ext_set(path_ext_remove("file.tar.gz"), "zip")
#> file.zip
```
