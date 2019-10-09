context("test-postcode")

test_that("Creates strings of correct length", {
  expect_equal(stringr::str_length(postcode("G26QE", format = "pc7")), 7)
  expect_equal(stringr::str_length(postcode("G26QE", format = "pc8")), 6)
  expect_equal(stringr::str_length(postcode("KA89NB", format = "pc7")), 7)
  expect_equal(stringr::str_length(postcode("KA89NB", format = "pc8")), 7)
  expect_equal(stringr::str_length(postcode("PA152TY", format = "pc7")), 7)
  expect_equal(stringr::str_length(postcode("PA152TY", format = "pc8")), 8)
})

test_that("Parses multiple input formats", {
  input_one <- c("G429BA", "g429ba", "G42 9BA", "G 4 2 9 B A", "G429b    a")
  formatted_one <- suppressWarnings(postcode(input))

  expect_true(length(unique(formatted_one)) == 1)
  expect_equal(unique(formatted_one), "G42 9BA")
})

test_that("Errors if supplied with any incorrect input", {
  expect_error(postcode("G2?QE"))
  expect_error(postcode(c("EH7 5QG", "EH11 2NL", "EH5 2HF*")))
  expect_error(postcode(2))
  expect_error(postcode(NA))
})

test_that("Produces correct number of warning messages", {
  input_two <- c("ab245qh", NA, "ab245q", "A  B245QH")
  warnings_two <- capture_warnings(postcode(input_two))

  expect_length(warnings_two, 2)

})

test_that("Formats valid postcodes from vector containing invalid entries", {
  mixed <- c("G207AL", "g2o7al", 6, "g 6 89ne", NA, "G43  2XR")
  formatted_mixed <- suppressWarnings(postcode(mixed))

  expect_equal(formatted_mixed,
               c("G20 7AL", "g2o7al", "6", "G68 9NE", NA, "G43 2XR"))

})
