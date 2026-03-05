# Create, modify and view file permissions

`fs_perms()` objects help one create and modify file permissions easily.
They support both numeric input, octal and symbolic character
representations. Compared to
[octmode](https://rdrr.io/r/base/octmode.html) they support symbolic
representations and display the mode the same format as `ls` on POSIX
systems.

## Usage

``` r
as_fs_perms(x, ...)

fs_perms(x, ...)
```

## Arguments

- x:

  An object which is to be coerced to a fs_perms object. Can be an
  number or octal character representation, including symbolic
  representations.

- ...:

  Additional arguments passed to methods.

## Details

On POSIX systems the permissions are displayed as a 9 character string
with three sets of three characters. Each set corresponds to the
permissions for the user, the group and other (or default) users.

If the first character of each set is a "r", the file is readable for
those users, if a "-", it is not readable.

If the second character of each set is a "w", the file is writable for
those users, if a "-", it is not writable.

The third character is more complex, and is the first of the following
characters which apply.

- 'S' If the character is part of the owner permissions and the file is
  not executable or the directory is not searchable by the owner, and
  the set-user-id bit is set.

- 'S' If the character is part of the group permissions and the file is
  not executable or the directory is not searchable by the group, and
  the set-group-id bit is set.

- 'T' If the character is part of the other permissions and the file is
  not executable or the directory is not searchable by others, and the
  'sticky' (S_ISVTX) bit is set.

- 's' If the character is part of the owner permissions and the file is
  executable or the directory searchable by the owner, and the
  set-user-id bit is set.

- 's' If the character is part of the group permissions and the file is
  executable or the directory searchable by the group, and the
  set-group-id bit is set.

- 't' If the character is part of the other permissions and the file is
  executable or the directory searchable by others, and the ”sticky”
  (S_ISVTX) bit is set.

- 'x' The file is executable or the directory is searchable.

- '-' If none of the above apply. Most commonly the third character is
  either 'x' or `-`.

On Windows the permissions are displayed as a 3 character string where
the third character is only `-` or `x`.

## Examples

``` r
# Integer and numeric
fs_perms(420L)
#> [1] rw-r--r--
fs_perms(c(511, 420))
#> [1] rwxrwxrwx rw-r--r--

# Octal
fs_perms("777")
#> [1] rwxrwxrwx
fs_perms(c("777", "644"))
#> [1] rwxrwxrwx rw-r--r--

# Symbolic
fs_perms("a+rwx")
#> [1] rwxrwxrwx
fs_perms(c("a+rwx", "u+rw,go+r"))
#> [1] rwxrwxrwx rw-r--r--

# Use the `&` and `|`operators to check for certain permissions
(fs_perms("777") & "u+r") == "u+r"
#> [1] TRUE
```
