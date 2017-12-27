context("test-fs_perms.R")

describe("as_fmode (POSIX)", {
  skip_on_os(c("windows"))
  it("coerces integers", {
    expect_equal(as_fmode(420L), new_fmode(420L))
    expect_equal(as_fmode(NA_integer_), new_fmode(NA_integer_))

    expect_equal(as_fmode(c(511L, 420L)), new_fmode(c(511L, 420L)))
  })

  it("coerces doubles to integers", {
    expect_equal(as_fmode(420), new_fmode(420L))
    expect_equal(as_fmode(NA_real_), new_fmode(NA_integer_))
    expect_equal(as_fmode(c(511, 420)), new_fmode(c(511L, 420L)))

    expect_error(as_fmode(420.5), "'x' cannot be coerced to class \"fs_perms\"")
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

describe("as_fmode (Windows)", {
  skip_on_os(c("mac", "linux", "solaris"))
  it("coerces integers", {
    expect_equal(as_fmode(384L), new_fmode(384L))
    expect_equal(as_fmode(NA_integer_), new_fmode(NA_integer_))

    expect_equal(as_fmode(c(256L, 384L)), new_fmode(c(256L, 384L)))
  })

  it("coerces doubles to integers", {
    expect_equal(as_fmode(384), new_fmode(384L))
    expect_equal(as_fmode(NA_real_), new_fmode(NA_integer_))
    expect_equal(as_fmode(c(256, 384)), new_fmode(c(256L, 384L)))

    expect_error(as_fmode(420.5), "'x' cannot be coerced to class \"fs_perms\"")
  })
  it("coerces octmode", {
    expect_equal(as_fmode(as.octmode("600")), new_fmode(384L))
    expect_equal(as_fmode(as.octmode(c("600", "700"))), new_fmode(c(384L, 448L)))
    expect_equal(as_fmode(as.octmode(c("666", "777"))), new_fmode(c(384L, 448L)))
  })
  it("coerces characters in octal notation", {
    expect_equal(as_fmode("700"), new_fmode(511L))
    expect_equal(as_fmode(c("644", "777")), new_fmode(c(420L, 511L)))

    expect_error(as_fmode("777777"), "Invalid mode '777777'")
  })
  it("ignores group and other octmode groups", {
    expect_equal(as_fmode(as.octmode(c("666", "777"))), new_fmode(c(384L, 448L)))
    expect_equal(as_fmode(c("666", "777")), new_fmode(c(384L, 448L)))
  })
  it("coerces characters in symbolic notation", {
    expect_equal(as_fmode("a+rwx"), new_fmode(448L))
    expect_equal(as_fmode(c("u+rw", "a+rwx")), new_fmode(c(384L, 448L)))
  })
  it("coerces characters in symbolic notation", {
    expect_equal(as_fmode("rw-"), new_fmode(384L))
    expect_equal(as_fmode(c("rw-", "rwx")), new_fmode(c(384L, 448L)))
  })
})
