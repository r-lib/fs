
test_that("dir_tree() works", {
  withr::with_options(c("cli.unicode" = FALSE), {
    with_dir_tree(list("foo/1" = ""), {
      expect_snapshot(dir_tree("foo"))
    })
  })

  withr::with_options(c("cli.unicode" = FALSE), {
    with_dir_tree(list("foo/1" = "", "foo/2" = "", "foo/3" = "", "foo/4" = ""), {
      expect_snapshot(dir_tree("foo"))
    })
  })

  withr::with_options(c("cli.unicode" = FALSE), {
    with_dir_tree(list("foo/bar/1" = "", "foo/bar/baz/2" = "", "foo/qux/3" = "", "foo/4" = ""), {
      expect_snapshot(dir_tree("foo"))
    })
  })
})
