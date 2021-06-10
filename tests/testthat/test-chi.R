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
  expect_equal(chi_check(c("0101011237",
                           "0101201234",
                           "3201201234",
                           "0113201234",
                           "3213201234",
                           "123456789",
                           "12345678900",
                           "010120123?",
                           NA,
                           "1904851231")),
               c("Valid CHI",
                 "Invalid checksum",
                 "Invalid date",
                 "Invalid date",
                 "Invalid date",
                 "Too few characters",
                 "Too many characters",
                 "Invalid character(s) present",
                 "Missing",
                 "Valid CHI"))
})

test_that("9 character input is padded by chi_pad", {
  expect_equal(chi_pad("123456789"), "0123456789")
  expect_equal(nchar(chi_pad("123456789")), 10)
})

test_that("< 9 character input not padded by chi_pad", {
  expect_equal(chi_pad("12345678"), "12345678")
  expect_equal(nchar(chi_pad("12345678")), 8)
})

test_that("10 character input not padded by chi_pad", {
  expect_equal(chi_pad("1234567890"), "1234567890")
  expect_equal(nchar(chi_pad("1234567890")), 10)
})

test_that("> 10 character input not padded by chi_pad", {
  expect_equal(chi_pad("01234567890"), "01234567890")
  expect_equal(nchar(chi_pad("01234567890")), 11)
})

test_that("Non-character input fails chi_pad", {
  expect_error(chi_pad(123), "The input must be of character class")
})

test_that("Vector entry works in chi_pad", {
  expect_equal(chi_pad(c("12345678", NA, "123456789")),
               c("12345678", NA, "0123456789"))
})

test_that("chi_pad only pads 9 character strings comprised of numeric digits", {
  expect_equal(chi_pad("abcdefghi"), "abcdefghi")
  expect_equal(chi_pad(c("246789532", "jklmnopqr", "123223")),
               c("0246789532", "jklmnopqr", "123223"))
})

test_that("sex_from_chi returns expected simple results", {
  # Default behaviour is to check the chi first
  expect_equal(
    sex_from_chi(c(
      "0101011237",
      "0101336489",
      "0101405073",
      "0101625707",
      "0113201234",
      "123456789",
      "12345678900",
      "010120123?",
      NA
    )),
    c(1, 2, 1, 2, NA, NA, NA, NA, NA)
  )

  # Don't check the CHI
  expect_equal(
    sex_from_chi(c(
      "0101011237",
      "0101336489",
      "0101405073",
      "0101625707",
      "0113201234",
      "123456789",
      "12345678900",
      "010120123?",
      NA
    ), chi_check = FALSE),
    c(1, 2, 1, 2, 1, 1, 1, 1, NA)
  )
})

test_that("sex_from_chi works with custom values", {
  expect_equal(
    sex_from_chi(c(
      "0101011237",
      "0101336489",
      "0113201234",
      NA
    ),
    male_value = "M",
    female_value = "F"
    ),
    c("M", "F", NA, NA)
  )

  expect_error(
    sex_from_chi("0101011237",
      male_value = "M"
    ),
    "^Supplied male and female values must be of the same class.+?$"
  )

  expect_error(
    sex_from_chi("0101011237",
      male_value = 1,
      female_value = 2L
    ),
    "^Supplied male and female values must be of the same class.+?$"
  )
})

test_that("sex_from_chi can return a factor", {
  expect_s3_class(
    sex_from_chi(c(
      "0101011237",
      "0101336489",
      "0113201234",
      NA
    ),
    as_factor = TRUE
    ),
    "factor"
  )

  expect_equal(
    sex_from_chi(c(
      "0101011237",
      "0101336489",
      "0113201234",
      NA
    ),
    as_factor = TRUE
    ),
    factor(c("Male", "Female", NA, NA), levels = c("Male", "Female"))
  )
})
