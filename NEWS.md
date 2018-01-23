# fs 1.0.0.9000

* Removed the autotool system dependency on non-windows systems.

## Bugfixes

* `dir_delete()` now correctly expands paths (#47).

* `dir_delete()` now correctly deletes hidden files and directories (#46).

* `link_path()` now checks for an error before trying to make a string,
  avoiding a crash (#43).

* libuv return paths now marked as UTF-8 strings in C code, fixing encoding
  issues on windows. (#42)

# fs 1.0.0

* Removed the libbsd system dependency on linux
* Initial release
* Added a `NEWS.md` file to track changes to the package.
