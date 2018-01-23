context("test-list.R")

describe("dir_ls", {
  it("Does not include '.' or double '/' in results", {
    with_dir_tree(list("foo" = "test"), {
      expect_equal(dir_ls(), "foo")
      expect_equal(dir_ls("."), "foo")
      expect_equal(dir_ls("./"), "./foo")
    })

    with_dir_tree(list("foo/bar" = "test"), {
      expect_equal(dir_ls(recursive = TRUE), c("foo", "foo/bar"))
      expect_equal(dir_ls(recursive = TRUE, type = "file"), "foo/bar")
      expect_equal(dir_ls("./", recursive = TRUE), c("./foo", "./foo/bar"))
      expect_equal(dir_ls("foo"), "foo/bar")
      expect_equal(dir_ls("foo/"), "foo/bar")
    })
  })

  it("Does not follow symbolic links", {
    with_dir_tree(list("foo/bar/baz" = "test"), {
      link_create(path_abs("foo"), "foo/bar/qux")
      expect_equal(dir_ls(recursive = TRUE), c("foo", "foo/bar", "foo/bar/baz", "foo/bar/qux"))
      expect_equal(dir_ls(recursive = TRUE, type = "symlink"), "foo/bar/qux")
    })
  })

  it("Uses grep to filter output", {
    with_dir_tree(list(
        "foo/bar/baz" = "test",
        "foo/bar/test2" = "",
        "foo/bar/test3" = ""), {
      expect_equal(dir_ls(recursive = TRUE, glob = "*baz"), "foo/bar/baz")
      expect_equal(dir_ls(recursive = TRUE, regexp = "baz"), "foo/bar/baz")
      expect_equal(dir_ls(recursive = TRUE, regexp = "[23]"), c("foo/bar/test2", "foo/bar/test3"))
      expect_equal(dir_ls(recursive = TRUE, regexp = "(?<=a)z", perl = TRUE), "foo/bar/baz")
    })
  })

  it("Does not print hidden files by default", {
    with_dir_tree(list(
        ".foo" = "foo",
        "bar" = "bar"), {
      expect_equal(dir_ls(), "bar")
      expect_equal(dir_ls(all = TRUE), c(".foo", "bar"))
    })
  })

  it("can find multiple types", {
    with_dir_tree(list(
        "file" = "foo",
        "dir"), {
      link_create(path_abs("dir"), "link")
      expect_equal(dir_ls(type = "file"), "file")
      expect_equal(dir_ls(type = "directory"), "dir")
      expect_equal(dir_ls(type = "symlink"), "link")
      expect_equal(dir_ls(type = c("directory", "symlink")), c("dir", "link"))
      expect_equal(dir_ls(type = c("file", "directory", "symlink")), c("dir", "file", "link"))
    })
  })
  it("works with UTF-8 encoded filenames", {
    with_dir_tree("\U7684\U6D4B\U8BD5\U6587\U4EF6", {
      file_create("fs\U7684\U6D4B\U8BD5\U6587\U4EF6.docx")
      link_create(path_abs("\U7684\U6D4B\U8BD5\U6587\U4EF6"), "\U7684\U6D4B")

      expect_equal(dir_ls(type = "file"), "fs\U7684\U6D4B\U8BD5\U6587\U4EF6.docx")
      expect_equal(dir_ls(type = "directory"), "\U7684\U6D4B\U8BD5\U6587\U4EF6")
      expect_equal(dir_ls(type = "symlink"), "\U7684\U6D4B")
      expect_equal(path_file(link_path("\U7684\U6D4B")), "\U7684\U6D4B\U8BD5\U6587\U4EF6")
    })
  })
  it("errors on missing input", {
    expect_error(dir_ls(NA), class = "invalid_argument")
  })
})

describe("dir_map", {
  it("can find multiple types", {
    with_dir_tree(list(
        "file" = "foo",
        "dir"), {
      expect_equal(dir_map(type = "file", fun = nchar), list(4))
      expect_equal(dir_map(type = "directory", fun = nchar), list(3))
      expect_equal(dir_map(type = c("file", "directory"), fun = nchar), list(3, 4))
    })
  })
  it("errors on missing input", {
    expect_error(dir_map(NA, fun = identity), class = "invalid_argument")
  })
})

describe("dir_walk", {
  it("can find multiple types", {
    x <- character()
    f <- function(p) x <<- p

    with_dir_tree(list(
        "file" = "foo",
        "dir"), {
      link_create(path_abs("dir"), "link")

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
  it("errors on missing input", {
    expect_error(dir_walk(NA, fun = identity), class = "invalid_argument")
  })
})

describe("dir_info", {
  it("is identical to file_info(dir_ls())", {
    with_dir_tree(list(
        "file" = "foo",
        "dir"), {
      link_create(path_abs("dir"), "link")
      expect_identical(dir_info(), file_info(dir_ls()))
    })
  })
  it("errors on missing input", {
    expect_error(dir_info(NA), class = "invalid_argument")
  })
})
