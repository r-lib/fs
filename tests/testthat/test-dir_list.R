context("test-dir_list.R")

describe("dir_list",
  it("Does not include '.' in results", {
    with_dir_tree(list("foo" = "test"), {
      expect_equal(dir_list(), "foo")
      expect_equal(dir_list("./"), "./foo")
    })

    with_dir_tree(list("foo/bar" = "test"), {
      expect_equal(dir_list(), c("foo", "foo/bar"))
      expect_equal(dir_list(type = "file"), "foo/bar")
      expect_equal(dir_list("./"), c("./foo", "./foo/bar"))
      expect_equal(dir_list("foo"), "foo/bar")
      expect_equal(dir_list("foo/"), "foo/bar")
    })
  })
)
