test_that("Creates strings of correct length", {
  expect_equal(nchar(format_postcode("G26QE", format = "pc7")), 7)
  expect_equal(nchar(format_postcode("G26QE", format = "pc8")), 6)
  expect_equal(
    nchar(format_postcode(c("KA89NB", "PA152TY"), format = "pc7")),
    c(7, 7)
  )
  expect_equal(
    nchar(format_postcode(c("KA89NB", "PA152TY"), format = "pc8")),
    c(7, 8)
  )
})

test_that("Handles all valid outcode formats", {
  expect_equal(format_postcode("G36RB"), "G3  6RB")
  expect_equal(format_postcode("G432XR"), "G43 2XR")
  expect_equal(format_postcode("DG29BA"), "DG2 9BA")
  expect_equal(format_postcode("FK101RY"), "FK101RY")
  expect_equal(format_postcode("E1W3TJ"), "E1W 3TJ")
  expect_equal(format_postcode("EC1Y8SE"), "EC1Y8SE")
})

test_that("Parses multiple input formats", {
  input_hampden <- c("G429BA", "g429ba", "G42 9BA", "G 4 2 9 B A", "G429b    a")
  formatted_hampden <- suppressWarnings(format_postcode(input_hampden))

  expect_length(unique(formatted_hampden), 1)
  expect_equal(unique(formatted_hampden), "G42 9BA")
})

test_that("Correctly handles values which don't adhere to standard format", {
  expect_true(is.na(suppressWarnings(format_postcode("G2?QE"))))
  expect_warning(format_postcode(c("G207AL", "G2O07AL")))
  expect_equal(
    suppressWarnings(format_postcode(
      c("EH7 5QG", NA, "EH11 2NL", "EH5 2HF*")
    )),
    c("EH7 5QG", NA, "EH112NL", NA)
  )
})

test_that("Output is the same with the quiet param set to TRUE", {
  # Creates strings of correct length
  expect_equal(
    nchar(format_postcode("G26QE", format = "pc7", quiet = TRUE)),
    7
  )
  expect_equal(
    nchar(format_postcode("G26QE", format = "pc8", quiet = TRUE)),
    6
  )
  expect_equal(
    nchar(format_postcode(
      c("KA89NB", "PA152TY"),
      format = "pc7",
      quiet = TRUE
    )),
    c(7, 7)
  )
  expect_equal(
    nchar(format_postcode(
      c("KA89NB", "PA152TY"),
      format = "pc8",
      quiet = TRUE
    )),
    c(7, 8)
  )

  # Handles all valid outcode formats
  expect_equal(format_postcode("G36RB", quiet = TRUE), "G3  6RB")
  expect_equal(format_postcode("G432XR", quiet = TRUE), "G43 2XR")
  expect_equal(format_postcode("DG29BA", quiet = TRUE), "DG2 9BA")
  expect_equal(format_postcode("FK101RY", quiet = TRUE), "FK101RY")
  expect_equal(format_postcode("E1W3TJ", quiet = TRUE), "E1W 3TJ")
  expect_equal(format_postcode("EC1Y8SE", quiet = TRUE), "EC1Y8SE")

  # Parses multiple input formats
  input_hampden <- c("G429BA", "g429ba", "G42 9BA", "G 4 2 9 B A", "G429b    a")
  formatted_hampden <- format_postcode(input_hampden, quiet = TRUE)

  expect_length(unique(formatted_hampden), 1)
  expect_equal(unique(formatted_hampden), "G42 9BA")

  # Correctly handles values which don't adhere to standard format
  expect_true(is.na(format_postcode("G2?QE", quiet = TRUE)))
  expect_no_warning(format_postcode(c("G207AL", "G2O07AL"), quiet = TRUE))
  expect_equal(
    format_postcode(c("EH7 5QG", NA, "EH11 2NL", "EH5 2HF*"), quiet = TRUE),
    c("EH7 5QG", NA, "EH112NL", NA)
  )
})

test_that("Produces correct number of warning messages", {
  dens_postcodes <- c("Dd37Jy", "DD37JY", "D  d 337JY")
  format_postcode(dens_postcodes) %>%
    expect_warning()

  pittodrie_postcodes <- c("ab245qh", NA, "ab245q", "A  B245QH")
  format_postcode(pittodrie_postcodes) %>%
    expect_warning() %>%
    expect_warning()
})

test_that("Warning gives true number of values that don't adhere to format", {
  expect_snapshot(format_postcode("g2"))
  expect_snapshot(format_postcode(c("DG98BS", "dg98b")))
  expect_snapshot(
    format_postcode(c("ML53RB", NA, "ML5", "???", 53, as.factor("ML53RB")))
  )

  expect_snapshot({
    format_postcode(c("KY1 1RZ", "ky1rz", "KY11 R", "KY11R!"), quiet = TRUE)
    format_postcode(c("KY1 1RZ", "ky1rz", "KY11 R", "KY11R!"), quiet = FALSE)
  })
})

test_that("The quiet parameter suppresses messages correctly", {
  expect_equal(
    format_postcode(c("KY1 1RZ", "ky1rz", "KY11 R", "KY11R!"), quiet = TRUE),
    c("KY1 1RZ", NA, NA, NA)
  )
  expect_equal(
    format_postcode(c("KY1 1RZ", "ky1 1rz"), quiet = TRUE),
    c("KY1 1RZ", "KY1 1RZ")
  )
  expect_equal(
    format_postcode(c("KY1 1RZ", "ky1rz", "KY11 R", "KY11R!"), quiet = TRUE),
    suppressWarnings(format_postcode(c("KY1 1RZ", "ky1rz", "KY11 R", "KY11R!")))
  )
  expect_equal(
    format_postcode(c("KY1 1RZ", "ky1 1rz"), quiet = TRUE),
    suppressWarnings(format_postcode(c("KY1 1RZ", "ky1 1rz")))
  )
})

test_that("Errors on invalid inputs", {
  expect_error(format_postcode(NA))
  expect_error(format_postcode(123))
  expect_error(format_postcode(123))

  expect_error(format_postcode("G26QE", format = 7))
  expect_error(format_postcode("G26QE", format = "7"))

  expect_error(format_postcode("G26QE", quiet = 1))
  expect_error(format_postcode("G26QE", quiet = "TRUE"))

  expect_error(format_postcode("G26QE", "G26QE"))
  expect_error(format_postcode("G26QE", "G26QE", "G26QE"))

  expect_error(format_postcode(NA, NA))
  expect_error(format_postcode(NA, NA, NA))
})
