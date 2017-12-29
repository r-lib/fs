context("test-fs_bytes.R")

describe("as_fs_bytes", {
  it("accepts numeric input unchanged", {
    expect_equal(unclass(as_fs_bytes(123L)), 123L)
    expect_equal(unclass(as_fs_bytes(123)), 123)
  })
  it("accepts fs_byte input unchanged", {
    x <- as_fs_bytes(123)
    expect_equal(as_fs_bytes(x), x)
  })
  it("coerces character input", {
    expect_equal(unclass(as_fs_bytes("1")), 1)
    expect_equal(unclass(as_fs_bytes("1K")), 1024)
    expect_equal(unclass(as_fs_bytes("1M")), 1024 * 1024)
    expect_equal(unclass(as_fs_bytes("10M")), 10 * 1024 * 1024)
    expect_equal(unclass(as_fs_bytes("1G")), 1024 * 1024 * 1024)
  })
})

describe("format.fs_bytes", {
  it("formats bytes under 1024 as whole numbers", {
    expect_equal(format(fs_bytes(0)), "0")
    expect_equal(format(fs_bytes(1)), "1")
    expect_equal(format(fs_bytes(1023)), "1023")
  })
  it("formats bytes 1024 and up as abbreviated numbers", {
    expect_equal(format(fs_bytes(1024)), "1K")
    expect_equal(format(fs_bytes(1025)), "1K")
    expect_equal(format(fs_bytes(2^16)), "64K")
    expect_equal(format(fs_bytes(2^24)), "16M")
    expect_equal(format(fs_bytes(2^24 + 555555)), "16.5M")
    expect_equal(format(fs_bytes(2^32)), "4G")
    expect_equal(format(fs_bytes(2^48)), "256T")
    expect_equal(format(fs_bytes(2^64)), "16E")
  })
  it("handles NA and NaN", {
    expect_equal(format(fs_bytes(NA)), "NA")
    expect_equal(format(fs_bytes(NaN)), "NaN")
  })
  it("works with vectors", {
    v <- c(NA, 1, 2^13, 2^20, NaN, 2^15)
    expect_equal(
      format(fs_bytes(v), trim = TRUE),
      c("NA", "1", "8K", "1M", "NaN", "32K"))

    expect_equal(format(fs_bytes(numeric())), character())
  })
})

describe("sum.fs_bytes", {
  it("sums its input and returns a fs_byte", {
    expect_equal(sum(fs_bytes(0)), new_fs_bytes(0))
    expect_equal(sum(fs_bytes(c(1, 2))), new_fs_bytes(3))
    expect_equal(sum(fs_bytes(c(1, NA))), new_fs_bytes(NA_real_))
  })
})

describe("min.fs_bytes", {
  it("finds minimum input and returns a fs_byte", {
    expect_equal(min(fs_bytes(0)), new_fs_bytes(0))
    expect_equal(min(fs_bytes(c(1, 2))), new_fs_bytes(1))
    expect_equal(min(fs_bytes(c(1, NA))), new_fs_bytes(NA_real_))
  })
})

describe("max.fs_bytes", {
  it("finds maximum input and returns a fs_byte", {
    expect_equal(max(fs_bytes(0)), new_fs_bytes(0))
    expect_equal(max(fs_bytes(c(1, 2))), new_fs_bytes(2))
    expect_equal(max(fs_bytes(c(1, NA))), new_fs_bytes(NA_real_))
  })
})

describe("[.fs_bytes", {
  it("retains the fs_bytes class", {
    x <- fs_bytes(c(100, 200, 300))
    expect_equal(x[], x)
    expect_equal(x[1], new_fs_bytes(100))
    expect_equal(x[1:2], new_fs_bytes(c(100, 200)))
  })
})

describe("Ops.fs_bytes", {
  it("errors for unary operators", {
    x <- fs_bytes(c(100, 200, 300))
    expect_error(!x, "unary '!' not defined for \"fs_bytes\" objects")
    expect_error(+x, "unary '\\+' not defined for \"fs_bytes\" objects")
    expect_error(-x, "unary '-' not defined for \"fs_bytes\" objects")
  })

  it("works with boolean comparison operators", {
    x <- fs_bytes(c(100, 200, 300))

    expect_equal(x == 100, c(TRUE, FALSE, FALSE))
    expect_equal(x != 100, c(FALSE, TRUE, TRUE))
    expect_equal(x > 100, c(FALSE, TRUE, TRUE))
    expect_equal(x >= 100, c(TRUE, TRUE, TRUE))
    expect_equal(x < 200, c(TRUE, FALSE, FALSE))
    expect_equal(x <= 200, c(TRUE, TRUE, FALSE))
  })

  it("works with arithmetic operators", {
    x <- fs_bytes(c(100, 200, 300))

    expect_equal(x + 100, fs_bytes(c(200, 300, 400)))
    expect_equal(x - 100, fs_bytes(c(0, 100, 200)))
    expect_equal(x * 100, fs_bytes(c(10000, 20000, 30000)))
    expect_equal(x / 2, fs_bytes(c(50, 100, 150)))
    expect_equal(x ^ 2, fs_bytes(c(10000, 40000, 90000)))
  })

  it("errors for other binary operators", {
    x <- fs_bytes(c(100, 200, 300))
    expect_error(x %% 2, "'%%' not defined for \"fs_bytes\" objects")
    expect_error(x %/% 2, "'%/%' not defined for \"fs_bytes\" objects")
    expect_error(x & TRUE, "'&' not defined for \"fs_bytes\" objects")
    expect_error(x | TRUE, "'|' not defined for \"fs_bytes\" objects")
  })
})
