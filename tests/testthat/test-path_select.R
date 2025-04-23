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

test_that("vectorized", {
  path <- c(
    fs::path("some", "simple", "path", "to", "a", "file.txt"),
    fs::path("another", "path", "to", "file2.txt")
  )

  expect_snapshot({
    path_select_components(path, 1:3)
    path_select_components(path, 1:3, "end")
    path_select_components(path, integer())
    unclass(path_select_components(path, integer()))

    path_select_components(fs_path(character()), 1:3)
    path_select_components(fs_path(character()), 1:3, "end")
    class(path_select_components(fs_path(character()), 1:3))
    class(path_select_components(fs_path(character()), 1:3, "end"))
  })
})
