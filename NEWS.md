# fs 1.2.1

* Fix for a memory issue reported by ASAN and valgrind.

# fs 1.2.0

## Breaking changes

* `path_expand()` and `path_home()` now use `USERPROFILE` or
  `HOMEDRIVE`/`HOMEPATH` as the user home directory on Windows. This differs
  from the definition used in `path.expand()` but is consistent with
  definitions from other programming environments such as python and rust. This
  is also more compatible with external tools such as git and ssh, both of
  which put user-level files in `USERPROFILE` by default. To mimic R's (and
  previous) behavior there are functions `path_expand_r()` and `path_home_r()`.

* Handling missing values are more consistent. In general `is_*` functions
  always return `FALSE` for missing values, `path_*` functions always propagate
  NA values (NA inputs become NA outputs) and `dir_*` `file_*` and `link_*`
  functions error with NA inputs.

* fs functions now preserve tildes in their outputs. Previously paths were
  always returned with tildes expanded. Users can use `path_expand()` to expand
  tildes if desired.

## Bugfixes

* Fix crash when a files user or group id did not exist in the respective
  database (#84, #58)
* Fix home expansion on systems without readline (#60).
* Fix propagation of NA values in `path_norm()` (#63).

## Features

* `file_chmod()` is now vectorized over both of its arguments (#71).
* `link_create()` now fails silently if an identical link already exists (#77).
* `path_package()` function created as an analog to `system.file()` which
  always fails if the package or file does not exist (#75)

# fs 1.1.0

## Breaking changes

* Tidy paths no longer expand `~`.

* Filesystem modification functions now error for NA inputs. (#48)

* `path()` now returns 0 length output if given any 0 length inputs (#54).

## New features

* Removed the autotool system dependency on non-windows systems.

## Bugfixes

* `dir_delete()` now correctly expands paths (#47).

* `dir_delete()` now correctly deletes hidden files and directories (#46).

* `link_path()` now checks for an error before trying to make a string,
  avoiding a crash (#43).

* libuv return paths now marked as UTF-8 strings in C code, fixing encoding
  issues on windows. (#42)

* `dir_copy()` now copies the directory inside the target if the target is a
  directory (#51).

* `dir_copy()` now works correctly with absolute paths and no longer removes
  files when `overwrite = TRUE`.

# fs 1.0.0

* Removed the libbsd system dependency on linux
* Initial release
* Added a `NEWS.md` file to track changes to the package.
