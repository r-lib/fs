context("test-copy.R")

describe("file_copy", {
  it("copies an empty file and returns the new path", {
    with_dir_tree(list("foo" = ""), {
      expect_true(file_exists("foo"))
      expect_equal(file_copy("foo", "foo2"), "foo2")
      expect_true(file_exists("foo"))
      expect_true(file_exists("foo2"))
    })
  })

  it("copies a non-empty file and returns the new path", {
    with_dir_tree(
      list("foo" = "test"), {
      expect_true(file_exists("foo"))
      expect_equal(file_copy("foo", "foo2"), "foo2")
      expect_true(file_exists("foo"))
      expect_true(file_exists("foo2"))
      expect_equal(readLines("foo2"), readLines("foo"))
    })
  })
  it("copies multiple files", {
    with_dir_tree(list("foo" = "test", "bar" = "test2"), {
      expect_equal(file_exists(c("foo", "bar")), c(foo = TRUE, bar = TRUE))
      expect_equal(file_copy(c("foo", "bar"), c("foo2", "bar2")),
        c("foo2", "bar2"))
      expect_equal(readLines("foo2"), readLines("foo"))
      expect_equal(readLines("bar2"), readLines("bar"))
    })
  })
  it("errors on missing input", {
    expect_error(file_copy(NA, "foo2"), class = "invalid_argument")
    expect_error(file_copy("foo", NA), class = "invalid_argument")
  })
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
  it("copies files in different directories", {
    with_dir_tree(list("foo/bar" = "test", "foo3/bar2" = "test2", "foo2"), {
      expect_true(file_exists("foo/bar"))
      expect_true(file_exists("foo2"))
      expect_equal(file_copy(c("foo/bar", "foo3/bar2"), "foo2"), c("foo2/bar", "foo2/bar2"))
      expect_true(file_exists("foo/bar"))
      expect_true(file_exists("foo3/bar2"))
      expect_true(file_exists("foo2/bar"))
      expect_true(file_exists("foo2/bar2"))

      expect_error(file_copy("foo/bar", c("foo2", "foo3")), class = "fs_error")
    })
  })
})

describe("link_copy", {
  it("copies links and returns the new path", {
    with_dir_tree(list("foo"), {
      link_create(path_abs("foo"), "loo")
      expect_true(dir_exists("foo"))
      expect_true(link_exists("loo"))
      expect_equal(link_copy("loo", "loo2"), "loo2")

      expect_true(link_exists("loo2"))
      expect_equal(link_path("loo2"), link_path("loo"))
    })
  })
  it("errors on missing input", {
    expect_error(link_copy(NA, "foo2"), class = "invalid_argument")
    expect_error(link_copy("foo", NA), class = "invalid_argument")
  })
})

describe("dir_copy", {
  it("copies an empty directory and returns the new path", {
    with_dir_tree(list("foo"), {
      expect_true(dir_exists("foo"))
      expect_equal(dir_copy("foo", "foo2"), "foo2")
      expect_true(dir_exists("foo"))
      expect_true(dir_exists("foo2"))
    })
  })
  it("copies a non-empty directory and returns the new path", {
    with_dir_tree(
      list("foo/bar" = "test",
        "foo/baz" = "test2"), {
      expect_true(dir_exists("foo"))
      expect_equal(dir_copy("foo", "foo2"), "foo2")
      expect_true(dir_exists("foo"))
      expect_true(dir_exists("foo2"))
      expect_true(file_exists("foo2/bar"))
    })
  })
  it("copies directories into other directories", {
    with_dir_tree(
      list("foo/bar" = "test"), {
        dir_create("foo2")
        expect_equal(dir_copy("foo", "foo2"), "foo2/foo")
        expect_true(dir_exists("foo"))
        expect_true(dir_exists("foo2"))
        expect_true(dir_exists("foo2/foo"))
        expect_true(file_exists("foo2/foo/bar"))
    })
  })
  it("copies nested directories and returns the path", {
    with_dir_tree(
      list("foo/bar/baz" = "test",
        "foo/baz/qux" = "test2"), {
      expect_true(dir_exists("foo"))
      expect_equal(dir_copy("foo", "foo2"), "foo2")
      expect_true(dir_exists("foo"))
      expect_true(dir_exists("foo2"))
      expect_true(file_exists("foo2/bar/baz"))
    })
  })
  it("copies absolute paths", {
    with_dir_tree(
      list("foo/bar/baz" = "test",
        "foo/baz/qux" = "test2"), {
      expect_equal(dir_copy(path_abs("foo"), path_abs("foo2")), path_abs("foo2"))
      expect_true(dir_exists("foo2"))
      expect_true(dir_exists(path_abs("foo2")))
    })
  })
  it("copies hidden files, directories and links", {
    with_dir_tree(
      list("foo/.bar/.baz" = "test"), {
        link_create(path_abs("foo/.bar"), "foo/.qux")
      expect_equal(dir_copy("foo", "foo2"), "foo2")
      expect_true(dir_exists("foo2"))
      expect_true(dir_exists("foo2/.bar"))
      expect_true(file_exists("foo2/.bar/.baz"))
      expect_true(link_exists("foo2/.qux"))
    })
  })
  it("copies links and returns the path", {
    with_dir_tree(
      list("foo/bar/baz" = "test"), {
        link_create(path_abs("foo/bar"), "foo/foo")
        expect_equal(dir_copy("foo", "foo2"), "foo2")
        expect_true(dir_exists("foo2"))
        expect_true(link_exists("foo2/foo"))
        expect_equal(link_path("foo2/foo"), link_path("foo/foo"))
    })
  })
  it("errors on missing input", {
    expect_error(dir_copy(NA, "foo2"), class = "invalid_argument")
    expect_error(dir_copy("foo", NA), class = "invalid_argument")
  })
})
