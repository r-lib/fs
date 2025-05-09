describe("file_delete", {
  with_dir_tree(list("foo/bar" = "test"), {
    it("returns the input path and deletes the file", {
      expect_true(file_exists("foo/bar"))
      expect_equal(file_delete("foo/bar"), fs_path("foo/bar"))
      expect_false(file_exists("foo/bar"))
    })
    it("can delete directories and files", {
      dir_create("baz")

      expect_true(dir_exists("baz"))
      expect_equal(file_delete("baz"), fs_path("baz"))
      expect_false(dir_exists("baz"))

      dir_create("baz")
      file_create(c("baz/bar", "faz"))

      expect_true(dir_exists("baz"))
      expect_true(file_exists("faz"))

      expect_equal(file_delete(c("baz", "faz")), fs_path(c("baz", "faz")))

      expect_false(dir_exists("baz"))
      expect_false(file_exists("faz"))
    })
    it("errors on missing input", {
      expect_error(file_delete(NA), class = "invalid_argument")
    })
  })
})

describe("dir_delete", {
  it("deletes an empty directory and returns the path", {
    with_dir_tree(list("foo"), {
      expect_true(dir_exists("foo"))
      expect_equal(dir_delete("foo"), fs_path("foo"))
      expect_false(dir_exists("foo"))
    })
  })
  it("deletes a non-empty directory and returns the path", {
    with_dir_tree(
      list("foo/bar" = "test", "foo/baz" = "test2"),
      {
        expect_true(dir_exists("foo"))
        expect_equal(dir_delete("foo"), fs_path("foo"))
        expect_false(dir_exists("foo"))
      }
    )
  })
  it("deletes nested directories and returns the path", {
    with_dir_tree(
      list("foo/bar/baz" = "test", "foo/baz/qux" = "test2"),
      {
        expect_true(dir_exists("foo"))
        expect_equal(dir_delete("foo"), fs_path("foo"))
        expect_false(dir_exists("foo"))
      }
    )
  })
  it("deletes a non-empty directory with hidden files and directories and returns the path", {
    with_dir_tree(
      list(
        "foo/bar" = "test",
        "foo/baz" = "test2",
        "foo/.blah" = "foo",
        ".dir"
      ),
      {
        expect_true(dir_exists("foo"))
        expect_equal(dir_delete("foo"), fs_path("foo"))
        expect_false(dir_exists("foo"))
      }
    )
  })
  it("errors on missing input", {
    expect_error(dir_delete(NA), class = "invalid_argument")
  })
})

describe("link_delete", {
  skip_on_os("windows")

  with_dir_tree(list("foo/bar" = "test"), {
    link_create("foo/bar", "loo")
    it("returns the input path and deletes the file", {
      expect_true(file_exists("loo"))
      expect_equal(link_delete("loo"), fs_path("loo"))
      expect_false(file_exists("loo"))
    })
    it("errors on missing input", {
      expect_error(link_delete(NA), class = "invalid_argument")
    })
    it("errors on non-link input", {
      expect_error(link_delete("foo"), class = "invalid_argument")
      expect_error(link_delete("foo/bar"), class = "invalid_argument")
    })
  })
})
