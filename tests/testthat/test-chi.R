#chi_check####
test_that("chi_check - valid CHI passes", {
  expect_equal(is.na(chi_check("1904851231")), is.na(NA))
})

test_that("chi_check - invalid day fails", {
  expect_equal(chi_check("3201209999"), "invalid date")
})

test_that("chi_check - invalid month fails", {
  expect_equal(chi_check("0113209999"), "invalid date")
})

test_that("chi_check - invalid day/month fails", {
  expect_equal(chi_check("3213209999"), "invalid date")
})

test_that("chi_check - leap year passes", {
  expect_equal(is.na(chi_check("2902201230")), is.na(NA))
})

test_that("chi_check - non-leap year 29/02 fails", {
  expect_equal(chi_check("2902191230"), "invalid date")
})

test_that("chi_check - punctuation fails", {
  expect_equal(chi_check("?123456789"), "invalid character")
})

test_that("chi_check - string fails", {
  expect_equal(chi_check("a123456789"), "invalid character")
})

test_that("chi_check - length < 10 fails", {
  expect_equal(chi_check("123"), "too short")
})

test_that("chi_check - length > 10 fails", {
  expect_equal(chi_check("12345678901"), "too long")
})

test_that("chi_check - non-char fails", {
  expect_error(chi_check(123), "input should be character - try adding col_types = 'c' to read_csv")
})

test_that("chi_check - zero day fails", {
  expect_equal(chi_check("0011201234"), "invalid date")
})

test_that("chi_check - zero month fails", {
  expect_equal(chi_check("1100201234"), "invalid date")
})

test_that("chi_check - zero day/month fails", {
  expect_equal(chi_check("0000201234"), "invalid date")
})

test_that("chi_check - all zero fails", {
  expect_equal(chi_check("0000000000"), "invalid date")
})

test_that("chi_check - invalid checksum fails", {
  expect_equal(chi_check("1904851232"), "invalid checksum")
})

test_that("chi_check - works on vector", {

  #data
  x <- c("0101011237", "0101201234", "3201201234", "0113201234",
         "3213201234", "123456789", "12345678900", "010120123?",
         "1904851231")
  #expected
  y <- c(NA_character_, "invalid checksum", "invalid date", "invalid date",
         "invalid date", "too short", "too long", "invalid character",
         NA_character_)
  #test
  expect_equal(chi_check(x), y)
})

#chi_pad####
test_that("chi_pad - pads 9 char input", {
  expect_equal(chi_pad("123456789"), "0123456789")
  expect_equal(nchar(chi_pad("123456789")), 10)
})

test_that("chi_pad - char < 9 not padded", {
  expect_equal(chi_pad("12345678"), "12345678")
  expect_equal(nchar(chi_pad("12345678")), 8)
})

test_that("chi_pad - char = 10 not padded", {
  expect_equal(chi_pad("1234567890"), "1234567890")
  expect_equal(nchar(chi_pad("1234567890")), 10)
})

test_that("chi_pad - char > 10 not padded", {
  expect_equal(chi_pad("01234567890"), "01234567890")
  expect_equal(nchar(chi_pad("01234567890")), 11)
})

test_that("chi_check - non-char fails", {
  expect_error(chi_pad(123),
               "input should be character - try adding col_types = 'c' to read_csv")
})
