context("test-fmode.R")

describe("as_fmode", {
  it("coerces integers", {
    expect_equal(as_fmode(420L), new_fmode(420L))
    expect_equal(as_fmode(NA_integer_), new_fmode(NA_integer_))

    expect_equal(as_fmode(c(511L, 420L)), new_fmode(c(511L, 420L)))
  })

  it("coerces doubles to integers", {
    expect_equal(as_fmode(420), new_fmode(420L))
    expect_equal(as_fmode(NA_real_), new_fmode(NA_integer_))
    expect_equal(as_fmode(c(511, 420)), new_fmode(c(511L, 420L)))

    expect_error(as_fmode(420.5), "'x' cannot be coerced to class \"fmode\"")
  })
  it("coerces octmode", {
    expect_equal(as_fmode(as.octmode("777")), new_fmode(511L))
    expect_equal(as_fmode(as.octmode(c("644", "777"))), new_fmode(c(420L, 511L)))
  })
  it("coerces characters in octal notation", {
    expect_equal(as_fmode("777"), new_fmode(511L))
    expect_equal(as_fmode(c("644", "777")), new_fmode(c(420L, 511L)))

    expect_error(as_fmode("777777"), "Invalid mode '777777'")
  })
  it("coerces characters in symbolic notation", {
    expect_equal(as_fmode("a+rwx"), new_fmode(511L))
    expect_equal(as_fmode(c("u+rw,go+r", "a+rwx")), new_fmode(c(420L, 511L)))
  })
  it("coerces characters in symbolic notation", {
    expect_equal(as_fmode("rw-r--r--"), new_fmode(420L))
    expect_equal(as_fmode(c("rw-r--r--", "rwxrwxrwx")), new_fmode(c(420L, 511L)))
  })
})
