context("path")

describe("path", {
  it("returns paths UTF-8 encoded", {
    expect_equal(Encoding(path("föö")), "UTF-8")
  })

  it("returns paths UTF-8 encoded", {
    expect_equal(Encoding(path("你好.R")), "UTF-8")
  })
})
