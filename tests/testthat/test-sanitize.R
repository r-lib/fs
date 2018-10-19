context("sanitize")

test_that("valid names", {
  expect_equal(path_sanitize("the quick brown fox jumped over the lazy dog.mp3"), "the quick brown fox jumped over the lazy dog.mp3")
  expect_equal(path_sanitize("résumé"), "résumé")
})

test_that("valid names", {
  expect_equal(path_sanitize("the quick brown fox jumped over the lazy dog.mp3", "_"), "the quick brown fox jumped over the lazy dog.mp3")
  expect_equal(path_sanitize("résumé", "_"), "résumé")
})

test_that("control characters", {
  expect_equal(path_sanitize("hello\nworld"), "helloworld")
})

test_that("control characters", {
  expect_equal(path_sanitize("hello\nworld", "_"), "hello_world")
})

test_that("restricted codes", {
  expect_equal(path_sanitize("h?w"), "hw")
  expect_equal(path_sanitize("h/w"), "hw")
  expect_equal(path_sanitize("h*w"), "hw")
})

test_that("restricted codes", {
  expect_equal(path_sanitize("h?w", "_"), "h_w")
  expect_equal(path_sanitize("h/w", "_"), "h_w")
  expect_equal(path_sanitize("h*w", "_"), "h_w")
})

# https://msdn.microsoft.com/en-us/library/aa365247(v=vs.85).aspx
test_that("restricted suffixes", {
  expect_equal(path_sanitize("mr."), "mr")
  expect_equal(path_sanitize("mr.."), "mr")
  expect_equal(path_sanitize("mr "), "mr")
  expect_equal(path_sanitize("mr  "), "mr")
})

test_that("relative paths", {
  expect_equal(path_sanitize("."), "")
  expect_equal(path_sanitize(".."), "")
  expect_equal(path_sanitize("./"), "")
  expect_equal(path_sanitize("../"), "")
  expect_equal(path_sanitize("/.."), "")
  expect_equal(path_sanitize("/../"), "")
  expect_equal(path_sanitize("*.|."), "")
})

test_that("relative path with replacement", {
  expect_equal(path_sanitize("..", "_"), "_")
})

test_that("reserved filename in Windows", {
  expect_equal(path_sanitize("con"), "")
  expect_equal(path_sanitize("COM1"), "")
  expect_equal(path_sanitize("PRN."), "")
  expect_equal(path_sanitize("aux.txt"), "")
  expect_equal(path_sanitize("LPT9.asdfasdf"), "")
  expect_equal(path_sanitize("LPT10.txt"), "LPT10.txt")
})

test_that("reserved filename in Windows with replacement", {
  expect_equal(path_sanitize("con", "_"), "_")
  expect_equal(path_sanitize("COM1", "_"), "_")
  expect_equal(path_sanitize("PRN.", "_"), "_")
  expect_equal(path_sanitize("aux.txt", "_"), "_")
  expect_equal(path_sanitize("LPT9.asdfasdf", "_"), "_")
  expect_equal(path_sanitize("LPT10.txt", "_"), "LPT10.txt")
})

test_that("invalid replacement", {
  expect_equal(path_sanitize(".", "."), "")
  expect_equal(path_sanitize("foo?.txt", ">"), "foo.txt")
  expect_equal(path_sanitize("con.txt", "aux"), "")
  expect_equal(path_sanitize("valid.txt", "\\/:*?\"<>|"), "valid.txt")
})

test_string_fs <- function(str, tmpdir) {
  sanitized <- path_sanitize(str)
  if (sanitized == "") {
    sanitized <- "default"
  }
  filepath <- path(tmpdir, sanitized)

  # Should not contain any directories or relative paths
  expect_equal(path_dir(path("/abs/path", sanitized)), "/abs/path")

  # Should write and read file to disk
  expect_equal(path_dir(path_tidy(filepath)), tmpdir)
  expect_error_free(
    writeLines("foobar", filepath))
  expect_equal(readLines(filepath), "foobar")
  expect_error_free(file_delete(filepath))
}

test_that("filesystems can read, write and delete sanitized files", {
  skip_on_os("solaris")

 strings <- c(
   # Windows R functions cannot handle the unicode filenames or long filenames + paths correctly.
   if (!is_windows()) {
     readLines(testthat::test_path("blns.txt.xz"), encoding = "UTF-8")
   },
   "the quick brown fox jumped over the lazy dog",
   "résumé",
   "hello\nworld",
   "semi;colon.js",
   ";leading-semi.js",
   "mode_tslash\\.js",
   "slash/.js",
   "col:on.js",
   "star*.js",
   "question?.js",
   "quote\".js",
   "singlequote'.js",
   "brack<e>ts.js",
   "p|pes.js",
   "plus+.js",
   "'five and six<seven'.js",
   " space at front",
   "space at end ",
   ".period",
   "period.",
   "relative/path/to/some/dir",
   "/abs/path/to/some/dir",
   "~/.notssh/authorized_keys",
   "",
   "h?w",
   "h/w",
   "h*w",
   ".",
   "..",
   "./",
   "../",
   "/..",
   "/../",
   "*.|.",
   "./",
   "./foobar",
   "../foobar",
   "../../foobar",
   "./././foobar",
   "|*.what",
   "LPT9.asdf")

 td <- dir_create(file_temp())
 on.exit(dir_delete(td))
 for (str in strings) {
   test_string_fs(str, td)
 }
})
