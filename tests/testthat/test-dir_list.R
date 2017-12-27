context("test-dir_list.R")

describe("dir_list", {
  it("Does not include '.' or double '/' in results", {
    with_dir_tree(list("foo" = "test"), {
      expect_equal(dir_list(), "foo")
      expect_equal(dir_list("."), "foo")
      expect_equal(dir_list("./"), "./foo")
    })

    with_dir_tree(list("foo/bar" = "test"), {
      expect_equal(dir_list(recursive = TRUE), c("foo", "foo/bar"))
      expect_equal(dir_list(recursive = TRUE, type = "file"), "foo/bar")
      expect_equal(dir_list("./", recursive = TRUE), c("./foo", "./foo/bar"))
      expect_equal(dir_list("foo"), "foo/bar")
      expect_equal(dir_list("foo/"), "foo/bar")
    })
  })

  it("Does not follow symbolic links", {
    with_dir_tree(list("foo/bar/baz" = "test"), {
      link_create(path_norm("foo"), "foo/bar/qux")
      expect_equal(dir_list(recursive = TRUE), c("foo", "foo/bar", "foo/bar/baz", "foo/bar/qux"))
      expect_equal(dir_list(recursive = TRUE, type = "symlink"), "foo/bar/qux")
    })
  })

  it("Uses grep to filter output", {
    with_dir_tree(list(
        "foo/bar/baz" = "test",
        "foo/bar/test2" = "",
        "foo/bar/test3" = ""), {
      expect_equal(dir_list(recursive = TRUE, pattern = "baz"), "foo/bar/baz")
      expect_equal(dir_list(recursive = TRUE, pattern = "[23]"), c("foo/bar/test2", "foo/bar/test3"))
      expect_equal(dir_list(recursive = TRUE, pattern = "(?<=a)z", perl = TRUE), "foo/bar/baz")
    })
  })

  it("Does not print hidden files by default", {
    with_dir_tree(list(
        ".foo" = "foo",
        "bar" = "bar"), {
      expect_equal(dir_list(), "bar")
      expect_equal(dir_list(all = TRUE), c(".foo", "bar"))
    })
  })

  it("can find multiple types", {
    with_dir_tree(list(
        "file" = "foo",
        "dir"), {
      link_create(path_norm("dir"), "link")
      expect_equal(dir_list(type = "file"), "file")
      expect_equal(dir_list(type = "directory"), "dir")
      expect_equal(dir_list(type = "symlink"), "link")
      expect_equal(dir_list(type = c("directory", "symlink")), c("dir", "link"))
      expect_equal(dir_list(type = c("file", "directory", "symlink")), c("dir", "file", "link"))
    })
  })
})


describe("dir_walk", {
  it("can find multiple types", {
    x <- character()
    f <- function(p) x <<- p

    with_dir_tree(list(
        "file" = "foo",
        "dir"), {
      link_create(path_norm("dir"), "link")

      dir_walk(type = "file", fun = f)
      expect_equal(x, "file")

      dir_walk(type = "directory", fun = f)
      expect_equal(x, "dir")

      dir_walk(type = "symlink", fun = f)
      expect_equal(x, "link")

      x <- character()
      dir_walk(type = c("directory", "symlink"), fun = function(p) x <<- c(x, p))
      expect_equal(x, c("dir", "link"))

      x <- character()
      dir_walk(type = c("file", "directory", "symlink"), fun = function(p) x <<- c(x, p))
      expect_equal(x, c("dir", "file", "link"))
    })
  })
})
