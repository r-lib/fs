context("test-path_package.R")

describe("path_package", {
  it("errors if the package does not exist", {
    expect_error(path_package("arst"), class = "EEXIST", msg = "Can't find package")
  })
  it("errors if the package location is not found", {
    expect_error(path_package("base", "foo"), class = "EEXIST", msg = "does not exist")
  })
  it("works on installed files", {
    expect_error_free(p <- path_package("base", "INDEX"))
    expect_is(p, "fs_path")
  })
})
