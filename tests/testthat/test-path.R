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
    expect_equal(path(""), fs_path(""))
    expect_equal(path(character()), fs_path(character()))
    expect_equal(path("foo", character(), "bar"), fs_path(character()))
  })

  it("propagates NA strings", {
    expect_equal(path(NA_character_), fs_path(NA_character_))
    expect_equal(path("foo", NA_character_), fs_path(NA_character_))
    expect_equal(
      path(c("foo", "bar"), c("baz", NA_character_)),
      fs_path(c("foo/baz", NA_character_))
    )
  })

  it("appends a ext if provided", {
    expect_equal(path("foo", ext = "bar"), fs_path("foo.bar"))
    expect_equal(
      path(c("foo", "baz"), ext = "bar"),
      fs_path(c("foo.bar", "baz.bar"))
    )
    expect_equal(
      path(c("foo", "baz", NA_character_), ext = "bar"),
      fs_path(c("foo.bar", "baz.bar", NA_character_))
    )
  })

  it("does not double paths", {
    expect_equal(path("/", "foo"), fs_path("/foo"))
    expect_equal(path("\\", "foo"), fs_path("/foo"))
    expect_equal(path("", "foo"), fs_path("/foo"))
    expect_equal(path("foo/", "bar"), fs_path("foo/bar"))
    expect_equal(path("foo\\", "bar"), fs_path("foo/bar"))
    expect_equal(path("foo//", "bar"), fs_path("foo/bar"))

    # This could be a UNC path, so we keep the doubled path.
    expect_equal(path("//", "foo"), fs_path("//foo"))
  })

  it("errors on paths which are too long", {
    expect_snapshot(
      error = TRUE,
      {
        path(paste(rep("a", 100000), collapse = ""))
        do.call(path, as.list(rep("a", 100000)))
      },
      transform = transform_path_max
    )
  })

  it("follows recycling rules", {
    expect_equal(path("foo", character()), fs_path(character()))
    expect_equal(path("foo", "bar"), fs_path("foo/bar"))
    expect_equal(
      path("foo", c("bar", "baz")),
      fs_path(c("foo/bar", "foo/baz"))
    )
    expect_equal(
      path(c("foo", "qux"), c("bar", "baz")),
      fs_path(c("foo/bar", "qux/baz"))
    )

    expect_error(
      path(c("foo", "qux", "foo2"), c("bar", "baz")),
      "Arguments must have consistent lengths",
      class = "invalid_argument"
    )

    expect_equal(path(ext = character()), fs_path(character()))
    expect_equal(path("foo", ext = character()), fs_path(character()))
    expect_equal(path("foo", ext = "bar"), fs_path("foo.bar"))
    expect_equal(
      path("foo", ext = c("bar", "baz")),
      fs_path(c("foo.bar", "foo.baz"))
    )
    expect_equal(
      path(c("foo", "qux"), ext = c("bar", "baz")),
      fs_path(c("foo.bar", "qux.baz"))
    )

    expect_error(
      path(c("foo", "qux", "foo2"), ext = c("bar", "baz")),
      "Arguments must have consistent lengths",
      class = "invalid_argument"
    )
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

  it("works with indirect symlinks", {
    skip_on_os("windows")

    with_dir_tree("foo", {
      wd <- path_wd()
      link_create(path("..", path_file(wd)), "self")
      link_create("self", "link")
      expect_equal(path_real("link"), wd)
    })
  })

  it("works with parent symlinks", {
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
        file_create("a")
        expect_equal(path_real("a"), path(wd, "/y/a"))
        unlink("a")
      })
    })
  })

  it("resolves paths before normalizing", {
    skip_on_os("windows")

    # if we have the following hierarchy: a/k/y
    # and a symbolic link 'link-y' pointing to 'y' in directory 'a',
    # then `path_real("link-y/..")` should return 'k', not 'a'.
    with_dir_tree("a/k/y", {
      link_create("a/k/y", "link-y")

      expect_equal(path_real("link-y/.."), path_real("a/k"))
    })
  })

  it("resolves paths before normalizing", {
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
      link_create(path_real("foo"), fs_path("foo2"))
      expect_equal(path_real(NA_character_), fs_path(NA_character_))
      expect_equal(
        path_real(c("foo2", NA_character_)),
        fs_path(c(path_real("foo"), NA_character_))
      )
    })
  })

  it("converts inputs to character if required", {
    with_dir_tree(list("foo/bar" = "test"), {
      link_create(path_real("foo"), "2")
      expect_equal(path_real(NA), fs_path(NA_character_)) ## NA (logical) coerced to NA_character_
      expect_equal(path_real(2), path_real("2"))
    })
  })
})

describe("path_split", {
  it("returns the path split", {
    expect_equal(path_split("foo/bar")[[1]], c("foo", "bar"))
    expect_equal(
      path_split(c("foo/bar", "foo/baz")),
      list(c("foo", "bar"), c("foo", "baz"))
    )
  })

  it("does not split the root path", {
    expect_equal(path_split("/usr/bin")[[1]], c("/", "usr", "bin"))
    expect_equal(path_split("c:/usr/bin")[[1]], c("C:", "usr", "bin"))
    expect_equal(path_split("X:/usr/bin")[[1]], c("X:", "usr", "bin"))
    expect_equal(
      path_split("//server/usr/bin")[[1]],
      c("//server", "usr", "bin")
    )
    expect_equal(
      path_split("\\\\server\\usr\\bin")[[1]],
      c("//server", "usr", "bin")
    )
  })
})

describe("path_tidy", {
  it("does not expand ~", {
    expect_equal(path_tidy("~/foo"), fs_path("~/foo"))
    expect_equal(path_tidy("~/foo/"), fs_path("~/foo"))
    expect_equal(path_tidy("~//foo"), fs_path("~/foo"))
    expect_equal(path_tidy("~//foo"), fs_path("~/foo"))
    expect_equal(path_tidy("~\\foo\\"), fs_path("~/foo"))
  })

  it("always uses / for delimiting, never multiple / or trailing /", {
    expect_equal(path_tidy("foo/bar/baz"), fs_path("foo/bar/baz"))
    expect_equal(path_tidy("foo/bar/baz/"), fs_path("foo/bar/baz"))
    expect_equal(path_tidy("foo//bar//baz"), fs_path("foo/bar/baz"))
    expect_equal(path_tidy("foo//bar//baz//"), fs_path("foo/bar/baz"))
    expect_equal(path_tidy("foo\\bar\\baz"), fs_path("foo/bar/baz"))
    expect_equal(path_tidy("foo\\\\bar\\\\baz"), fs_path("foo/bar/baz"))
    expect_equal(path_tidy("//foo\\\\bar\\\\baz"), fs_path("//foo/bar/baz"))
    expect_equal(path_tidy("foo\\\\bar\\\\baz\\"), fs_path("foo/bar/baz"))
    expect_equal(path_tidy("foo\\\\bar\\\\baz\\\\"), fs_path("foo/bar/baz"))
  })

  it("always capitalizes and appends windows root paths with /", {
    expect_equal(path_tidy("C:"), fs_path("C:/"))
    expect_equal(path_tidy("c:"), fs_path("C:/"))
    expect_equal(path_tidy("X:"), fs_path("X:/"))
    expect_equal(path_tidy("x:"), fs_path("X:/"))
    expect_equal(path_tidy("c:/"), fs_path("C:/"))
    expect_equal(path_tidy("c://"), fs_path("C:/"))
    expect_equal(path_tidy("c:\\"), fs_path("C:/"))
    expect_equal(path_tidy("c:\\\\"), fs_path("C:/"))
  })

  it("passes NA along", {
    expect_equal(path_tidy(NA_character_), fs_path(NA_character_))
    expect_equal(
      path_tidy(c("foo/bar", NA_character_)),
      fs_path(c("foo/bar", NA_character_))
    )
  })

  it("works for non-UTF8 path", {
    x <- "folder//fa\xE7ile.txt/"
    Encoding(x) <- "latin1"
    out <- fs::path_tidy(x)
    expect_equal(Encoding(out), "UTF-8")
    expect_equal(out, fs_path("folder/façile.txt"))
  })

  it("converts inputs to character if required", {
    expect_equal(
      path_tidy(c("foo/bar", NA)),
      fs_path(c("foo/bar", NA_character_))
    )
    expect_equal(path_tidy(1), fs_path("1"))
  })
})

describe("path_temp", {
  it("returned tidies tempdir()", {
    expect_equal(path_temp(), path_tidy(tempdir()))
  })
})

describe("path_ext", {
  it("returns 0 length outputs for 0 length inputs", {
    expect_equal(path_ext(character()), character())
  })

  it("returns the path extension, or \"\" if one does not exist", {
    expect_equal(path_ext("foo.bar"), "bar")
    expect_equal(path_ext("foo.boo.bar"), "bar")
    expect_equal(path_ext("foo.boo.biff.bar"), "bar")
    expect_equal(path_ext(".csh.rc"), "rc")
    expect_equal(path_ext("nodots"), "")
    expect_equal(path_ext(".cshrc"), "")
    expect_equal(path_ext("...manydots"), "")
    expect_equal(path_ext("...manydots.ext"), "ext")
    expect_equal(path_ext("manydots..."), "")
    expect_equal(path_ext("manydots...ext"), "ext")
    expect_equal(path_ext("."), "")
    expect_equal(path_ext(".."), "")
    expect_equal(path_ext("........"), "")
    expect_equal(path_ext(""), "")
    expect_equal(path_ext(".bar"), "")
    expect_equal(path_ext("foo/.bar"), "")
    expect_equal(path_ext(c("foo.bar", NA_character_)), c("bar", NA_character_))
    expect_equal(path_ext("foo.bar/baz"), "")
  })
  it("works with non-ASCII inputs", {
    skip_if_not_utf8()

    expect_equal(path_ext("f\U00F6\U00F6.txt"), "txt")
    expect_equal(path_ext("f\U00F6\U00F6.t\U00E4r"), "t\U00E4r")
  })
  it("returns a normal character vector", {
    expect_equal(class(path_dir("foo.sh")), "character")
  })
})

describe("path_ext_remove", {
  it("removes the path extension", {
    expect_equal(path_ext_remove("foo.bar"), "foo")
    expect_equal(path_ext_remove("foo.boo.bar"), "foo.boo")
    expect_equal(path_ext_remove("foo.boo.biff.bar"), "foo.boo.biff")
    expect_equal(path_ext_remove(".csh.rc"), ".csh")
    expect_equal(path_ext_remove("nodots"), "nodots")
    expect_equal(path_ext_remove(".cshrc"), ".cshrc")
    expect_equal(path_ext_remove("...manydots"), "...manydots")
    expect_equal(path_ext_remove("...manydots.ext"), "...manydots")
    expect_equal(path_ext_remove("manydots..."), "manydots...")
    expect_equal(path_ext_remove("manydots...ext"), "manydots")
    expect_equal(path_ext_remove("."), ".")
    expect_equal(path_ext_remove(".."), "..")
    expect_equal(path_ext_remove("........"), "........")
    expect_equal(path_ext_remove(""), "")
    expect_equal(path_ext_remove(NA_character_), NA_character_)
    expect_equal(
      path_ext_remove(c("foo.bar", NA_character_)),
      c("foo", NA_character_)
    )
    expect_equal(path_ext_remove(".bar"), ".bar")
    expect_equal(path_ext_remove("foo/.bar"), "foo/.bar")
    expect_equal(path_ext_remove("foo.bar/abc.123"), "foo.bar/abc")
    expect_equal(path_ext_remove("foo.bar/abc"), "foo.bar/abc")
  })
  it("works with non-ASCII inputs", {
    skip_if_not_utf8()

    expect_equal(path_ext_remove("f\U00F6\U00F6.txt"), "f\U00F6\U00F6")
    expect_equal(path_ext_remove("f\U00F6\U00F6.t\U00E4r"), "f\U00F6\U00F6")
  })
})

describe("path_ext_set", {
  it("replaces the path extension", {
    expect_equal(path_ext_set("foo.bar", "baz"), fs_path("foo.baz"))
    expect_equal(path_ext_set("foo.boo.bar", "baz"), fs_path("foo.boo.baz"))
    expect_equal(
      path_ext_set("foo.boo.biff.bar", "baz"),
      fs_path("foo.boo.biff.baz")
    )
    expect_equal(path_ext_set(".csh.rc", "gz"), fs_path(".csh.gz"))
    expect_equal(path_ext_set("nodots", "bar"), fs_path("nodots.bar"))
    expect_equal(path_ext_set(".cshrc", "bar"), fs_path(".cshrc.bar"))
    expect_equal(
      path_ext_set("...manydots", "bar"),
      fs_path("...manydots.bar")
    )
    expect_equal(
      path_ext_set("...manydots.ext", "bar"),
      fs_path("...manydots.bar")
    )
    expect_equal(path_ext_set(".", "bar"), fs_path("..bar"))
    expect_equal(path_ext_set("..", "bar"), fs_path("...bar"))
    expect_equal(path_ext_set("........", "bar"), fs_path(".........bar"))
    expect_equal(path_ext_set("", "bar"), fs_path(".bar"))
    expect_equal(path_ext_set(NA_character_, "bar"), fs_path(NA_character_))
    expect_equal(
      path_ext_set(c("foo", NA_character_), "bar"),
      fs_path(c("foo.bar", NA_character_))
    )
    expect_equal(path_ext_set(".bar", "baz"), fs_path(".bar.baz"))
    expect_equal(path_ext_set("foo/.bar", "baz"), fs_path("foo/.bar.baz"))
    expect_equal(path_ext_set("foo", ""), fs_path("foo"))
  })
  it("works the same with and without a leading . for ext", {
    expect_equal(path_ext_set("foo", "bar"), fs_path("foo.bar"))
    expect_equal(path_ext_set("foo", ".bar"), fs_path("foo.bar"))
  })
  it("only removes a leading . from the extension", {
    expect_equal(path_ext_set("foo", "b.ar"), fs_path("foo.b.ar"))
    expect_equal(path_ext_set("foo", ".b.ar"), fs_path("foo.b.ar"))
  })
  it("works with multiple paths (#205)", {
    multiple_paths <- c("a", "b")
    expect_equal(
      path_ext_set(multiple_paths, "csv"),
      fs_path(c("a.csv", "b.csv"))
    )
  })
  it("works with multiple extensions (#250)", {
    multiple_paths <- c("a", "b")
    multiple_exts <- c("csv", "tsv")
    expect_equal(
      path_ext_set(multiple_paths, multiple_exts),
      fs_path(c("a.csv", "b.tsv"))
    )

    expect_error(
      path_ext_set(multiple_paths, c(multiple_exts, "xls")),
      class = "fs_error",
      "consistent lengths"
    )
  })
  it("works with non-ASCII inputs", {
    skip_if_not_utf8()

    expect_equal(
      path_ext_set("f\U00F6\U00F6.txt", "bar"),
      fs_path("f\U00F6\U00F6.bar")
    )
    expect_equal(
      path_ext_set("f\U00F6\U00F6.t\U00E4r", "bar"),
      fs_path("f\U00F6\U00F6.bar")
    )
  })
})

describe("path_ext<-", {
  it("replaces the path extension", {
    x <- "...manydots"
    path_ext(x) <- "bar"
    expect_equal(x, fs_path("...manydots.bar"))
  })
})

# test cases derived from https://github.com/python/cpython/blob/6f0eb93183519024cb360162bdd81b9faec97ba6/Lib/test/test_posixpath.py#L276

describe("path_norm", {
  it("works with POSIX paths", {
    expect_equal(path_norm(""), fs_path("."))
    expect_equal(path_norm(""), fs_path("."))
    expect_equal(path_norm(".."), fs_path(".."))
    expect_equal(path_norm("/../../.."), fs_path("/"))
    expect_equal(path_norm("/../.././.."), fs_path("/"))
    expect_equal(path_norm("../.././.."), fs_path("../../.."))
    expect_equal(path_norm("/"), fs_path("/"))
    expect_equal(path_norm("//"), fs_path("/"))
    expect_equal(path_norm("///"), fs_path("/"))
    expect_equal(path_norm("//foo"), fs_path("//foo"))
    expect_equal(path_norm("//foo/.//bar//"), fs_path("//foo/bar"))
    expect_equal(path_norm("/foo/.//bar//.//..//.//baz"), fs_path("/foo/baz"))
    expect_equal(path_norm("/..//./foo/.//bar"), fs_path("/foo/bar"))
  })

  it("works with POSIX paths", {
    expect_equal(path_norm("A//////././//.//B"), fs_path("A/B"))
    expect_equal(path_norm("A/./B"), fs_path("A/B"))
    expect_equal(path_norm("A/foo/../B"), fs_path("A/B"))
    expect_equal(path_norm("C:A//B"), fs_path("C:A/B"))
    expect_equal(path_norm("D:A/./B"), fs_path("D:A/B"))
    expect_equal(path_norm("e:A/foo/../B"), fs_path("E:A/B"))

    expect_equal(path_norm("C:///A//B"), fs_path("C:/A/B"))
    expect_equal(path_norm("D:///A/./B"), fs_path("D:/A/B"))
    expect_equal(path_norm("e:///A/foo/../B"), fs_path("E:/A/B"))

    expect_equal(path_norm(".."), fs_path(".."))
    expect_equal(path_norm("."), fs_path("."))
    expect_equal(path_norm(""), fs_path("."))
    expect_equal(path_norm("/"), fs_path("/"))
    expect_equal(path_norm("c:/"), fs_path("C:/"))
    expect_equal(path_norm("/../.././.."), fs_path("/"))
    expect_equal(path_norm("c:/../../.."), fs_path("C:/"))
    expect_equal(path_norm("../.././.."), fs_path("../../.."))
    expect_equal(path_norm("C:////a/b"), fs_path("C:/a/b"))
    expect_equal(
      path_norm("//machine/share//a/b"),
      fs_path("//machine/share/a/b")
    )

    expect_equal(path_norm("\\\\?\\D:/XY\\Z"), fs_path("//?/D:/XY/Z"))
  })

  it("works with missing values", {
    expect_equal(path_norm(NA), fs_path(NA_character_))
    expect_equal(path_norm(c("foo", NA)), fs_path(c("foo", NA)))
    expect_equal(
      path_norm(c(NA, NA)),
      fs_path(c(NA_character_, NA_character_))
    )
  })
})

# Test cases derived from https://github.com/python/cpython/blob/6f0eb93183519024cb360162bdd81b9faec97ba6/Lib/test/test_posixpath.py

describe("path_common", {
  it("finds the common path", {
    expect_error(path_common(c("/usr", "usr")), "Can't mix", class = "fs_error")
    expect_error(path_common(c("usr", "/usr")), "Can't mix", class = "fs_error")

    expect_equal(path_common(c("/usr/local")), fs_path("/usr/local"))
    expect_equal(
      path_common(c("/usr/local", "/usr/local")),
      fs_path("/usr/local")
    )
    expect_equal(
      path_common(c("/usr/local/", "/usr/local")),
      fs_path("/usr/local")
    )
    expect_equal(
      path_common(c("/usr/local/", "/usr/local/")),
      fs_path("/usr/local")
    )
    expect_equal(
      path_common(c("/usr//local/bin", "/usr/local//bin")),
      fs_path("/usr/local/bin")
    )
    expect_equal(
      path_common(c("/usr/./local", "/./usr/local")),
      fs_path("/usr/local")
    )
    expect_equal(
      path_common(c("/", "/dev")),
      fs_path("/")
    )
    expect_equal(
      path_common(c("/usr", "/dev")),
      fs_path("/")
    )
    expect_equal(
      path_common(c("/usr/lib/", "/usr/lib/python3")),
      fs_path("/usr/lib")
    )
    expect_equal(
      path_common(c("/usr/lib/", "/usr/lib64/")),
      fs_path("/usr")
    )

    expect_equal(
      path_common(c("/usr/lib", "/usr/lib64")),
      fs_path("/usr")
    )
    expect_equal(
      path_common(c("/usr/lib/", "/usr/lib64")),
      fs_path("/usr")
    )

    expect_equal(
      path_common(c("spam")),
      fs_path("spam")
    )
    expect_equal(
      path_common(c("spam", "spam")),
      fs_path("spam")
    )
    expect_equal(
      path_common(c("spam", "alot")),
      fs_path("")
    )
    expect_equal(
      path_common(c("and/jam", "and/spam")),
      fs_path("and")
    )
    expect_equal(
      path_common(c("and//jam", "and/spam//")),
      fs_path("and")
    )
    expect_equal(
      path_common(c("and/./jam", "./and/spam")),
      fs_path("and")
    )
    expect_equal(path_common(c("and/jam", "and/spam", "alot")), fs_path(""))
    expect_equal(path_common(c("and/jam", "and/spam", "and")), fs_path("and"))

    expect_equal(path_common(c("")), fs_path(""))
    expect_equal(path_common(c("", "spam/alot")), fs_path(""))

    expect_error(
      path_common(c("", "/spam/alot")),
      "Can't mix",
      class = "fs_error"
    )
  })

  it("returns NA if any input is NA", {
    expect_equal(path_common(NA), fs_path(NA_character_))
    expect_equal(path_common(c("and/jam", NA)), fs_path(NA_character_))
    expect_equal(path_common(c("and/jam", NA, "and")), fs_path(NA_character_))
  })
})

describe("path_has_parent", {
  it("works on single paths", {
    expect_false(path_has_parent("foo", "bar"))
    expect_false(path_has_parent("foo", "foo/bar"))

    expect_false(path_has_parent("/usr/var2/log", "/usr/var"))

    expect_true(path_has_parent("foo/bar", "foo"))
    expect_true(path_has_parent(
      "path/myfiles/myfile",
      "path/to/files/../../myfiles"
    ))

    # expands path
    expect_true(path_has_parent("~/a", path_expand("~/a")))
    expect_true(path_has_parent(path_expand("~/a"), "~/a"))
  })
  it("works with multiple paths", {
    expect_equal(path_has_parent(c("/a/b/c", "x/y"), "/a/b"), c(TRUE, FALSE))

    expect_equal(path_has_parent("/a/b/c", c("/a/b", "/x/y")), c(TRUE, FALSE))

    expect_error(
      path_has_parent(c("/a/b/c", "x/y"), c("/a/b", "x/y", "foo/bar")),
      "consistent lengths",
      class = "invalid_argument"
    )
  })
})

describe("path_join", {
  it("converts inputs to character if required", {
    expect_equal(path_join(c("a", NA)), path_join(c("a", NA_character_)))
    expect_equal(path_join(c("a", 1)), path_join(c("a", "1")))
    expect_equal(
      path_join(list(c("a", 1), c("a/b", 2))),
      fs_path(c(path_join(c("a", "1")), path_join(c("a/b", "2"))))
    )
  })
  it("works with list inputs", {
    expect_equal(
      path_join(list(c("foo", "bar"), c("a/b", "c"))),
      fs_path(c(path_join(c("foo", "bar")), path_join(c("a/b", "c"))))
    )
    expect_equal(
      path_join(list(NA, c("a", 1), c("a/b", 2))),
      fs_path(c(
        path_join(NA_character_),
        path_join(c("a", "1")),
        path_join(c("a/b", "2"))
      ))
    )
  })
})

# derived from https://github.com/python/cpython/blob/6f0eb93183519024cb360162bdd81b9faec97ba6/Lib/test/test_posixpath.py#L483
describe("path_rel", {
  it("works for POSIX paths", {
    cur_dir <- path_file(getwd())
    expect_equal(path_rel("a"), fs_path("a"))
    expect_equal(path_rel(path_abs("a")), fs_path("a"))
    expect_equal(path_rel("a/b"), fs_path("a/b"))
    expect_equal(path_rel("../a/b"), fs_path("../a/b"))
    expect_equal(path_rel("a", "../b"), path_join(c("..", cur_dir, "a")))
    expect_equal(path_rel("a/b", "../c"), path_join(c("..", cur_dir, "a", "b")))
    expect_equal(path_rel("a", "b/c"), fs_path("../../a"))
    expect_equal(path_rel("a", "a"), fs_path("."))
    expect_equal(
      path_rel("/foo/bar/bat", "/x/y/z"),
      fs_path("../../../foo/bar/bat")
    )
    expect_equal(path_rel("/foo/bar/bat", "/foo/bar"), fs_path("bat"))
    expect_equal(path_rel("/foo/bar/bat", "/"), fs_path("foo/bar/bat"))
    expect_equal(path_rel("/", "/foo/bar/bat"), fs_path("../../.."))
    expect_equal(path_rel("/foo/bar/bat", "/x"), fs_path("../foo/bar/bat"))
    expect_equal(path_rel("/x", "/foo/bar/bat"), fs_path("../../../x"))
    expect_equal(path_rel("/", "/"), fs_path("."))
    expect_equal(path_rel("/a", "/a"), fs_path("."))
    expect_equal(path_rel("/a/b", "/a/b"), fs_path("."))

    expect_equal(
      path_rel(c("a", "a/b", "a/b/c"), "a/b"),
      fs_path(c("..", ".", "c"))
    )
    expect_snapshot(
      error = TRUE,
      path_rel(c("a", "a/b", "a/b/c"), c("a/b", "a"))
    )
  })

  it("works for windows paths", {
    expect_equal(
      path_rel("c:/foo/bar/bat", "c:/x/y"),
      fs_path("../../foo/bar/bat")
    )
    expect_equal(
      path_rel("//conky/mountpoint/a", "//conky/mountpoint/b/c"),
      fs_path("../../a")
    )
    expect_equal(
      path_rel("d:/Users/a", "D:/Users/b"),
      fs_path("../a")
    )
  })

  it("expands path before computing relativity", {
    expect_equal(
      path_rel("/foo/bar/baz", "~"),
      path_rel("/foo/bar/baz", path_expand("~"))
    )
    expect_equal(path_rel("~/foo/bar/baz", "~"), fs_path("foo/bar/baz"))
  })

  it("propagates NAs", {
    expect_equal(path_rel(NA_character_), fs_path(NA_character_))
    expect_equal(
      path_rel("/foo/bar/baz", NA_character_),
      fs_path(NA_character_)
    )
  })

  it("can be reversed by path_abs", {
    skip_on_os("windows")

    f <- file_temp()
    expect_equal(path_abs(path_rel(f)), f)

    home <- path_home()
    home_f <- path_abs(path_home("../../foo/bar/baz"))

    expect_equal(path_abs(path_rel(home_f, start = home), start = home), home_f)
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
  it("returns a normal character vector", {
    expect_equal(class(path_dir("foo/bar")), "character")
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
  it("returns a normal character vector", {
    expect_equal(class(path_dir("foo/bar")), "character")
  })
})

# These tests were adapted from
# https://github.com/python/cpython/blob/48e8c82fc63d2ddcddce8aa637a892839b551619/Lib/test/test_ntpath.py,
# hence the flying circus names, but I like dead parrots too, so keeping them.
describe("path_expand", {
  it("works on windows", {
    withr::local_envvar(c(FS_IS_WINDOWS = "TRUE"))
    withr::with_envvar(
      c("USERPROFILE" = NA, "HOMEDRIVE" = NA, "HOMEPATH" = NA),
      {
        expect_equal(path_expand("~test"), fs_path("~test"))
      }
    )
    withr::with_envvar(
      c("USERPROFILE" = NA, "HOMEDRIVE" = "C:\\", "HOMEPATH" = "eric\\idle"),
      {
        expect_equal(path_expand("~"), fs_path("C:/eric/idle"))
        expect_equal(path_expand("~test"), fs_path("C:/eric/test"))
      }
    )
    withr::with_envvar(
      c("USERPROFILE" = NA, "HOMEDRIVE" = NA, "HOMEPATH" = "eric/idle"),
      {
        expect_equal(path_expand("~"), fs_path("eric/idle"))
        expect_equal(path_expand("~test"), fs_path("eric/test"))
      }
    )
    withr::with_envvar(c("USERPROFILE" = "C:\\idle\\eric"), {
      expect_equal(path_expand("~"), fs_path("C:/idle/eric"))
      expect_equal(path_expand("~test"), fs_path("C:/idle/test"))

      expect_equal(
        path_expand("~test/foo/bar"),
        fs_path("C:/idle/test/foo/bar")
      )
      expect_equal(
        path_expand("~test/foo/bar/"),
        fs_path("C:/idle/test/foo/bar")
      )
      expect_equal(
        path_expand("~test\\foo\\bar"),
        fs_path("C:/idle/test/foo/bar")
      )
      expect_equal(
        path_expand("~test\\foo\\bar\\"),
        fs_path("C:/idle/test/foo/bar")
      )
      expect_equal(
        path_expand("~/foo/bar"),
        fs_path("C:/idle/eric/foo/bar")
      )
      expect_equal(
        path_expand("~\\foo\\bar"),
        fs_path("C:/idle/eric/foo/bar")
      )
    })
    withr::with_envvar(
      c("USERPROFILE" = "C:\\idle\\eric", "R_FS_HOME" = "C:\\john\\cleese"),
      {
        # R_FS_HOME overrides userprofile
        expect_equal(path_expand("~"), fs_path("C:/john/cleese"))
        expect_equal(path_expand("~test"), fs_path("C:/john/test"))
      }
    )
  })
  it("repects R_FS_HOME", {
    withr::with_envvar(c("R_FS_HOME" = "/foo/bar"), {
      expect_equal(path_expand("~"), fs_path("/foo/bar"))
      expect_equal(path_expand("~test"), fs_path("/foo/test"))
    })
  })
})
