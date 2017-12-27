context("test-is.R")

with_dir_tree(list("foo/bar"  = "test"), {
  link_create(path_norm("foo"), "foo2")

  describe("is_file", {
    it("returns true for files, false for non-files, NA if no object exists", {
      expect_true(is_file("foo/bar"))
      expect_false(is_file("foo"))
      expect_false(is_file("foo2"))
      expect_equal(is_file("baz"), c(baz = NA))
    })
  })

  describe("is_dir", {
    it("returns true for files, false for non-files, NA if no object exists", {
      expect_true(is_dir("foo"))
      expect_false(is_dir("foo/bar"))
      expect_false(is_dir("foo2"))
      expect_equal(is_dir("baz"), c(baz = NA))
    })
  })

  describe("is_link", {
    it("returns true for files, false for non-files, NA if no object exists", {
      expect_true(is_link("foo2"))
      expect_false(is_link("foo"))
      expect_false(is_link("foo/bar"))
      expect_equal(is_link("baz"), c(baz = NA))
    })
  })
})
