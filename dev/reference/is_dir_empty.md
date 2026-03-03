# Check if a directory is empty

This function checks whether a given directory is empty or not.

## Usage

``` r
is_dir_empty(path)
```

## Arguments

- path:

  A character string specifying the path to the directory to check.

## Value

A logical value. Returns `TRUE` if the directory is empty, `FALSE`
otherwise.

## Examples

``` r
if (FALSE) { # \dontrun{
is_dir_empty("path/to/empty/directory")  # Returns TRUE
is_dir_empty("path/to/non-empty/directory")  # Returns FALSE
} # }
```
