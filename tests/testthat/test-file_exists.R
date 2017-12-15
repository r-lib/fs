context("test-file_exists.R")

test_that("basic behaviour is correct", {
  expect_true(file_exists("test-file_exists.R"))
  expect_false(file_exists("NOT HERE"))
})
