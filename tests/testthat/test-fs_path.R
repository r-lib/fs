describe("as_fs_path", {
  it("returns a new fs_path object from character inputs", {
    x <- as_fs_path("foo/bar")
    expect_s3_class(x, "fs_path")
    expect_s3_class(x, "character")
    expect_equal(length(x), 1)

    x <- as_fs_path(c("foo/bar", "foo", NA))
    expect_s3_class(x, "fs_path")
    expect_s3_class(x, "character")
    expect_equal(length(x), 3)
    expect_equal(as.character(x), c("foo/bar", "foo", NA))
  })

  it("fails with non-character inputs", {
    expect_snapshot(error = TRUE, {
      as_fs_path(1)
      as_fs_path(TRUE)
    })
  })

  it("preserves the class with both subset and subset2", {
    expect_s3_class(as_fs_path("foo")[1], "fs_path")
    expect_s3_class(as_fs_path("foo")[[1]], "fs_path")
  })
})

describe("colourise_fs_path", {
  it("returns an appropriately colored fs_path object", {
    withr::local_envvar(c("LS_COLORS" = gnu_ls_defaults))
    local_reproducible_output(crayon = TRUE)

    with_dir_tree(
      list(
        "foo/bar" = "test",
        "file.zip" = "test",
        "file.R" = "test",
        "file.Rmd" = "test"
      ),
      {
        link_create(path_abs("foo/bar"), "baz")

        # folder
        expect_equal(colourise_fs_path("foo"), "\033[01;34mfoo\033[0m")

        # file
        expect_equal(colourise_fs_path("foo/bar"), "foo/bar")

        # symlink
        expect_equal(colourise_fs_path("baz"), "\033[01;36mbaz\033[0m")

        # extension
        expect_equal(
          colourise_fs_path("file.zip"),
          "\033[01;31mfile.zip\033[0m"
        )

        # R
        expect_equal(colourise_fs_path("file.R"), "\033[32mfile.R\033[0m")

        # Rmd
        expect_equal(colourise_fs_path("file.Rmd"), "\033[32mfile.Rmd\033[0m")
      }
    )
  })

  it("returns uncolored result if LS_COLORS is malformed", {
    # This has an empty leading :
    withr::local_envvar(c(
      "LS_COLORS" = ":di=1;38;5;39:ex=1;38;5;34:ln=1;38;5;45:*.py=1;38;5;220:*.pdf=1;38;5;202:*.tex=1;38;5;196"
    ))

    expect_equal(colourise_fs_path("foo"), "foo")
  })
})

describe("multicol", {
  files <- c(
    "DESCRIPTION",
    "LICENSE.md",
    "NAMESPACE",
    "R",
    "README.Rmd",
    "README.md",
    "_pkgdown.yml",
    "appveyor.yml",
    "codecov.yml",
    "doc",
    "docs",
    "fs.Rcheck",
    "fs.Rproj",
    "fs_0.0.0.9000.tar.gz",
    "man",
    "man-roxygen",
    "script.R",
    "src",
    "tests",
    "tools",
    "foo",
    "foo/bar",
    "foo/bar/baz",
    "foo/bar/baz/bar/baz"
  )

  it("Uses 1 column when width is less than the max size", {
    withr::with_options(c(width = 10), {
      expect_equal(
        max(nchar(multicol(files), keepNA = FALSE)),
        max(nchar(files, keepNA = FALSE)) + 1
      )
    })
  })

  it("Uses 2 column when width is less than the max size * 2", {
    withr::with_options(c(width = 50), {
      expect_equal(max(nchar(multicol(files), keepNA = FALSE)), 43)
    })
  })

  it("Uses 3 column when width is less than the max size * 3", {
    withr::with_options(c(width = 70), {
      expect_equal(max(nchar(multicol(files), keepNA = FALSE)), 64)
    })
  })

  it("Uses 4 column when width is less than the max size * 4", {
    withr::with_options(c(width = 90), {
      expect_equal(max(nchar(multicol(files), keepNA = FALSE)), 85)
    })
  })

  it("works with NA values", {
    withr::with_options(c(width = 10), {
      expect_equal(multicol(NA_character_), "NA\n")
      expect_equal(multicol(c("foo", NA_character_)), "foo NA  \n")
    })
  })

  it("Ignores colors when calculating width", {
    withr::with_options(c(crayon.enabled = TRUE, width = 90), {
      expect_equal(max(nchar(multicol(files), keepNA = FALSE)), 85)
    })
  })
})

test_that("common type of character and fs_path is fs_path", {
  expect_identical(
    vctrs::vec_ptype2(character(), fs_path()),
    fs_path()[0]
  )
  expect_identical(
    vctrs::vec_ptype2(fs_path(), character()),
    fs_path()[0]
  )
})

test_that("fs_path and character are coercible", {
  expect_identical(
    vctrs::vec_cast("foo", fs_path()),
    fs_path("foo")
  )
  expect_identical(
    vctrs::vec_cast(fs_path("foo"), character()),
    "foo"
  )
  expect_identical(
    vctrs::vec_cast(fs_path("foo"), fs_path()),
    fs_path("foo")
  )
})

test_that("can concatenate fs_path", {
  expect_identical(
    vctrs::vec_c(fs_path("foo"), fs_path("bar")),
    as_fs_path(c("foo", "bar"))
  )
})
