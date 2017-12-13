context("test-rename.R")

describe("file_rename", {
  it("works with an empty file", {
    file <- tempfile()
    file2 <- tempfile()
    cat(file = file)
    expect_true(file.exists(file))
    expect_false(file.exists(file2))

    file_rename(file, file2)
    expect_false(file.exists(file))
    expect_true(file.exists(file2))
  })
})
