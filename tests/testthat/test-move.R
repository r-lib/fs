context("test-move.R")

describe("fs_move", {
  it("works with an empty file", {
    file <- tempfile()
    file2 <- tempfile()

    file_create(file)
    expect_true(file_exists(file))
    expect_false(file_exists(file2))

    file_move(file, file2)
    expect_false(file_exists(file))
    expect_true(file_exists(file2))
  })
})
