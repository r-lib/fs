library(testthat)
library(fs)

if (Sys.info()[["sysname"]] != "SunOS") {
  test_check("fs")
}
