# Create files, directories, or links

The functions `file_create()` and `dir_create()` ensure that `path`
exists; if it already exists it will be left unchanged. That means that
compared to [`file.create()`](https://rdrr.io/r/base/files.html),
`file_create()` will not truncate an existing file, and compared to
[`dir.create()`](https://rdrr.io/r/base/files2.html), `dir_create()`
will silently ignore existing directories.

## Usage

``` r
file_create(path, ..., mode = "u=rw,go=r")

dir_create(path, ..., mode = "u=rwx,go=rx", recurse = TRUE, recursive)

link_create(path, new_path, symbolic = TRUE)
```

## Arguments

- path:

  A character vector of one or more paths. For `link_create()`, this is
  the target.

- ...:

  Additional arguments passed to
  [`path()`](https://fs.r-lib.org/dev/reference/path.md)

- mode:

  If file/directory is created, what mode should it have?

  Links do not have mode; they inherit the mode of the file they link
  to.

- recurse:

  should intermediate directories be created if they do not exist?

- recursive:

  (Deprecated) If `TRUE` recurse fully.

- new_path:

  The path where the link should be created.

- symbolic:

  Boolean value determining if the link should be a symbolic (the
  default) or hard link.

## Value

The path to the created object (invisibly).

## Examples

``` r
file_create("foo")
is_file("foo")
#>  foo 
#> TRUE 
# dir_create applied to the same path will fail
try(dir_create("foo"))
#> Error : [EEXIST] Failed to make directory 'foo': file already exists

dir_create("bar")
is_dir("bar")
#>  bar 
#> TRUE 
# file_create applied to the same path will fail
try(file_create("bar"))
#> Error : [EISDIR] Failed to open 'bar': illegal operation on a directory

# Cleanup
file_delete("foo")
dir_delete("bar")
```
