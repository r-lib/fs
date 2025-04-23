test_that("examples", {
  path <- fs::path("some", "simple", "path", "to", "a", "file.txt")
  expect_equal(
    path_select_components(path, 1:3),
    path("some", "simple", "path")
  )
  expect_equal(
    path_select_components(path, 1:3, "end"),
    path("to", "a", "file.txt")
  )
  expect_equal(
    path_select_components(path, -1, "end"),
    fs::path("some", "simple", "path", "to", "a")
  )
  expect_equal(
    path_select_components(path, 6),
    path("file.txt"))
})
