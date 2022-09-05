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
  expect_error(chi_pad(123), "`x` must be a <character> vector, not a <numeric> vector\\.$")
})

test_that("Vector entry works in chi_pad", {
  expect_equal(
    chi_pad(c("12345678", NA, "123456789")),
    c("12345678", NA, "0123456789")
  )
})

test_that("chi_pad only pads 9 character strings comprised of numeric digits", {
  expect_equal(chi_pad("abcdefghi"), "abcdefghi")
  expect_equal(
    chi_pad(c("246789532", "jklmnopqr", "123223")),
    c("0246789532", "jklmnopqr", "123223")
  )
})
