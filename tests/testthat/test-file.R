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

    it("returns NA if a file does not exist", {
      x <- file_info("missing")
      expect_is(x, "tbl_df")
      expect_length(x, 18)
      expect_equal(nrow(x), 1)
      expect_equal(x$path, "missing")
      expect_equal(sum(is.na(x)), 17)
    })
  })
})

describe("file_chmod", {
  with_dir_tree(list("foo/bar" = "test"), {
    it("returns the input path and changes permissions", {
      expect_equal(file_info("foo/bar")$permissions, fmode("644"))
      expect_equal(file_chmod("foo/bar", "u+x"), "foo/bar")
      expect_equal(file_info("foo/bar")$permissions, fmode("744"))
    })
  })
})

describe("file_delete", {
  with_dir_tree(list("foo/bar" = "test"), {
    it("returns the input path and deletes the file", {
      expect_true(file_exists("foo/bar"))
      expect_equal(file_delete("foo/bar"), "foo/bar")
      expect_false(file_exists("foo/bar"))
    })
  })
})

describe("file_delete", {
  with_dir_tree(list("foo/bar" = "test"), {
    it("returns the new path and copies the file", {
      expect_true(file_exists("foo/bar"))
      expect_false(file_exists("foo/bar2"))
      expect_equal(file_copy("foo/bar", "foo/bar2"), "foo/bar2")
      expect_true(file_exists("foo/bar"))
      expect_true(file_exists("foo/bar2"))
    })
    it("fails if the new or existing directory does not exist", {
      expect_true(file_exists("foo/bar"))
      expect_error(file_copy("baz/bar", "foo/bar3"), class = "ENOENT")
      expect_error(file_copy("foo/bar", "baz/qux"), class = "ENOENT")
    })
  })
})

describe("file_chown", {
  with_dir_tree(list("foo/bar" = "test"), {
    it("changes the ownership of a file, returns the input path", {
      skip("need elevated permissions to change uid")

      # Make everyone have write access, so we can delete this after changing ownership
      file_chmod("foo/bar", "a+w")

      # Change ownership to root
      expect_equal(file_chown("foo/bar", user_id = 0), "foo/bar")
      expect_true(file_info("foo/bar")$user_id == 0)
    })
  })
})
