# Print contents of directories in a tree-like format

Print contents of directories in a tree-like format

## Usage

``` r
dir_tree(path = ".", recurse = TRUE, ...)
```

## Arguments

- path:

  A path to print the tree from

- recurse:

  If `TRUE` recurse fully, if a positive number the number of levels to
  recurse.

- ...:

  Arguments passed on to
  [`dir_ls`](https://fs.r-lib.org/dev/reference/dir_ls.md)

  `type`

  :   File type(s) to return, one or more of "any", "file", "directory",
      "symlink", "FIFO", "socket", "character_device" or "block_device".

  `all`

  :   If `TRUE` hidden files are also returned.

  `fail`

  :   Should the call fail (the default) or warn if a file cannot be
      accessed.

  `glob`

  :   A wildcard aka globbing pattern (e.g. `*.csv`) passed on to
      [`grep()`](https://rdrr.io/r/base/grep.html) to filter paths.

  `regexp`

  :   A regular expression (e.g. `[.]csv$`) passed on to
      [`grep()`](https://rdrr.io/r/base/grep.html) to filter paths.

  `invert`

  :   If `TRUE` return files which do *not* match
