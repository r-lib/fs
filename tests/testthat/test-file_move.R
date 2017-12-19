context("test-file_move.R")

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
    })
  })
})
