context("test-file.R")

describe("file_info", {
  with_dir_tree(list(
      "foo/bar" = "test",
      "NA" = ""), {
    link_create(path_abs("foo"), "foo2")

    it("returns a correct tibble", {
      x <- file_info(c("foo", "foo/bar", "foo2", "NA"))
      expect_is(x, c("tbl", "tbl_df", "data.frame"))
      expect_length(x, 18)
      expect_equal(nrow(x), 4)
      expect_equal(as.character(x$path), c("foo", "foo/bar", "foo2", "NA"))
      expect_equal(as.character(x$type), c("directory", "file", "symlink", "file"))
    })

    it("returns NA if a file does not exist", {
      x <- file_info("missing")
      expect_is(x, c("tbl", "tbl_df", "data.frame"))
      expect_length(x, 18)
      expect_equal(nrow(x), 1)
      expect_equal(as.character(x$path), "missing")
      expect_equal(sum(is.na(x)), 17)
    })
    it("returns NA on NA input", {
      x <- file_info(NA_character_)
      expect_is(x, c("tbl", "tbl_df", "data.frame"))
      expect_length(x, 18)
      expect_equal(nrow(x), 1)
      expect_equal(as.character(x$path), NA_character_)
      expect_equal(sum(is.na(x)), 18)
    })
  })
})

# Windows permissions only really allow setting read only, so we will skip
# the more thorough tests
if (!is_windows()) {
  describe("file_chmod", {
    with_dir_tree(list("foo/bar" = "test"), {
      it("returns the input path and changes permissions with symbolic input", {
        expect_equal(file_chmod("foo/bar", "u=rw,go=r"), "foo/bar")
        expect_equal(file_info("foo/bar")$permissions, "644")
        expect_equal(file_chmod("foo/bar", "u+x"), "foo/bar")
        expect_equal(file_info("foo/bar")$permissions, "744")
        expect_equal(file_chmod("foo/bar", "g-r"), "foo/bar")
        expect_equal(file_info("foo/bar")$permissions, "704")
        expect_equal(file_chmod("foo/bar", "o-r"), "foo/bar")
        expect_equal(file_info("foo/bar")$permissions, "700")
      })

      it("returns the input path and changes permissions with octal input", {
        expect_equal(file_chmod("foo/bar", "644"), "foo/bar")
        expect_true(file_info("foo/bar")$permissions == "644")
        expect_equal(file_chmod("foo/bar", "744"), "foo/bar")
        expect_equal(file_info("foo/bar")$permissions, "744")
        expect_equal(file_chmod("foo/bar", "704"), "foo/bar")
        expect_equal(file_info("foo/bar")$permissions, "704")
        expect_equal(file_chmod("foo/bar", "700"), "foo/bar")
        expect_equal(file_info("foo/bar")$permissions, "700")
      })

      it("returns the input path and changes permissions with display input", {
        expect_equal(file_chmod("foo/bar", "rw-r--r--"), "foo/bar")
        expect_true(file_info("foo/bar")$permissions == "644")
        expect_equal(file_chmod("foo/bar", "rwxr--r--"), "foo/bar")
        expect_equal(file_info("foo/bar")$permissions, "744")
        expect_equal(file_chmod("foo/bar", "rwx---r--"), "foo/bar")
        expect_equal(file_info("foo/bar")$permissions, "704")
        expect_equal(file_chmod("foo/bar", "rwx------"), "foo/bar")
        expect_equal(file_info("foo/bar")$permissions, "700")
      })

      it("errors if given an invalid mode", {
        expect_error(file_chmod("foo", "g+S"), "Invalid mode 'g\\+S'")
      })
      it("errors on missing input", {
        expect_error(file_chmod(NA, "u+x"), class = "invalid_argument")
      })
    })
  })
}

describe("file_copy", {
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
    it("errors on missing input", {
      expect_error(file_copy(NA, "foo"), class = "invalid_argument")
      expect_error(file_copy("foo/bar", NA), class = "invalid_argument")
    })
  })
})

describe("file_chown", {
  skip("need elevated permissions to change uid")
  with_dir_tree(list("foo/bar" = "test"), {
    it("changes the ownership of a file, returns the input path", {

      # Make everyone have write access, so we can delete this after changing ownership
      file_chmod("foo/bar", "a+w")

      # Change ownership to root
      expect_equal(file_chown("foo/bar", user_id = 0), "foo/bar")
      expect_true(file_info("foo/bar")$user_id == 0)
    })
    it("errors on missing input", {
      expect_error(file_copy(NA, user_id = 0), class = "invalid_argument")
    })
  })
})
