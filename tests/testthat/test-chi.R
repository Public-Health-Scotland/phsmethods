test_that("valid CHI passes", {
  expect_equal(is.na(chi_check("1904851231")), is.na(NA))
})

test_that("invalid day fails", {
  expect_equal(chi_check("3201209999"), "invalid date")
})

test_that("invalid month fails", {
  expect_equal(chi_check("0113209999"), "invalid date" )
})

test_that("invalid day/month fails", {
  expect_equal(chi_check("3213209999"), "invalid date" )
})

test_that("leap year passes", {
  expect_equal(is.na(chi_check("2902201230")), is.na(NA))
})

test_that("feb 29th fails in non-leap year", {
  expect_equal(chi_check("2902191230"), "invalid date")
})

test_that("punctuation is invalid", {
  expect_equal(chi_check("?123456789"), "invalid character" )
})

test_that("string is invalid", {
  expect_equal(chi_check("a123456789"), "invalid character" )
})

test_that("length check works", {
  expect_equal(chi_check("123"), "too short" )
})

test_that("length check works", {
  expect_equal(chi_check("12345678901"), "too long" )
})

test_that("length check works", {
  expect_error(chi_check(123), "input should be character class - try adding col_types = 'c' to read_csv")
})

test_that("zero day fails", {
  expect_equal(chi_check("0011221234"), "invalid date")
})

test_that("zero month fails", {
  expect_equal(chi_check("1100221234"), "invalid date")
})

test_that("zero day/month fails", {
  expect_equal(chi_check("0000221234"), "invalid date")
})

test_that("all zero fails", {
  expect_equal(chi_check("0000000000"), "invalid date")
})

test_that("invalid CHI fails", {
  expect_equal(chi_check("1904851232"), "invalid checksum")
})
