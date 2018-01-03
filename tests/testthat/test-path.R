context("path")

describe("path", {
  it("returns paths UTF-8 encoded", {
    expect_equal(Encoding(path("föö")), "UTF-8")
  })

  it("returns paths UTF-8 encoded", {
    skip_on_os("windows")
    expect_equal(Encoding(path("\U4F60\U597D.R")), "UTF-8")
  })

  it("returns empty strings unchanged", {
    expect_equal(path(""), "")
    expect_equal(path(character()), character())
  })
})

describe("path_norm", {
  it("returns the real path for symbolic links", {
    with_dir_tree(list("foo/bar" = "test"), {
      link_create(path_norm("foo"), "foo2")
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
    expect_equal(path_split("c:/usr/bin")[[1]], c("c:", "usr", "bin"))
    expect_equal(path_split("X:/usr/bin")[[1]], c("X:", "usr", "bin"))
    expect_equal(path_split("//server/usr/bin")[[1]], c("//server", "usr", "bin"))
    expect_equal(path_split("\\\\server\\usr\\bin")[[1]], c("//server", "usr", "bin"))
  })
})

describe("path_tidy", {
  it("always expands ~", {
    expect_equal(path_tidy("~/foo"), gsub("\\\\", "/", path_expand("~/foo")))
  })

  it("always uses / for delimiting, never multiple / or trailing /", {
    expect_equal(path_tidy("foo/bar/baz"), "foo/bar/baz")
    expect_equal(path_tidy("foo/bar/baz/"), "foo/bar/baz")
    expect_equal(path_tidy("foo//bar//baz"), "foo/bar/baz")
    expect_equal(path_tidy("foo//bar//baz//"), "foo/bar/baz")
    expect_equal(path_tidy("foo\\bar\\baz"), "foo/bar/baz")
    expect_equal(path_tidy("foo\\\\bar\\\\baz"), "foo/bar/baz")
    expect_equal(path_tidy("//foo\\\\bar\\\\baz"), "//foo/bar/baz")
    expect_equal(path_tidy("foo\\\\bar\\\\baz\\"), "foo/bar/baz")
    expect_equal(path_tidy("foo\\\\bar\\\\baz\\\\"), "foo/bar/baz")
  })

  it("passes NA along", {
    expect_equal(path_tidy(NA_character_), NA_character_)
    expect_equal(path_tidy(c("foo/bar", NA_character_)), c("foo/bar", NA_character_))
  })
})

describe("path_temp", {
  it("returned tidies tempdir()", {
    expect_equal(path_temp(), path_tidy(tempdir()))
  })
})

describe("path_ext", {
  it ("returns the path extension, or \"\" if one does not exist", {
    expect_equal(path_ext("foo.bar"), "bar")
    expect_equal(path_ext("foo.boo.bar"), "bar")
    expect_equal(path_ext("foo.boo.biff.bar"), "bar")
    expect_equal(path_ext(".csh.rc"), "rc")
    expect_equal(path_ext("nodots"), "")
    expect_equal(path_ext(".cshrc"), "")
    expect_equal(path_ext("...manydots"), "")
    expect_equal(path_ext("...manydots.ext"), "ext")
    expect_equal(path_ext("."), "")
    expect_equal(path_ext(".."), "")
    expect_equal(path_ext("........"), "")
    expect_equal(path_ext(""), "")
    expect_equal(path_ext(c("foo.bar", NA_character_)), c("bar", NA_character_))
  })
})

describe("path_ext_remove", {
  it ("removes the path extension", {
    expect_equal(path_ext_remove("foo.bar"), "foo")
    expect_equal(path_ext_remove("foo.boo.bar"), "foo.boo")
    expect_equal(path_ext_remove("foo.boo.biff.bar"), "foo.boo.biff")
    expect_equal(path_ext_remove(".csh.rc"), ".csh")
    expect_equal(path_ext_remove("nodots"), "nodots")
    expect_equal(path_ext_remove(".cshrc"), ".cshrc")
    expect_equal(path_ext_remove("...manydots"), "...manydots")
    expect_equal(path_ext_remove("...manydots.ext"), "...manydots")
    expect_equal(path_ext_remove("."), ".")
    expect_equal(path_ext_remove(".."), "..")
    expect_equal(path_ext_remove("........"), "........")
    expect_equal(path_ext_remove(""), "")
    expect_equal(path_ext_remove(NA_character_), NA_character_)
    expect_equal(path_ext_remove(c("foo.bar", NA_character_)), c("foo", NA_character_))
  })
})

describe("path_ext_set", {
  it ("replaces the path extension", {
    expect_equal(path_ext_set("foo.bar", "baz"), "foo.baz")
    expect_equal(path_ext_set("foo.boo.bar", "baz"), "foo.boo.baz")
    expect_equal(path_ext_set("foo.boo.biff.bar", "baz"), "foo.boo.biff.baz")
    expect_equal(path_ext_set(".csh.rc", "gz"), ".csh.gz")
    expect_equal(path_ext_set("nodots", "bar"), "nodots.bar")
    expect_equal(path_ext_set(".cshrc", "bar"), ".cshrc.bar")
    expect_equal(path_ext_set("...manydots", "bar"), "...manydots.bar")
    expect_equal(path_ext_set("...manydots.ext", "bar"), "...manydots.bar")
    expect_equal(path_ext_set(".", "bar"), "..bar")
    expect_equal(path_ext_set("..", "bar"), "...bar")
    expect_equal(path_ext_set("........", "bar"), ".........bar")
    expect_equal(path_ext_set("", "bar"), ".bar")
    expect_equal(path_ext_set(NA_character_, "bar"), NA_character_)
    expect_equal(path_ext_set(c("foo", NA_character_), "bar"), c("foo.bar", NA_character_))
  })
})

describe("path_ext<-", {
  it ("replaces the path extension", {
    x <- "...manydots"
    path_ext(x) <- "bar"
    expect_equal(x, "...manydots.bar")
  })
})
