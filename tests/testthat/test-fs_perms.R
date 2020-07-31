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
  it("preserves the class with both subset and subset2", {
    expect_is(as_fs_perms("777")[1], "fs_perms")
    expect_is(as_fs_perms("777")[[1]], "fs_perms")
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
  it("returns 'rwx' on windows", {
    expect_equal(as.character(as_fs_perms("777")), "rwx")
  })
})
}

test_that("common type of double and fs_perms is fs_perms", {
  expect_identical(
    vctrs::vec_ptype2(double(), fs_perms()),
    fs_perms()[0]
  )
  expect_identical(
    vctrs::vec_ptype2(fs_perms(), double()),
    fs_perms()[0]
  )
})

test_that("fs_perms and double are coercible", {
  expect_identical(
    vctrs::vec_cast(1, fs_perms()),
    fs_perms(1)
  )
  expect_identical(
    vctrs::vec_cast(fs_perms(1), double()),
    1L
  )
  expect_identical(
    vctrs::vec_cast(fs_perms(1), fs_perms()),
    fs_perms(1)
  )
})

test_that("can concatenate fs_perms", {
  expect_identical(
    vctrs::vec_c(fs_perms(1), fs_perms(2)),
    as_fs_perms(c(1, 2))
  )
})

test_that("common type of integer and fs_perms is fs_perms", {
  expect_identical(
    vctrs::vec_ptype2(integer(), fs_perms()),
    fs_perms()[0]
  )
  expect_identical(
    vctrs::vec_ptype2(fs_perms(), integer()),
    fs_perms()[0]
  )
})

test_that("fs_perms and integer are coercible", {
  expect_identical(
    vctrs::vec_cast(1L, fs_perms()),
    fs_perms(1L)
  )
  expect_identical(
    vctrs::vec_cast(fs_perms(1L), integer()),
    1L
  )
})

test_that("common type of character and fs_perms is fs_perms", {
  expect_identical(
    vctrs::vec_ptype2(character(), fs_perms()),
    fs_perms()[0]
  )
  expect_identical(
    vctrs::vec_ptype2(fs_perms(), character()),
    fs_perms()[0]
  )
})

test_that("fs_perms and character are coercible", {
  expect_identical(
    vctrs::vec_cast("777", fs_perms()),
    fs_perms("777")
  )

  # This test only return rwx on Windows due to the less fine grained
  # permissions, so we skip it
  skip_on_os("windows")
  expect_identical(
    vctrs::vec_cast(fs_perms("777"), character()),
    "rwxrwxrwx"
  )
})
