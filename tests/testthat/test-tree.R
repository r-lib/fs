context("test-tree.R")

test_that("dir_tree() works", {
  withr::with_options(c("cli.unicode" = TRUE), {
    reference <- fs::path_abs(test_path("ref-tree-1"))
    with_dir_tree(list("foo/1" = ""), {
      expect_known_output(dir_tree("foo"), reference)
    })
  })

  withr::with_options(c("cli.unicode" = TRUE), {
    reference <- fs::path_abs(test_path("ref-tree-2"))
    with_dir_tree(list("foo/1" = "", "foo/2" = "", "foo/3" = "", "foo/4" = ""), {
      expect_known_output(dir_tree("foo"), reference)
    })
  })

  withr::with_options(c("cli.unicode" = TRUE), {
    reference <- fs::path_abs(test_path("ref-tree-3"))
    with_dir_tree(list("foo/bar/1" = "", "foo/bar/baz/2" = "", "foo/qux/3" = "", "foo/4" = ""), {
      expect_known_output(dir_tree("foo"), reference)
    })
  })
})
