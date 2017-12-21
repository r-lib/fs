context("path")

describe("path", {
  it("returns paths UTF-8 encoded", {
    expect_equal(Encoding(path("föö")), "UTF-8")
  })

  it("returns paths UTF-8 encoded", {
    expect_equal(Encoding(path("你好.R")), "UTF-8")
  })

  it("returns empty strings unchanged", {
    expect_equal(path(""), "")
    expect_equal(path(character()), character())
  })
})

describe("path_norm", {
  it("returns the real path for symbolic links", {
    with_dir_tree(list("foo/bar" = "test"), {
      link_create("foo", "foo2")
      expect_equal(path_norm("foo2"), path_norm("foo"))
    })
  })
})

describe("path_split", {
  it("returns the path split", {
    expect_equal(path_split("foo/bar")[[1]], c("foo", "bar"))
    expect_equal(path_split(c("foo/bar", "foo/baz")), list(c("foo", "bar"), c("foo", "baz")))
  })

  it("does not split the root path", {
    expect_equal(path_split("/usr/bin")[[1]], c("/usr", "bin"))
  })
})

describe("path_temp", {
  it("behaves identically to tempdir()", {
    expect_equal(path_temp(), tempdir())
  })
})
