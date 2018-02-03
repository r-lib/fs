context("path")

describe("path", {
  it("returns paths UTF-8 encoded", {
    skip_on_os("solaris")
    expect_equal(Encoding(path("föö")), "UTF-8")
  })

  it("returns paths UTF-8 encoded", {
    skip_on_os("solaris")
    expect_equal(Encoding(path("\U4F60\U597D.R")), "UTF-8")
  })

  it("returns empty strings for empty inputs", {
    expect_equal(path(""), "")
    expect_equal(path(character()), character())
    expect_equal(path("foo", character(), "bar"), character())
  })

  it("propagates NA strings", {
    expect_equal(path(NA_character_), NA_character_)
    expect_equal(path("foo", NA_character_), NA_character_)
    expect_equal(path(c("foo", "bar"), c("baz", NA_character_)), c("foo/baz", NA_character_))
  })

  it("appends a ext if provided", {
    expect_equal(path("foo", ext = "bar"), "foo.bar")
    expect_equal(path(c("foo", "baz"), ext = "bar"), c("foo.bar", "baz.bar"))
    expect_equal(path(c("foo", "baz", NA_character_), ext = "bar"), c("foo.bar", "baz.bar", NA_character_))
  })

  it("does not double paths", {
    expect_equal(path("/", "foo"), "/foo")
    expect_equal(path("\\", "foo"), "/foo")
    expect_equal(path("", "foo"), "/foo")
    expect_equal(path("foo/", "bar"), "foo/bar")
    expect_equal(path("foo\\", "bar"), "foo/bar")
    expect_equal(path("foo//", "bar"), "foo/bar")

    # This could be a UNC path, so we keep the doubled path.
    expect_equal(path("//", "foo"), "//foo")
  })
})

describe("path_real", {
  it("returns the real path for symbolic links", {
    with_dir_tree(list("foo/bar" = "test"), {
      link_create(path_real("foo"), "foo2")
      expect_equal(path_real("foo2"), path_real("foo"))
    })
  })
})

describe("path_split", {
  it("returns the path split", {
    expect_equal(path_split("foo/bar")[[1]], c("foo", "bar"))
    expect_equal(path_split(c("foo/bar", "foo/baz")), list(c("foo", "bar"), c("foo", "baz")))
  })

  it("does not split the root path", {
    expect_equal(path_split("/usr/bin")[[1]], c("/", "usr", "bin"))
    expect_equal(path_split("c:/usr/bin")[[1]], c("c:", "usr", "bin"))
    expect_equal(path_split("X:/usr/bin")[[1]], c("X:", "usr", "bin"))
    expect_equal(path_split("//server/usr/bin")[[1]], c("//server", "usr", "bin"))
    expect_equal(path_split("\\\\server\\usr\\bin")[[1]], c("//server", "usr", "bin"))
  })
})

describe("path_tidy", {
  it("does not expand ~", {
    expect_equal(path_tidy("~/foo"), "~/foo")
    expect_equal(path_tidy("~/foo/"), "~/foo")
    expect_equal(path_tidy("~//foo"), "~/foo")
    expect_equal(path_tidy("~//foo"), "~/foo")
    expect_equal(path_tidy("~\\foo\\"), "~/foo")
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

# test cases derived from https://github.com/python/cpython/blob/6f0eb93183519024cb360162bdd81b9faec97ba6/Lib/test/test_posixpath.py#L276

describe("path_norm", {
  it ("works with POSIX paths", {
    expect_equal(path_norm(""), ".")
    expect_equal(path_norm(""), ".")
    expect_equal(path_norm(".."), "..")
    expect_equal(path_norm("/../../.."), "/")
    expect_equal(path_norm("/../.././.."), "/")
    expect_equal(path_norm("../.././.."), "../../..")
    expect_equal(path_norm("/"), "/")
    expect_equal(path_norm("//"), "/")
    expect_equal(path_norm("///"), "/")
    expect_equal(path_norm("//foo"), "//foo")
    expect_equal(path_norm("//foo/.//bar//"), "//foo/bar")
    expect_equal(path_norm("/foo/.//bar//.//..//.//baz"), "/foo/baz")
    expect_equal(path_norm("/..//./foo/.//bar"), "/foo/bar")
  })

  it ("works with POSIX paths", {
    expect_equal(path_norm("A//////././//.//B"), "A/B")
    expect_equal(path_norm("A/./B"), "A/B")
    expect_equal(path_norm("A/foo/../B"), "A/B")
    expect_equal(path_norm("C:A//B"), "C:A/B")
    expect_equal(path_norm("D:A/./B"), "D:A/B")
    expect_equal(path_norm("e:A/foo/../B"), "e:A/B")

    expect_equal(path_norm("C:///A//B"), "C:/A/B")
    expect_equal(path_norm("D:///A/./B"), "D:/A/B")
    expect_equal(path_norm("e:///A/foo/../B"), "e:/A/B")

    expect_equal(path_norm(".."), "..")
    expect_equal(path_norm("."), ".")
    expect_equal(path_norm(""), ".")
    expect_equal(path_norm("/"), "/")
    expect_equal(path_norm("c:/"), "c:")
    expect_equal(path_norm("/../.././.."), "/")
    expect_equal(path_norm("c:/../../.."), "c:")
    expect_equal(path_norm("../.././.."), "../../..")
    expect_equal(path_norm("C:////a/b"), "C:/a/b")
    expect_equal(path_norm("//machine/share//a/b"), "//machine/share/a/b")

    expect_equal(path_norm("\\\\?\\D:/XY\\Z"), "//?/D:/XY/Z")
  })

  it ("works with missing values", {
    expect_equal(path_norm(NA), NA_character_)
    expect_equal(path_norm(c("foo", NA)), c("foo", NA))
    expect_equal(path_norm(c(NA, NA)), c(NA_character_, NA_character_))
  })
})

# Test cases derived from https://github.com/python/cpython/blob/6f0eb93183519024cb360162bdd81b9faec97ba6/Lib/test/test_posixpath.py

describe("path_common", {
  it ("finds the common path", {
    expect_error(path_common(c("/usr", "usr")), "Can't mix")
    expect_error(path_common(c("usr", "/usr")), "Can't mix")

    expect_equal(path_common(c("/usr/local")), "/usr/local")
    expect_equal(path_common(c("/usr/local", "/usr/local")), "/usr/local")
    expect_equal(path_common(c("/usr/local/", "/usr/local")), "/usr/local")
    expect_equal(path_common(c("/usr/local/", "/usr/local/")), "/usr/local")
    expect_equal(path_common(c("/usr//local/bin", "/usr/local//bin")), "/usr/local/bin")
    expect_equal(path_common(c("/usr/./local", "/./usr/local")), "/usr/local")
    expect_equal(path_common(c("/", "/dev")), "/")
    expect_equal(path_common(c("/usr", "/dev")), "/")
    expect_equal(path_common(c("/usr/lib/", "/usr/lib/python3")), "/usr/lib")
    expect_equal(path_common(c("/usr/lib/", "/usr/lib64/")), "/usr")

    expect_equal(path_common(c("/usr/lib", "/usr/lib64")), "/usr")
    expect_equal(path_common(c("/usr/lib/", "/usr/lib64")), "/usr")

    expect_equal(path_common(c("spam")), "spam")
    expect_equal(path_common(c("spam", "spam")), "spam")
    expect_equal(path_common(c("spam", "alot")), "")
    expect_equal(path_common(c("and/jam", "and/spam")), "and")
    expect_equal(path_common(c("and//jam", "and/spam//")), "and")
    expect_equal(path_common(c("and/./jam", "./and/spam")), "and")
    expect_equal(path_common(c("and/jam", "and/spam", "alot")), "")
    expect_equal(path_common(c("and/jam", "and/spam", "and")), "and")

    expect_equal(path_common(c("")), "")
    expect_equal(path_common(c("", "spam/alot")), "")

    expect_error(path_common(c("", "/spam/alot")), "Can't mix")
  })
})

# derived from https://github.com/python/cpython/blob/6f0eb93183519024cb360162bdd81b9faec97ba6/Lib/test/test_posixpath.py#L483
describe("path_rel", {
  it("works for posix paths", {
    cur_dir <- path_file(getwd())
    expect_equal(path_rel("a"), "a")
    expect_equal(path_rel(path_abs("a")), "a")
    expect_equal(path_rel("a/b"), "a/b")
    expect_equal(path_rel("../a/b"), "../a/b")
    expect_equal(path_rel("a", "../b"), path_join(c("..", cur_dir, "a")))
    expect_equal(path_rel("a/b", "../c"), path_join(c("..", cur_dir, "a", "b")))
    expect_equal(path_rel("a", "b/c"), "../../a")
    expect_equal(path_rel("a", "a"), ".")
    expect_equal(path_rel("/foo/bar/bat", "/x/y/z"), "../../../foo/bar/bat")
    expect_equal(path_rel("/foo/bar/bat", "/foo/bar"), "bat")
    expect_equal(path_rel("/foo/bar/bat", "/"), "foo/bar/bat")
    expect_equal(path_rel("/", "/foo/bar/bat"), "../../..")
    expect_equal(path_rel("/foo/bar/bat", "/x"), "../foo/bar/bat")
    expect_equal(path_rel("/x", "/foo/bar/bat"), "../../../x")
    expect_equal(path_rel("/", "/"), ".")
    expect_equal(path_rel("/a", "/a"), ".")
    expect_equal(path_rel("/a/b", "/a/b"), ".")

    expect_equal(path_rel(c("a", "a/b", "a/b/c"), "a/b"), c("..", ".", "c"))
  })

  it("works for windows paths", {
    expect_equal(path_rel("c:/foo/bar/bat", "c:/x/y"), "../../foo/bar/bat")
    expect_equal(path_rel("//conky/mountpoint/a", "//conky/mountpoint/b/c"), "../../a")
  })
})

describe("path_home", {
  # The trailing slash is needed to ensure we get path expansion
  # on POSIX systems when readline support is not built in. (#60)
  it("is equivalent to path_expand(\"~/\")", {
    expect_equal(path_home(), path_tidy(path_expand("~/")))
  })
})
