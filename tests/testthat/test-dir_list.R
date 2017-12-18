context("test-dir_list.R")

describe("dir_list",
  it("Does not include '.' in results", {
    with_dir_tree(list("foo" = "test"), {
      expect_equal(dir_list(), "foo")
      expect_equal(dir_list("./"), "./foo")
    })
  })
)
