# Select path components by their position/index.

`path_select_components()` allows to select individual components from
an `fs_path` object via their index.

## Usage

``` r
path_select_components(path, index, from = c("start", "end"))
```

## Arguments

- path:

  A path of class `fs_path`.

- index:

  An integer vector of path positions. (A negative index will work
  according to R's usual subsetting rules.)

- from:

  A character of either `"start"` or `"end"` to choose if indexing
  should start from the first or last component of the `path`.

## Value

An `fs_path` object, which is a character vector that also has class
`fs_path`.

## Details

`path_select_components()` is vectorized.

## Examples

``` r
path <- fs::path("some", "simple", "path", "to", "a", "file.txt")

path_select_components(path, 1:3)
#> some/simple/path

path_select_components(path, 1:3, "end")
#> to/a/file.txt

path_select_components(path, -1, "end")
#> some/simple/path/to/a

path_select_components(path, 6)
#> file.txt
```
