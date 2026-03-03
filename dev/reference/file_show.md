# Open files or directories

Open files or directories

## Usage

``` r
file_show(path = ".", browser = getOption("browser"))
```

## Arguments

- path:

  A character vector of one or more paths.

- browser:

  a non-empty character string giving the name of the program to be used
  as the HTML browser. It should be in the PATH, or a full path
  specified. Alternatively, an R function to be called to invoke the
  browser.

  Under Windows `NULL` is also allowed (and is the default), and implies
  that the file association mechanism will be used.

## Value

The directories that were opened (invisibly).
