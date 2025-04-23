
describe("path_package", {
  it("errors if the package does not exist", {
    cnd <- tryCatch(path_package("arst"), error = function(e) e)
    expect_s3_class(cnd, "EEXIST")
    expect_match(conditionMessage(cnd), "Can't find package")
  })
  it("errors if the package location is not found", {
    cnd <- tryCatch(path_package("base", "foo"), error = function(e) e)
    expect_s3_class(cnd, "EEXIST")
    expect_match(conditionMessage(cnd), "do(es)? not exist")
  })
  it("works on installed files", {
    expect_error_free(p <- path_package("base", "INDEX"))
    expect_s3_class(p, "fs_path")
  })
})
