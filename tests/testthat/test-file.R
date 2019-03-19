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

describe("file_size", {
  with_dir_tree(list(
      "foo" = "test",
      "bar" = "test2"), {
      it("returns the correct file size", {
        expect_equal(file_size("foo"), stats::setNames(file_info("foo")$size, "foo"))
        expect_equal(file_size("bar"), stats::setNames(file_info("bar")$size, "bar"))
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

      it("is vectorized over files and permissions", {
        file_create("foo/baz")
        files <- c("foo/bar", "foo/baz")
        expect_equal(file_chmod(files, "000"), files)
        expect_true(all(file_info(files)$permissions == c("000", "000")))

        expect_equal(file_chmod(files, "644"), files)
        expect_true(all(file_info(files)$permissions == c("644", "644")))

        expect_equal(file_chmod(files, c("u+x", "o+x")), files)
        expect_true(all(file_info(files)$permissions == c("744", "645")))

        expect_error(file_chmod(files, c("u+x", "o+x", "g+x")), class = "invalid_argument")
      })
    })
  })
}

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
    it("errors on missing input", {
      expect_error(file_chown(NA, user_id = 0), class = "invalid_argument")
    })
  })
})

describe("file_move", {
  it("renames files in the same directory", {
    with_dir_tree(list("foo" = "test"), {
      expect_true(file_exists("foo"))
      expect_equal(file_move("foo", "bar"), "bar")
      expect_false(file_exists("foo"))
      expect_true(file_exists("bar"))
    })
  })

  it("renames files in different directories", {
    with_dir_tree(list("foo/bar" = "test", "foo2"), {
      expect_true(file_exists("foo/bar"))
      expect_true(file_exists("foo2"))
      expect_equal(file_move("foo/bar", "foo2"), "foo2/bar")
      expect_false(file_exists("foo/bar"))
      expect_true(file_exists("foo2/bar"))

      expect_error(file_move("foo/bar", c("foo2", "foo3")), class = "fs_error")
    })
  })
  it("errors on missing input", {
    expect_error(file_move(NA, "foo2"), class = "invalid_argument")
    expect_error(file_move("foo", NA), class = "invalid_argument")
  })
})

describe("file_touch", {
  it("updates modification_time and access_time", {
    with_dir_tree("dir", {
      file_create("foo")
      now <- Sys.time()

      file_touch("foo", now)
      old <- file_info("foo")

      file_touch("foo", now + 10, now + 20)

      new <- file_info("foo")
      expect_true(old$modification_time < new$modification_time)
      expect_true(old$access_time < new$access_time)

      file_touch("foo", now - 10, now - 20)
      new2 <- file_info("foo")
      expect_true(old$modification_time > new2$modification_time)
      expect_true(old$access_time > new2$access_time)
    })
  })

  it("errors on missing input", {
    expect_error(file_touch(NA), class = "invalid_argument")
  })

  it("creates the file if it doesn't exist", {
    with_dir_tree("dir", {
      file_touch("foo")
      expect_true(file_exists("foo"))
    })
  })
})
