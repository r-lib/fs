# Change owner or group of a file

Change owner or group of a file

## Usage

``` r
file_chown(path, user_id = NULL, group_id = NULL)
```

## Arguments

- path:

  A character vector of one or more paths.

- user_id:

  The user id of the new owner, specified as a numeric ID or name. The R
  process must be privileged to change this.

- group_id:

  The group id of the new owner, specified as a numeric ID or name.
