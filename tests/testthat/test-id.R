context("test-id.R")

if (is_windows()) {
  describe("group_ids()", {
    it("returns the group ids", {
      g <- group_ids()
      expect_is(g, "data.frame")
      expect_true(nrow(g) == 0)
      expect_equal(colnames(g),  c("group_id", "group_name"))
    })
  })
  describe("user_ids()", {
    it("returns the group ids", {
      u <- user_ids()
      expect_is(u, "data.frame")
      expect_true(nrow(u) == 0)
      expect_equal(colnames(u),  c("user_id", "user_name"))
    })
  })
} else {
  describe("group_ids()", {
    it("returns the group ids", {
      g <- group_ids()
      expect_is(g, "data.frame")
      expect_true(nrow(g) > 0)
      expect_equal(colnames(g),  c("group_id", "group_name"))
    })
  })
  describe("user_ids()", {
    it("returns the group ids", {
      u <- user_ids()
      expect_is(u, "data.frame")
      expect_true(nrow(u) > 0)
      expect_equal(colnames(u),  c("user_id", "user_name"))
    })
  })
}
