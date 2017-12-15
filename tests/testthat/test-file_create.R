context("test-file_create.R")

test_that("create works with new and existing files", {
  x1 <- file_create(tempfile())

  expect_true(file.exists(x1))
  expect_error(file_create(x1), NA)
})
