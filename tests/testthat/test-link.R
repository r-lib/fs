context("test-link.R")

describe("link_path", {
  with_dir_tree("foo", {
    link_create(path_abs("foo"), "loo")
    it("fails if given a non-link", {
      expect_error(link_path("foo"), "Failed to read link")
    })
    it("returns the link path if given a link", {
      expect_equal(link_path("loo"), path_abs("foo"))
    })
    it("fails silently if a link already exists and it points to the same location", {
      expect_error_free(link_create(path_abs("foo"), "loo"))
    })
    it("fails if a link already exists and it does not point to the same location", {
      dir_create("boo")
      expect_error(link_create(path_abs("boo"), "loo"), class = "EEXIST")
    })
  })
  it("errors on missing input", {
    expect_error(link_path(NA), class = "invalid_argument")
  })
})
