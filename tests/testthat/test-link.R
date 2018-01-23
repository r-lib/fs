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
  })
  it("errors on missing input", {
    expect_error(link_path(NA), class = "invalid_argument")
  })
})
