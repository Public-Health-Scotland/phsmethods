context("test-postcode")

test_that("Creates strings of correct length", {
  expect_equal(stringr::str_length(postcode("G26QE")), 7)
  expect_equal(stringr::str_length(postcode("KA89NB")), 7)
  expect_equal(stringr::str_length(postcode("PA152TY")), 7)
})

test_that("Parses multiple input formats", {
  input <- c("G429BA", "g429ba", "G42 9BA", "G 4 2 9 B A", "G429b    a")
  formatted <- suppressWarnings(postcode(input))

  expect_true(length(unique(formatted)) == 1)
  expect_equal(unique(formatted), "G42 9BA")
})
