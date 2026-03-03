# Finding the User Home Directory

- `path_expand()` performs tilde expansion on a path, replacing
  instances of `~` or `~user` with the user's home directory.

- `path_home()` constructs a path within the expanded users home
  directory, calling it with *no* arguments can be useful to verify what
  fs considers the home directory.

- `path_expand_r()` and `path_home_r()` are equivalents which always use
  R's definition of the home directory.

## Usage

``` r
path_expand(path)

path_expand_r(path)

path_home(...)

path_home_r(...)
```

## Arguments

- path:

  A character vector of one or more paths.

- ...:

  Additional paths appended to the home directory by
  [`path()`](https://fs.r-lib.org/dev/reference/path.md).

## Details

`path_expand()` differs from
[`base::path.expand()`](https://rdrr.io/r/base/path.expand.html) in the
interpretation of the home directory of Windows. In particular
`path_expand()` uses the path set in the `USERPROFILE` environment
variable and, if unset, then uses `HOMEDRIVE`/`HOMEPATH`.

In contrast
[`base::path.expand()`](https://rdrr.io/r/base/path.expand.html) first
checks for `R_USER` then `HOME`, which in the default configuration of R
on Windows are both set to the user's document directory, e.g.
`C:\\Users\\username\\Documents`.
[`base::path.expand()`](https://rdrr.io/r/base/path.expand.html) also
does not support `~otheruser` syntax on Windows, whereas `path_expand()`
does support this syntax on all systems.

This definition makes fs more consistent with the definition of home
directory used on Windows in other languages, such as
[python](https://docs.python.org/3/library/os.path.html#os.path.expanduser)
and [rust](https://doc.rust-lang.org/std/env/fn.home_dir.html#windows).
This is also more compatible with external tools such as git and ssh,
both of which put user-level files in `USERPROFILE` by default. It also
allows you to write portable paths, such as `~/Desktop` that points to
the Desktop location on Windows, macOS and (most) Linux systems.

Users can set the `R_FS_HOME` environment variable to override the
definitions on any platform.

## See also

[R for Windows FAQ -
2.14](https://cran.r-project.org/bin/windows/base/rw-FAQ.html#What-are-HOME-and-working-directories_003f)
for behavior of
[`base::path.expand()`](https://rdrr.io/r/base/path.expand.html).

## Examples

``` r
# Expand a path
path_expand("~/bin")
#> /home/runner/bin

# You can use `path_home()` without arguments to see what is being used as
# the home diretory.
path_home()
#> /home/runner
path_home("R")
#> /home/runner/R

# This will likely differ from the above on Windows
path_home_r()
#> /home/runner
```
