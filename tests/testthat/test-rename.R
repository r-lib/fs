context("test-rename.R")

describe("fs_rename", {
  it("works with an empty file", {
    file <- tempfile()
    file2 <- tempfile()
    cat(file = file)
    expect_true(file.exists(file))
    expect_false(file.exists(file2))

    fs_rename(file, file2)
    expect_false(file.exists(file))
    expect_true(file.exists(file2))
  })
})
