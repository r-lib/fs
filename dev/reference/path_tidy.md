# Tidy paths

Untidy paths are all different, tidy paths are all the same. Tidy paths
always use `/` to delimit directories, never have multiple `/` or
trailing `/` and have colourised output based on the file type.

## Usage

``` r
path_tidy(path)
```

## Arguments

- path:

  A character vector of one or more paths.

## Value

An `fs_path` object, which is a character vector that also has class
`fs_path`
