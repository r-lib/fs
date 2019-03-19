context("test-temp.R")

test_that("file_temp() returns unique temporary files", {
  prev <- file_temp()
  for(i in seq_len(10)) {
    expect_true(file_temp() != prev)
  }
})

test_that("file_temp() extension applied correctly", {
  tmp_no_ext <- file_temp()
  tmp_has_ext <- file_temp(ext = "pdf")
  expect_equal(path_ext(tmp_no_ext), "")
  expect_equal(path_ext(tmp_has_ext), "pdf")

  exts = c("xlsx", "doc", "")
  tmpfile_multiple <- tempfile(fileext = paste0(c(".", ".", ""), exts))
  file_temp_multiple <- file_temp(ext = exts)
  expect_equal(path_ext(file_temp_multiple), path_ext(tmpfile_multiple))

  expect_equal(
    path_ext(file_temp(ext = "pdf")),
    path_ext(file_temp(ext = ".pdf"))
  )
})

test_that("file_temp() can use have deterministic results if desired", {
  prev <- file_temp()
  file_temp_push(c("foo", "bar", "baz", "bar"))
  expect_equal(file_temp(), "foo")
  expect_equal(file_temp(), "bar")
  expect_equal(file_temp(), "baz")

  file_temp_pop()
  x <- file_temp()
  expect_true(x != "bar" && x != prev)
})

test_that("file_temp() errors if given NA input", {
  expect_error(file_temp(tmp_dir = NA), class = "invalid_argument")
})
