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

describe("path_wd", {
  it("returns an absolute path from the working directory", {
    x <- path_wd()
    expect_true(is_absolute_path(x))

    expect_equal(x, path(getwd()))
  })
})

describe("path_real", {
  it("returns the real path for symbolic links", {
    with_dir_tree(list("foo/bar" = "test"), {
      link_create(path_real("foo"), "foo2")
      expect_equal(path_real("foo2"), path_real("foo"))
    })
  })

  it("returns the real path for symbolic links even if the full path doesn't exist", {
    with_dir_tree(list("foo/bar/baz" = "test"), {
      link_create(path_real("foo"), "foo2")
      expect_equal(path_real("foo/qux"), path_real("foo/qux"))

      link_create(path_real("foo/bar"), "bar2")
      expect_equal(path_real("bar2/qux"), path_real("bar2/qux"))
    })
  })

  it ("works with indirect symlinks", {
    skip_on_os("windows")

    with_dir_tree("foo", {
      wd <- path_wd()
      link_create(path("..", path_file(wd)), "self")
      link_create("self", "link")
      expect_equal(path_real("link"), wd)
    })
  })

  it ("works with parent symlinks", {
    skip_on_os("windows")

    # If there are symlinks in the parents of relative paths we need to resolve
    # them.
    # e.g. working directory is /usr/doc with 'doc' being a symlink to
    # /usr/share/doc. If we call `path_real("a")` we should return
    # /usr/share/doc/a.
    with_dir_tree("y", {
      wd <- path_wd()
      link_create("y", "k")
      withr::with_dir("k", {
        expect_equal(path_real("a"), path(wd, "/y/a"))
      })
    })
  })

  it ("resolves paths before normalizing", {

    skip_on_os("windows")

    # if we have the following hierarchy: a/k/y
    # and a symbolic link 'link-y' pointing to 'y' in directory 'a',
    # then `path_real("link-y/..")` should return 'k', not 'a'.
    with_dir_tree("a/k/y", {
      link_create("a/k/y", "link-y")

      expect_equal(path_real("link-y/.."), path_real("a/k"))
    })
  })

  it ("resolves paths before normalizing", {

    skip_on_os("windows")

    # if we have the following hierarchy: a/k/y
    # and a symbolic link 'link-y' pointing to 'y' in directory 'a',
    # then `path_real("link-y/..")` should return 'k', not 'a'.
    with_dir_tree("k", {
      wd <- path_wd()
      link_create(wd, "link")

      withr::with_dir(path_dir(wd), {
        base <- path_file(wd)
        expect_equal(path_real(path(base, "link")), wd)
        expect_equal(path_real(path(base, "link/k")), path(wd, "k"))
      })
    })
  })

  it("propagates NAs", {
    with_dir_tree(list("foo/bar" = "test"), {
      link_create(path_real("foo"), "foo2")
      expect_equal(path_real(NA_character_), NA_character_)
      expect_equal(path_real(c("foo2", NA_character_)), c(path_real("foo"), NA_character_))
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
    expect_equal(path_split("c:/usr/bin")[[1]], c("C:", "usr", "bin"))
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

  it("always capitalizes and appends windows root paths with /", {
    expect_equal(path_tidy("C:"), "C:/")
    expect_equal(path_tidy("c:"), "C:/")
    expect_equal(path_tidy("X:"), "X:/")
    expect_equal(path_tidy("x:"), "X:/")
    expect_equal(path_tidy("c:/"), "C:/")
    expect_equal(path_tidy("c://"), "C:/")
    expect_equal(path_tidy("c:\\"), "C:/")
    expect_equal(path_tidy("c:\\\\"), "C:/")
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
  it ("returns 0 length outputs for 0 length inputs", {
    expect_equal(path_ext(character()), character())
  })

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
    expect_equal(path_ext(".bar"), "")
    expect_equal(path_ext("foo/.bar"), "")
    expect_equal(path_ext(c("foo.bar", NA_character_)), c("bar", NA_character_))
    expect_equal(path_ext("foo.bar/baz"), "")
  })
  it ("works with non-ASCII inputs", {
    expect_equal(path_ext("föö.txt"), "txt")
    expect_equal(path_ext("föö.tär"), "tär")
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
    expect_equal(path_ext_remove(".bar"), ".bar")
    expect_equal(path_ext_remove("foo/.bar"), "foo/.bar")
    expect_equal(path_ext_remove("foo.bar/abc.123"), "foo.bar/abc")
    expect_equal(path_ext_remove("foo.bar/abc"), "foo.bar/abc")
  })
  it ("works with non-ASCII inputs", {
    expect_equal(path_ext_remove("föö.txt"), "föö")
    expect_equal(path_ext_remove("föö.tär"), "föö")
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
    expect_equal(path_ext_set(".bar", "baz"), ".bar.baz")
    expect_equal(path_ext_set("foo/.bar", "baz"), "foo/.bar.baz")
    expect_equal(path_ext_set("foo", ""), "foo")
  })
  it ("works the same with and without a leading . for ext", {
    expect_equal(path_ext_set("foo", "bar"), "foo.bar")
    expect_equal(path_ext_set("foo", ".bar"), "foo.bar")
  })
  it ("works with non-ASCII inputs", {
    expect_equal(path_ext_set("föö.txt", "bar"), "föö.bar")
    expect_equal(path_ext_set("föö.tär", "bar"), "föö.bar")
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
    expect_equal(path_norm("e:A/foo/../B"), "E:A/B")

    expect_equal(path_norm("C:///A//B"), "C:/A/B")
    expect_equal(path_norm("D:///A/./B"), "D:/A/B")
    expect_equal(path_norm("e:///A/foo/../B"), "E:/A/B")

    expect_equal(path_norm(".."), "..")
    expect_equal(path_norm("."), ".")
    expect_equal(path_norm(""), ".")
    expect_equal(path_norm("/"), "/")
    expect_equal(path_norm("c:/"), "C:/")
    expect_equal(path_norm("/../.././.."), "/")
    expect_equal(path_norm("c:/../../.."), "C:/")
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

  it("returns NA if any input is NA", {
    expect_equal(path_common(NA), NA_character_)
    expect_equal(path_common(c("and/jam", NA)), NA_character_)
    expect_equal(path_common(c("and/jam", NA, "and")), NA_character_)
  })
})

describe("path_has_parent", {
  expect_false(path_has_parent("foo", "bar"))
  expect_false(path_has_parent("foo", "foo/bar"))

  expect_false(path_has_parent("/usr/var2/log", "/usr/var"))

  expect_true(path_has_parent("foo/bar", "foo"))
  expect_true(path_has_parent("path/myfiles/myfile", "path/to/files/../../myfiles"))
})

# derived from https://github.com/python/cpython/blob/6f0eb93183519024cb360162bdd81b9faec97ba6/Lib/test/test_posixpath.py#L483
describe("path_rel", {
  it("works for POSIX paths", {
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
    expect_equal(path_rel("d:/Users/a", "D:/Users/b"), "../a")
  })

  it("expands path before computing relativity", {
    expect_equal(path_rel("/foo/bar/baz", "~"), path_rel("/foo/bar/baz", path_expand("~")))
    expect_equal(path_rel("~/foo/bar/baz", "~"), "foo/bar/baz")
  })

  it("propagates NAs", {
    expect_equal(path_rel(NA_character_), NA_character_)
    expect_equal(path_rel("/foo/bar/baz", NA_character_), NA_character_)
  })
})

describe("path_abs", {
  it("uses the start parameter", {
    expect_equal(path_abs("b", "a"), path_abs("a/b"))
  })
})

describe("path_home", {
  # The trailing slash is needed to ensure we get path expansion
  # on POSIX systems when readline support is not built in. (#60)
  it("is equivalent to path_expand(\"~/\")", {
    expect_equal(path_home(), path_tidy(path_expand("~/")))
  })
})

describe("path_dir", {
  it("works like dirname for normal paths", {
    expect_equal(path_dir("foo/bar"), "foo")
    expect_equal(path_dir("bar"), ".")
    expect_equal(path_dir(c("foo/bar", "baz")), c("foo", "."))
  })
  it("propagates NAs", {
    expect_equal(path_dir(NA_character_), NA_character_)
    expect_equal(path_dir(c("foo/bar", NA)), c("foo", NA_character_))
  })
})

describe("path_file", {
  it("works like dirname for normal paths", {
    expect_equal(path_file("foo/bar"), "bar")
    expect_equal(path_file("bar"), "bar")
    expect_equal(path_file(c("foo/bar", "baz")), c("bar", "baz"))
  })
  it("propagates NAs", {
    expect_equal(path_file(NA_character_), NA_character_)
    expect_equal(path_file(c("foo/bar", NA)), c("bar", NA_character_))
  })
})

# These tests were adapted from
# https://github.com/python/cpython/blob/48e8c82fc63d2ddcddce8aa637a892839b551619/Lib/test/test_ntpath.py,
# hence the flying circus names, but I like dead parrots too, so keeping them.
describe("path_expand", {
  it("works on windows", {
    with_mock("fs:::is_windows" = function() TRUE, {
      withr::with_envvar(c("USERPROFILE" = NA, "HOMEDRIVE" = NA, "HOMEPATH" = NA), {
        expect_equal(path_expand("~test"), "~test")
      })
      withr::with_envvar(c("USERPROFILE" = NA, "HOMEDRIVE" = "C:\\", "HOMEPATH" = "eric\\idle"), {
        expect_equal(path_expand("~"), "C:/eric/idle")
        expect_equal(path_expand("~test"), "C:/eric/test")
      })
      withr::with_envvar(c("USERPROFILE" = NA, "HOMEDRIVE" = NA, "HOMEPATH" = "eric/idle"), {
        expect_equal(path_expand("~"), "eric/idle")
        expect_equal(path_expand("~test"), "eric/test")
      })
      withr::with_envvar(c("USERPROFILE" = "C:\\idle\\eric"), {
        expect_equal(path_expand("~"), "C:/idle/eric")
        expect_equal(path_expand("~test"), "C:/idle/test")


        expect_equal(path_expand("~test/foo/bar"), "C:/idle/test/foo/bar")
        expect_equal(path_expand("~test/foo/bar/"), "C:/idle/test/foo/bar")
        expect_equal(path_expand("~test\\foo\\bar"), "C:/idle/test/foo/bar")
        expect_equal(path_expand("~test\\foo\\bar\\"), "C:/idle/test/foo/bar")
        expect_equal(path_expand("~/foo/bar"), "C:/idle/eric/foo/bar")
        expect_equal(path_expand("~\\foo\\bar"), "C:/idle/eric/foo/bar")
      })
      withr::with_envvar(c("USERPROFILE" = "C:\\idle\\eric", "R_FS_HOME" = "C:\\john\\cleese"), {
        # R_FS_HOME overrides userprofile
        expect_equal(path_expand("~"), "C:/john/cleese")
        expect_equal(path_expand("~test"), "C:/john/test")
      })
    })
  })
  it("repects R_FS_HOME", {
    withr::with_envvar(c("R_FS_HOME" = "/foo/bar"), {
      expect_equal(path_expand("~"), "/foo/bar")
      expect_equal(path_expand("~test"), "/foo/test")
    })
  })
})
