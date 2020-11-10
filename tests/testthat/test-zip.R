context("test-zip.R")

test_that("zip archives can be created", {
  skip_if_not_installed("utils")
  tmp <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, tmp)
  zip <- zip_create(tmp)
  expect_true(file_exists(zip))
  expect_lt(file_size(zip), file_size(tmp))
  unlink(c(tmp, zip))
})

test_that("zip contents can be listed", {
  skip_if_not_installed("utils")
  tmp <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, tmp)
  zip <- zip_create(tmp)
  out <- zip_ls(zip)
  expect_equal(nrow(out), length(tmp))
  expect_length(out, 3)
  expect_s3_class(out, "data.frame")
  unlink(c(tmp, zip, out))
})

test_that("multiple zips can be listed", {
  skip_if_not_installed("utils")
  tmp1 <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, tmp1)
  zip1 <- zip_create(tmp1, file_temp(ext = "zip"))

  tmp2 <- file_temp("iris", ext = "csv")
  write.csv(iris, tmp2)
  zip2 <- zip_create(tmp2, file_temp(ext = "zip"))

  out <- zip_ls(c(zip1, zip2))
  expect_equal(nrow(out), 2)
  expect_length(out, 4)
  expect_s3_class(out, "data.frame")
  unlink(c(tmp1, tmp2, zip1, zip2, out))
})

test_that("zips can be extracted", {
  skip_if_not_installed("utils")
  tmp <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, tmp)
  zip <- zip_create(tmp)
  out <- zip_move(zip, tempdir())
  expect_equal(length(out), length(tmp))
  expect_s3_class(out, "fs_path")
  unlink(c(tmp, zip, out))
})

test_that("zip extract fails without dir", {
  skip_if_not_installed("utils")
  tmp <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, tmp)
  zip <- zip_create(tmp)
  expect_error(zip_move(zip))
  unlink(c(tmp, zip))
})
