context("test-access.R")

describe("file_access", {
  with_dir_tree(list("foo/bar" = "test"), {
    it("errors on missing input", {
      expect_error(file_access(NA), class = "invalid_argument")
    })
    it("checks for file existence", {
      expect_equal(file_access("foo", "exists"), c(foo = TRUE))
    })
    it("checks for file read and write ability", {
      skip_on_os(c("windows", "solaris"))
      file_chmod("foo/bar", "-rw")
      expect_equal(file_access("foo/bar", "read"), c("foo/bar" = FALSE))
      expect_equal(file_access("foo/bar", "write"), c("foo/bar" = FALSE))

      file_chmod("foo/bar", "+rw")
      expect_equal(file_access("foo/bar", "read"), c("foo/bar" = TRUE))
      expect_equal(file_access("foo/bar", "write"), c("foo/bar" = TRUE))
    })
    it("checks for file execute ability", {
      skip_on_os(c("windows", "solaris"))
      file_chmod("foo/bar", "-x")
      expect_equal(file_access("foo/bar", "execute"), c("foo/bar" = FALSE))
      file_chmod("foo/bar", "+x")
      expect_equal(file_access("foo/bar", "execute"), c("foo/bar" = TRUE))
    })
  })
})

with_dir_tree(list("foo/bar"  = "test"), {
  link_create(path_abs("foo"), "loo")

  describe("file_exists", {
    it("returns true for files that exist, false for those that do not", {
      expect_equal(file_exists("foo"), c(foo = TRUE))
      expect_equal(file_exists("missing"), c(missing = FALSE))
      expect_equal(
        file_exists(c("foo", "missing", "foo/bar", "loo")),
        c(foo = TRUE, missing = FALSE, "foo/bar" = TRUE, "loo" = TRUE))
    })
    it("returns FALSE on missing input", {
      expect_identical(file_exists(NA_character_), structure(names = NA, FALSE))
    })
  })

  describe("dir_exists", {
    it("returns true for dir that exist, false for those that do not or are not directories", {
      expect_equal(dir_exists("foo"), c(foo = TRUE))
      expect_equal(dir_exists("missing"), c(missing = FALSE))
      expect_equal(
        dir_exists(c("foo", "missing", "foo/bar")),
        c(foo = TRUE, missing = FALSE, "foo/bar" = FALSE))
    })
    it("returns true for links to directories, like -d in bash", {
        expect_equal(dir_exists("loo"), c(loo = TRUE))
    })
    it("returns FALSE on missing input", {
      expect_identical(dir_exists(NA_character_), structure(names = NA, FALSE))
    })
  })

  describe("link_exists", {
    it("returns true for link that exist, false for those that do not or are not symlinks", {
      expect_equal(link_exists("loo"), c(loo = TRUE))
      expect_equal(link_exists("missing"), c(missing = FALSE))
      expect_equal(
        link_exists(c("foo", "missing", "foo/bar", "loo")),
        c(foo = FALSE, missing = FALSE, "foo/bar" = FALSE, "loo" = TRUE))
    })
    it("returns FALSE on missing input", {
      expect_identical(link_exists(NA_character_), structure(names = NA, FALSE))
    })
  })
})
