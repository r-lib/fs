context("test-file.R")

describe("file_info", {
  with_dir_tree(list("foo/bar" = "test"), {
    link_create("foo", "foo2")

    it("returns a correct tibble", {
      x <- file_info(c("foo", "foo/bar", "foo2"))
      expect_is(x, "tbl_df")
      expect_length(x, 18)
      expect_equal(nrow(x), 3)
      expect_equal(x$path, c("foo", "foo/bar", "foo2"))
      expect_equal(as.character(x$type), c("directory", "file", "symlink"))
    })

    it ("returns NA if a file does not exist", {
      x <- file_info("missing")
      expect_is(x, "tbl_df")
      expect_length(x, 18)
      expect_equal(nrow(x), 1)
      expect_equal(x$path, "missing")
      expect_equal(sum(is.na(x)), 17)
    })
  })
})
