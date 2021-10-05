test_that("Valid CHI passes chi_check", {
  expect_equal(chi_check("1904851231"), "Valid CHI")
})

test_that("Invalid day fails chi_check", {
  expect_equal(chi_check("3201209999"), "Invalid date")
})

test_that("Invalid month fails chi_check", {
  expect_equal(chi_check("0113209999"), "Invalid date")
})

test_that("Invalid day/month combination fails chi_check", {
  expect_equal(chi_check("3213209999"), "Invalid date")
})

test_that("Leap year passes chi_check", {
  expect_equal(chi_check("2902201230"), "Valid CHI")
})

test_that("Non-leap year 29/02 fails chi_check", {
  expect_equal(chi_check("2902191230"), "Invalid date")
})

test_that("Punctuation fails chi_check", {
  expect_equal(chi_check("?123456789"), "Invalid character(s) present")
})

test_that("Letter fails chi_check", {
  expect_equal(chi_check("a123456789"), "Invalid character(s) present")
})

test_that("Length < 10 fails chi_check", {
  expect_equal(chi_check("123"), "Too few characters")
})

test_that("Length > 10 fails chi_check", {
  expect_equal(chi_check("12345678901"), "Too many characters")
})

test_that("Non-character input fails chi_check", {
  expect_error(chi_check(123), "The input must be of character class")
})

test_that("Zero day fails chi_check", {
  expect_equal(chi_check("0011201234"), "Invalid date")
})

test_that("Zero month fails chi_check", {
  expect_equal(chi_check("1100201234"), "Invalid date")
})

test_that("Zero day/month combination fails chi_check", {
  expect_equal(chi_check("0000201234"), "Invalid date")
})

test_that("All zero fails chi_check", {
  expect_equal(chi_check("0000000000"), "Invalid date")
})

test_that("Invalid checksum fails chi_check", {
  expect_equal(chi_check("1904851232"), "Invalid checksum")
})

test_that("Missing value fails chi_check", {
  expect_equal(chi_check(NA_character_), "Missing")
})

test_that("Vector entry works in chi_check", {
  expect_equal(
    chi_check(c(
      "0101011237",
      "0101201234",
      "3201201234",
      "0113201234",
      "3213201234",
      "123456789",
      "12345678900",
      "010120123?",
      NA,
      "1904851231"
    )),
    c(
      "Valid CHI",
      "Invalid checksum",
      "Invalid date",
      "Invalid date",
      "Invalid date",
      "Too few characters",
      "Too many characters",
      "Invalid character(s) present",
      "Missing",
      "Valid CHI"
    )
  )
})
