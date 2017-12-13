# fileuv
[![Travis build status](https://travis-ci.org/jimhester/fileuv.svg?branch=master)](https://travis-ci.org/jimhester/fileuv)

The goal of fileuv is to provide a uniform interface to cross platform file operations using [libuv](http://libuv.org/).

## Installation

You can install fileuv from github with:


``` r
# install.packages("devtools")
devtools::install_github("jimhester/fileuv")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
cat(file = "test", "hi")
file_rename("test", "test2")
readLines("test2")
```
