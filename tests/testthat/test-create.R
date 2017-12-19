context("test-create.R")

test_that("file_create works with new and existing files", {
  x1 <- file_create(tempfile())

  expect_true(file_exists(x1))
  expect_error(file_create(x1), NA)
})

test_that("dir_create works with new and existing files", {
  x1 <- dir_create(tempfile())

  expect_true(file_exists(x1))
  expect_error(dir_create(x1), NA)
})

test_that("link_create does not modify existing links", {
  skip("currently failing")
  x <- dir_create(tempfile())

  file_create(path(x, "file1"))
  file_create(path(x, "file2"))

  link_create(path(x, "file1"), path(x, "link"))
  link_create(path(x, "file2"), path(x, "link"))
  expect_equal(link_path(path(x, "link"))[[1]], path(x, "file1"))
})
