context("test-fs_perms.R")

if (!is_windows()) {
describe("as_fs_perms (POSIX)", {
  it("coerces integers", {
    expect_equal(as_fs_perms(420L), new_fs_perms(420L))
    expect_equal(as_fs_perms(NA_integer_), new_fs_perms(NA_integer_))

    expect_equal(as_fs_perms(c(511L, 420L)), new_fs_perms(c(511L, 420L)))
  })

  it("coerces doubles to integers", {
    expect_equal(as_fs_perms(420), new_fs_perms(420L))
    expect_equal(as_fs_perms(NA_real_), new_fs_perms(NA_integer_))
    expect_equal(as_fs_perms(c(511, 420)), new_fs_perms(c(511L, 420L)))

    expect_error(as_fs_perms(420.5), "'x' cannot be coerced to class \"fs_perms\"")
  })
  it("coerces octmode", {
    expect_equal(as_fs_perms(as.octmode("777")), new_fs_perms(511L))
    expect_equal(as_fs_perms(as.octmode(c("644", "777"))), new_fs_perms(c(420L, 511L)))
  })
  it("coerces characters in octal notation", {
    expect_equal(as_fs_perms("777"), new_fs_perms(511L))
    expect_equal(as_fs_perms(c("644", "777")), new_fs_perms(c(420L, 511L)))

    expect_error(as_fs_perms("777777"), "Invalid mode '777777'")
  })
  it("coerces characters in symbolic notation", {
    expect_equal(as_fs_perms("a+rwx"), new_fs_perms(511L))
    expect_equal(as_fs_perms(c("u+rw,go+r", "a+rwx")), new_fs_perms(c(420L, 511L)))
  })
  it("coerces characters in symbolic notation", {
    expect_equal(as_fs_perms("rw-r--r--"), new_fs_perms(420L))
    expect_equal(as_fs_perms(c("rw-r--r--", "rwxrwxrwx")), new_fs_perms(c(420L, 511L)))
  })
})

} else {
describe("as_fs_perms (Windows)", {
  skip_on_os(c("mac", "linux", "solaris"))
  it("coerces integers", {
    expect_equal(as_fs_perms(384L), new_fs_perms(384L))
    expect_equal(as_fs_perms(NA_integer_), new_fs_perms(NA_integer_))

    expect_equal(as_fs_perms(c(256L, 384L)), new_fs_perms(c(256L, 384L)))
  })

  it("coerces doubles to integers", {
    expect_equal(as_fs_perms(384), new_fs_perms(384L))
    expect_equal(as_fs_perms(NA_real_), new_fs_perms(NA_integer_))
    expect_equal(as_fs_perms(c(256, 384)), new_fs_perms(c(256L, 384L)))

    expect_error(as_fs_perms(420.5), "'x' cannot be coerced to class \"fs_perms\"")
  })
  it("coerces octmode", {
    expect_equal(as_fs_perms(as.octmode("600")), new_fs_perms(384L))
    expect_equal(as_fs_perms(as.octmode(c("600", "700"))), new_fs_perms(c(384L, 448L)))
    expect_equal(as_fs_perms(as.octmode(c("666", "777"))), new_fs_perms(c(438L, 511L)))
  })
  it("coerces characters in octal notation", {
    expect_equal(as_fs_perms("700"), new_fs_perms(448L))
    expect_equal(as_fs_perms(c("644", "777")), new_fs_perms(c(384L, 448L)))

    #expect_error(as_fs_perms("777777"), "Invalid mode '777777'")
  })
  it("ignores group and other octmode groups", {
    expect_equal(as_fs_perms(c("666", "777")), new_fs_perms(c(384L, 448L)))
  })
  it("coerces characters in symbolic notation", {
    expect_equal(as_fs_perms("a+rw"), new_fs_perms(384L))
    expect_equal(as_fs_perms(c("u+rw", "a+rwx")), new_fs_perms(c(384L, 448L)))
  })
  it("coerces characters in symbolic notation", {
    expect_equal(as_fs_perms("rw-"), new_fs_perms(384L))
    expect_equal(as_fs_perms(c("rw-", "rwx")), new_fs_perms(c(384L, 448L)))
  })
})
}
