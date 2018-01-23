context("test-dir.R")

describe("dir_delete", {
  it("deletes an empty directory and returns the path", {
    with_dir_tree(list("foo"), {
      expect_true(dir_exists("foo"))
      expect_equal(dir_delete("foo"), "foo")
      expect_false(dir_exists("foo"))
    })
  })
  it("deletes a non-empty directory and returns the path", {
    with_dir_tree(
      list("foo/bar" = "test",
        "foo/baz" = "test2"), {
      expect_true(dir_exists("foo"))
      expect_equal(dir_delete("foo"), "foo")
      expect_false(dir_exists("foo"))
    })
  })
  it("deletes nested directories and returns the path", {
    with_dir_tree(
      list("foo/bar/baz" = "test",
        "foo/baz/qux" = "test2"), {
      expect_true(dir_exists("foo"))
      expect_equal(dir_delete("foo"), "foo")
      expect_false(dir_exists("foo"))
    })
  })
  it("deletes a non-empty directory with hidden files and directories and returns the path", {
    with_dir_tree(
      list("foo/bar" = "test",
        "foo/baz" = "test2",
        "foo/.blah" = "foo",
        ".dir"), {
      expect_true(dir_exists("foo"))
      expect_equal(dir_delete("foo"), "foo")
      expect_false(dir_exists("foo"))
    })
  })
})
