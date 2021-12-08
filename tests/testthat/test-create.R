context("test-create.R")

test_that("file_create works with new and existing files", {
  x1 <- file_create(tempfile())

  expect_true(file_exists(x1))
  expect_error(file_create(x1), NA)
  expect_error(file_create(NA), class = "invalid_argument")

  unlink(x1)
})

test_that("dir_create works with new and existing files", {
  x1 <- dir_create(tempfile())

  expect_true(file_exists(x1))
  expect_error(dir_create(x1), NA)
  expect_error(dir_create(NA), class = "invalid_argument")

  unlink(x1, recursive = TRUE)
})

test_that("file_create works with multiple path arguments", {
  x1 <- file_create(tempdir(), "foo")

  expect_equal(x1, path(tempdir(), "foo"))
  expect_true(file_exists(x1))

  unlink(x1)
})

test_that("dir_create works with multiple path arguments", {
  x1 <- dir_create(tempdir(), "foo", "bar")
  x2 <- dir_create(tempdir(), "foo", "baz", recurse = FALSE)

  expect_equal(x1, path(tempdir(), "foo", "bar"))
  expect_equal(x2, path(tempdir(), "foo", "baz"))
  expect_true(dir_exists(x1))
  expect_true(dir_exists(x2))

  unlink(x1)
  unlink(x2)
})

test_that("dir_create sets the mode properly", {
  skip_on_cran()
  skip_on_os("windows")
  x1 <- dir_create(tempfile(), mode = "775")

  expect_true(file_exists(x1))
  expect_equal(file_info(x1)$permissions, "775")

  unlink(x1, recursive = TRUE)
})

test_that("dir_create works with absolute paths and recurse = FALSE (#204)", {
  x1 <- dir_create(path_abs(tempfile()), recurse = FALSE)

  expect_true(file_exists(x1))

  unlink(x1, recursive = TRUE)
})

test_that("dir_create fails silently if the directory or link exists and fails if a file exists", {
  with_dir_tree(c("foo/bar" = ""), {
    expect_error_free(dir_create("foo"))
    expect_error(dir_create("foo/bar"), class = "EEXIST")
  })
})

test_that("dir_create fails with EACCES if it cannot create the directory", {
  skip_on_os("windows")
  skip_on_cran()
  if (Sys.info()[["effective_user"]] == "root") skip("root user")

  with_dir_tree("foo", {
    # Set current directly as read-only
    file_chmod(".", "u-w")
    expect_error(dir_create("bar"), class = "EACCES")
  })
})

test_that("link_create does not modify existing links", {

  # Windows does not currently support file based symlinks
  skip_on_os("windows")

  x <- dir_create(tempfile())

  dir_create(path(x, "dir1"))
  dir_create(path(x, "dir2"))

  link_create(path(x, "dir1"), path(x, "link"))
  expect_error(link_create(path(x, "dir2"), path(x, "link")), "file already exists", class = "EEXIST")
  expect_equal(link_path(path(x, "link")), path(x, "dir1"))

  expect_error(link_create(NA), class = "invalid_argument")
  expect_error(link_create(path(x, "dir2"), NA), class = "invalid_argument")
})
