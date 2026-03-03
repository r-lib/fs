# Sanitize a filename by removing directory paths and invalid characters

`path_sanitize()` removes the following:

- [Control
  characters](https://en.wikipedia.org/wiki/C0_and_C1_control_codes)

- [Reserved
  characters](https://web.archive.org/web/20230126161942/https://kb.acronis.com/content/39790)

- Unix reserved filenames (`.` and `..`)

- Trailing periods and spaces (invalid on Windows)

- Windows reserved filenames (`CON`, `PRN`, `AUX`, `NUL`, `COM1`,
  `COM2`, `COM3`, COM4, `COM5`, `COM6`, `COM7`, `COM8`, `COM9`, `LPT1`,
  `LPT2`, `LPT3`, `LPT4`, `LPT5`, `LPT6`, LPT7, `LPT8`, and `LPT9`) The
  resulting string is then truncated to [255 bytes in
  length](https://en.wikipedia.org/wiki/Comparison_of_file_systems#Limits)

## Usage

``` r
path_sanitize(filename, replacement = "")
```

## Arguments

- filename:

  A character vector to be sanitized.

- replacement:

  A character vector used to replace invalid characters.

## See also

<https://www.npmjs.com/package/sanitize-filename>, upon which this
function is based.

## Examples

``` r
# potentially unsafe string
str <- "~/.\u0001ssh/authorized_keys"
path_sanitize(str)
#> [1] "~.sshauthorized_keys"

path_sanitize("..")
#> [1] ""
```
