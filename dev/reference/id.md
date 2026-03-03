# Lookup Users and Groups on a system

These functions use the GETPWENT(3) and GETGRENT(3) system calls to
query users and groups respectively.

## Usage

``` r
group_ids()

user_ids()
```

## Value

They return their results in a `data.frame`. On windows both functions
return an empty `data.frame` because windows does not have user or group
ids.

## Examples

``` r
# list first 6 groups
head(group_ids())
#>   group_id group_name
#> 1        0       root
#> 2        1     daemon
#> 3        2        bin
#> 4        3        sys
#> 5        4        adm
#> 6        5        tty

# list first 6 users
head(user_ids())
#>   user_id user_name
#> 1       0      root
#> 2       1    daemon
#> 3       2       bin
#> 4       3       sys
#> 5       4      sync
#> 6       5     games
```
