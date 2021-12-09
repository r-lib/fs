context("fs_select")

path <- fs::path("some", "simple", "path", "to", "a", "file.txt")

test_that("examples", {
  expect_equal(
    path_select(path, 1:3),
    path("some", "simple", "path")
  )
  expect_equal(
    path_select(path, 1:3, "end"),
    path("to", "a", "file.txt")
  )
  expect_equal(
    path_select(path, -1, "end"),
    fs::path("some", "simple", "path", "to", "a")
  )
  expect_equal(
    path_select(path, 6),
    path("file.txt"))
})
