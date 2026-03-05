# Delete files, directories, or links

`file_delete()` and `link_delete()` delete file and links. Compared to
[file.remove](https://rdrr.io/r/base/files.html) they always fail if
they cannot delete the object rather than changing return value or
signalling a warning. If any inputs are directories, they are passed to
`dir_delete()`, so `file_delete()` can therefore be used to delete any
filesystem object.

`dir_delete()` will first delete the contents of the directory, then
remove the directory. Compared to
[unlink](https://rdrr.io/r/base/unlink.html) it will always throw an
error if the directory cannot be deleted rather than being silent or
signalling a warning.

## Usage

``` r
file_delete(path)

dir_delete(path)

link_delete(path)
```

## Arguments

- path:

  A character vector of one or more paths.

## Value

The deleted paths (invisibly).

## Examples

``` r
# create a directory, with some files and a link to it
dir_create("dir")
files <- file_create(path("dir", letters[1:5]))
link <- link_create(path_abs("dir"), "link")

# All files created
dir_exists("dir")
#>  dir 
#> TRUE 
file_exists(files)
#> dir/a dir/b dir/c dir/d dir/e 
#>  TRUE  TRUE  TRUE  TRUE  TRUE 
link_exists("link")
#> link 
#> TRUE 
file_exists(link_path("link"))
#> /tmp/Rtmp0JerhN/dir 
#>                TRUE 

# Delete a file
file_delete(files[1])
file_exists(files[1])
#> dir/a 
#> FALSE 

# Delete the directory (which deletes the files as well)
dir_delete("dir")
file_exists(files)
#> dir/a dir/b dir/c dir/d dir/e 
#> FALSE FALSE FALSE FALSE FALSE 
dir_exists("dir")
#>   dir 
#> FALSE 

# The link still exists, but what it points to does not.
link_exists("link")
#> link 
#> TRUE 
dir_exists(link_path("link"))
#> /tmp/Rtmp0JerhN/dir 
#>               FALSE 

# Delete the link
link_delete("link")
link_exists("link")
#>  link 
#> FALSE 
```
