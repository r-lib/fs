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
