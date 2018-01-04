context("test-id.R")

describe("group_ids()", {
  it("returns the group ids", {
    skip_on_os("windows")
    g <- group_ids()
    expect_is(g, "data.frame")
    expect_true(nrow(g) > 0)
    expect_equal(colnames(g),  c("group_id", "group_name"))
  })
})
describe("group_ids()", {
  it("returns the group ids", {
    skip_on_os("windows")
    u <- user_ids()
    expect_is(u, "data.frame")
    expect_true(nrow(u) > 0)
    expect_equal(colnames(u),  c("user_id", "user_name"))
  })
})
