context("test-temp.R")

test_that("file_temp() returns unique temporary files", {
  prev <- file_temp()
  for(i in seq_len(10)) {
    expect_true(file_temp() != prev)
  }
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
