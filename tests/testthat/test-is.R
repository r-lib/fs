context("test-is.R")

with_dir_tree(list("foo/bar"  = "test"), {
  skip_on_os("windows")
  link_create(path_abs("foo/bar"), "foo2")
  link_create("foo/bar", "relbar")
  link_create("foo", "relfoo")

  describe("is_file", {
    it("returns true for files, false for non-files, NA if no object exists", {
      expect_true(is_file("foo/bar"))
      expect_false(is_file("foo"))
      expect_false(is_file("foo2", follow = FALSE))
      expect_true(is_file("foo2", follow = TRUE))
      expect_equal(is_file("baz"), c(baz = FALSE))
      .old_wd <- setwd("foo")
      expect_false(is_file("../relbar", follow = FALSE))
      expect_true(is_file("../relbar", follow = TRUE))
      setwd(.old_wd)
    })
  })

  describe("is_dir", {
    it("returns true for dirs, false for non-dirs, NA if no object exists", {
      expect_true(is_dir("foo"))
      expect_false(is_dir("foo/bar"))
      expect_false(is_dir("foo2", follow = FALSE))
      expect_false(is_dir("foo2", follow = TRUE))
      expect_equal(is_dir("baz"), c(baz = FALSE))
      .old_wd <- setwd("foo")
      expect_false(is_dir("../relfoo", follow = FALSE))
      expect_true(is_dir("../relfoo", follow = TRUE))
      setwd(.old_wd)
    })
  })

  describe("is_link", {
    it("returns true for links, false for non-links, NA if no object exists", {
      expect_true(is_link("foo2"))
      expect_false(is_link("foo"))
      expect_false(is_link("foo/bar"))
      expect_equal(is_link("baz"), c(baz = FALSE))
    })
  })

  describe("is_file_empty", {
    it("returns true for empty files and false for others", {
      file_create("blah")
      expect_true(is_file_empty("blah"))
      expect_false(is_file_empty("foo/bar"))
      expect_false(is_file_empty("baz"))
    })
  })
})

with_dir_tree(list("foo/bar"  = "test"), {
  describe("is_absolute_path", {
    it("detects windows absolute paths", {
      expect_true(is_absolute_path("c:\\"))
      expect_true(is_absolute_path("c:/"))
      expect_true(is_absolute_path("P:/"))
      expect_true(is_absolute_path("P:\\"))
      expect_true(is_absolute_path("\\\\server\\mountpoint\\"))
      expect_true(is_absolute_path("\\foo"))
      expect_true(is_absolute_path("\\foo\\bar"))
    })
    it("detects posix absolute paths", {
      expect_false(is_absolute_path(""))
      expect_false(is_absolute_path("foo/bar"))
      expect_false(is_absolute_path("./foo/bar"))
      expect_false(is_absolute_path("../foo/bar"))

      expect_true(is_absolute_path("/"))
      expect_true(is_absolute_path("/foo"))
      expect_true(is_absolute_path("/foo/bar"))
      expect_true(is_absolute_path("~/foo/bar"))
    })
  })
})
