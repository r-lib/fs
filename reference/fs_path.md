# File paths

Tidy file paths, character vectors which are coloured by file type on
capable terminals.

Colouring can be customized by setting the `LS_COLORS` environment
variable, the format is the same as that read by GNU ls / dircolors.

Colouring of file paths can be disabled by setting `LS_COLORS` to an
empty string e.g. `Sys.setenv(LS_COLORS = "")`.

## Usage

``` r
as_fs_path(x)

fs_path(x)
```

## Arguments

- x:

  vector to be coerced to a fs_path object.

## See also

<https://geoff.greer.fm/lscolors>,
<https://github.com/trapd00r/LS_COLORS>,
<https://github.com/seebi/dircolors-solarized> for some example colour
settings.
