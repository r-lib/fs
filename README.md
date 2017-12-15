# fs
[![Travis build status](https://travis-ci.org/r-lib/fs.svg?branch=master)](https://travis-ci.org/r-lib/fs)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://img.shields.io/badge/lifecycle-experimental-orange.svg)
 
The goal of fs is to provide a uniform interface to file operations using [libuv](http://libuv.org/). libuv is used widely in the javascript community underneath [nodejs](https://nodejs.org), so the code is tested by a large community on diverse systems.

## Installation

You can install fs from github with:

``` r
# install.packages("devtools")
devtools::install_github("r-lib/fs")
```

## Motivation vs base equivalents

* All fs functions are vectorized. They accept character vectors as input and
  return a character vector of paths as outputs.

* If an operation fails, fs throws an error.

* fs functions always convert the input paths to UTF-8 and return results as
  UTF-8 encoded paths. This gives you path encoding consistency across OSs.

* fs functions use a consistent naming convention. Because base R's functions
  were gradually added over time there are a number of different conventions 
  used (e.g. `path.expand()` vs `normalizePath()`; `Sys.chmod()` vs 
  `file.access()`).

## Usage

This is a basic example which shows you how to solve a common problem:

``` r
cat(file = "test", "hi")
fs_rename("test", "test2")
readLines("test2")
```

Functions are divided into four main categories: manipulating paths, files, directories, and links.

### Path functions

- `path()` - constructs a new path
- `path_expand()` - expand `~` in a path
- `path_home()` - home directory path
- `path_norm()` - normalizes a path
- `path_split()` - split a path into components
- `path_temp()` - temporary directory path
