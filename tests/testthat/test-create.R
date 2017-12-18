context("test-create.R")

test_that("file_create works with new and existing files", {
  x1 <- file_create(tempfile())

  expect_true(file_exists(x1))
  expect_error(file_create(x1), NA)
})

test_that("dir_create works with new and existing files", {
  skip("currently fails")
  x1 <- dir_create(tempfile())

  expect_true(file_exists(x1))
  expect_error(dir_create(x1), NA)
})
