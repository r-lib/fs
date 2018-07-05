context("utils.R")

describe("captures", {
  it("works with non-ASCII inputs (#120)", {
    expect_equal(captures("ë", regexpr("(.)", "ë", perl = TRUE))[[1]], "ë")
  })
})
