# fs
[![Travis build status](https://travis-ci.org/r-lib/fs.svg?branch=master)](https://travis-ci.org/r-lib/fs)

The goal of fs is to provide a uniform interface to cross platform file operations using [libuv](http://libuv.org/).

## Installation

You can install fs from github with:


``` r
# install.packages("devtools")
devtools::install_github("r-lib/fs")
```

## Motivation vs base equivalents

fs functions always convert the input paths to UTF-8 and return results as
UTF-8 encoded paths. This gives you path encoding consistency across OSs.

All fs functions are vectorized. They accept character vectors as input and
return equivalent character vectors as outputs.

fs functions use a consistent naming convention. Because base R's functions
were gradually added over time there are a number of different conventions used
across a handful of different packages, which makes function discovery more
difficult.

libuv is used widely in the javascript community underneath
[nodejs](https://nodejs.org), so the code is tested by a large community on
diverse systems.

## Example

This is a basic example which shows you how to solve a common problem:

``` r
cat(file = "test", "hi")
fs_rename("test", "test2")
readLines("test2")
```

## Path functions

- `path()` - constructs a new path
- `path_expand()` - expand `~` in a path
- `path_home()` - home directory path
- `path_norm()` - normalizes a path
- `path_split()` - split a path into components
- `path_temp()` - temporary directory path
