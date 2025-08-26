# A helper function to generate a 'real' CHI number i.e. one which passes
# `chi_check`, given the first 6 chars i.e. the DoB
gen_real_chi <- function(first_6) {
  for (i in 1111:9999) {
    chi <- chi_pad(as.character(first_6 * 10000 + i))

    if (chi_check(chi) == "Valid CHI") {
      return(chi)
    }
  }
}

test_that("Returns correct DoB - no options", {
  # Some standard CHIs / dates
  expect_equal(
    dob_from_chi(c(
      "0101336489",
      "0101405073",
      "0101625707"
    )),
    as.Date(c(
      "1933-01-01",
      "1940-01-01",
      "1962-01-01"
    ))
  )

  # Leap years
  expect_equal(
    dob_from_chi(c(
      gen_real_chi(290228),
      gen_real_chi(290236),
      gen_real_chi(290296)
    )),
    as.Date(c(
      "1928-02-29",
      "1936-02-29",
      "1996-02-29"
    ))
  )

  # Century leap year (hard to test as 1900 is a long time ago!)
  expect_equal(
    dob_from_chi(gen_real_chi(290200)),
    as.Date("2000-02-29")
  )
})

test_that("Returns correct DoB - fixed dates supplied", {
  # Some standard CHIs / dates
  # Fixed min date e.g. All patients are younger than X
  expect_equal(
    dob_from_chi(
      c(
        "0101336489",
        "0101405073",
        "0101625707"
      ),
      min_date = as.Date("1921-01-01"),
      max_date = as.Date("2021-01-01")
    ),
    as.Date(c(
      "1933-01-01",
      "1940-01-01",
      "1962-01-01"
    ))
  )
})

test_that("Returns correct DoB - unusual fixed dates", {
  # Some standard CHIs / dates
  # Dates which would change the 'usual'
  expect_message(
    expect_equal(
      dob_from_chi(
        c(
          "0101336489",
          "0101405073",
          "0101625707"
        ),
        min_date = as.Date("1950-01-01")
      ),
      as.Date(c(NA, NA, "1962-01-01"))
    ),
    "2 CHI numbers produced ambiguous dates"
  )
})

test_that("Returns NA when DoB is ambiguous", {
  # Default is min 1 Jan 1900, max today.
  # So any dates 1 Jan 2000 to today are 'ambiguous'
  expect_message(
    dob_from_chi(gen_real_chi(010101)),
    regexp = "1 CHI number produced an ambiguous date"
  )

  expect_message(
    dob_from_chi(c(
      gen_real_chi(010101),
      gen_real_chi(010110),
      gen_real_chi(010120)
    )),
    regexp = "3 CHI numbers produced ambiguous dates"
  )

  expect_message(
    expect_equal(
      dob_from_chi(c(
        gen_real_chi(010101),
        gen_real_chi(010110),
        gen_real_chi(010120)
      )),
      as.Date(c(NA, NA, NA))
    ),
    "3 CHI numbers produced ambiguous dates"
  )
})

test_that("Can supply different max dates per CHI", {
  # Some standard CHIs / dates
  # Max date per CHI, e.g. Date of admission
  expect_equal(
    dob_from_chi(
      c(
        "0101336489",
        "0101405073",
        "0101625707"
      ),
      max_date = as.Date(c(
        "2021-01-01",
        "2021-01-02",
        "2021-01-03"
      ))
    ),
    as.Date(c(
      "1933-01-01",
      "1940-01-01",
      "1962-01-01"
    ))
  )
})

test_that("Can fill in date of today where max_date is missing", {
  expect_equal(
    dob_from_chi(
      c(
        "0101336489",
        "0101405073",
        "0101625707"
      ),
      max_date = as.Date(c(NA, NA, "2021-01-03"))
    ),
    as.Date(c(
      "1933-01-01",
      "1940-01-01",
      "1962-01-01"
    ))
  )
})

test_that("Can fill in date of today where max_date is missing and min_date is supplied", {
  expect_equal(
    dob_from_chi(
      c(
        "0101336489",
        "0101405073",
        "0101625707"
      ),
      min_date = as.Date("1900-01-01"),
      max_date = as.Date(c(NA, NA, "2021-01-03"))
    ),
    as.Date(c(
      "1933-01-01",
      "1940-01-01",
      "1962-01-01"
    ))
  )

  expect_equal(
    dob_from_chi(
      c(
        "0101336489",
        "0101405073",
        "0101625707"
      ),
      min_date = as.Date(c("1900-01-01", NA, "1950-01-01")),
      max_date = as.Date(c(NA, NA, "2021-01-03"))
    ),
    as.Date(c(
      "1933-01-01",
      "1940-01-01",
      "1962-01-01"
    ))
  )
})

test_that("any max_date where it is a future date is changed to date of today", {
  expect_warning(
    expect_equal(
      dob_from_chi(
        c(
          "0101336489",
          "0101405073",
          "0101625707"
        ),
        max_date = as.Date(c(
          "2030-01-01",
          "2040-01-02",
          "2050-01-03"
        ))
      ),
      as.Date(c(
        "1933-01-01",
        "1940-01-01",
        "1962-01-01"
      ))
    ),
    "Any `max_date` values which are in the future will be set to today"
  )

  expect_warning(
    dob_from_chi("0101336489", max_date = as.Date("2030-01-01")),
    regexp = "Any `max_date` values which are in the future will be set to today: .*?$"
  )
})

test_that("dob_from_chi errors properly", {
  expect_error(
    dob_from_chi(1010101129),
    regexp = "`chi_number` must be a <character> vector, not a <numeric> vector\\.$"
  )

  expect_error(
    dob_from_chi("0101625707", min_date = "01-01-2020"),
    regexp = "`min_date` has class <character>, but must be any of <Date/POSIXct>.*"
  )

  expect_error(
    dob_from_chi("0101625707", max_date = "01-01-2020"),
    regexp = "max_date` has class <character>, but must be any of <Date/POSIXct>\\.$"
  )

  expect_error(
    dob_from_chi(
      "0101625707",
      min_date = as.Date("2020-01-01"),
      max_date = as.Date("1930-01-01")
    ),
    regexp = "`max_date`, must always be greater than or equal to `min_date`\\.$"
  )

  expect_error(
    dob_from_chi(
      "0101625707",
      min_date = as.Date("2020-01-01"),
      max_date = as.Date("1930-01-01")
    ),
    regexp = "`max_date`, must always be greater than or equal to `min_date`\\.$"
  )
})

test_that("dob_from_chi gives messages when returning NA", {
  # Invalid CHI numbers
  expect_message(dob_from_chi("1234567890"), regexp = "1 CHI number is invalid")

  expect_message(
    dob_from_chi(rep("1234567890", 99999)),
    regexp = "99,999 CHI numbers are invalid"
  )
})

test_that("dob_from_chi returns correct DoB when chi_check = FALSE", {
  # Test with a valid CHI
  expect_equal(
    dob_from_chi(gen_real_chi(010185), chi_check = FALSE),
    as.Date("1985-01-01")
  )

  # Test with an invalid CHI (should still attempt parsing the date part)
  # Note: The behaviour for invalid CHIs with chi_check = FALSE depends on
  # how substr and fast_strptime handle the malformed input.
  # Assuming substr gets the first 6 chars and fast_strptime might return NA.
  # The date part is "123456", which is an invalid date.
  expect_message(
    expect_equal(
      dob_from_chi(invalid_chi <- "1234567890", chi_check = FALSE),
      as.Date(NA) # Expecting NA as "123456" is not a valid date
    )
  )

  # Test with a mix of valid and invalid CHIs
  mixed_chis <- c(gen_real_chi(010185), "1234567890", gen_real_chi(150790))
  expect_message(
    expect_equal(
      dob_from_chi(mixed_chis, chi_check = FALSE),
      as.Date(c("1985-01-01", NA, "1990-07-15"))
    )
  )
})

test_that("min_date validation works correctly", {
  expect_error(
    dob_from_chi(
      "0101336489",
      min_date = as.Date(c("1990-01-01", "1991-01-01")),
      max_date = as.Date("2000-01-01")
    ),
    regexp = "must be size 1"
  )
})

test_that("max_date validation works correctly", {
  expect_error(
    dob_from_chi(
      "0101336489",
      min_date = as.Date("1990-01-01"),
      max_date = as.Date(c("2000-01-01", "2001-01-01"))
    ),
    regexp = "must be size 1"
  )

  expect_error(
    dob_from_chi(
      c(
        "0101336489",
        gen_real_chi(150790),
        gen_real_chi(150190)
      ),
      min_date = as.Date("1990-01-01"),
      max_date = as.Date(c("2000-01-01", "2001-01-01"))
    ),
    regexp = "must be size 1 or 3"
  )
})

test_that("Context-aware messaging suggests correct parameters", {
  # Test that when dob_from_chi is called directly, it suggests min_date/max_date
  expect_message(
    dob_from_chi(gen_real_chi(010101)),
    regexp = "Try different values for.*min_date.*max_date"
  )

  # Test that the base message is still correct
  expect_message(
    dob_from_chi(gen_real_chi(010101)),
    regexp = "1 CHI number produced an ambiguous date"
  )

  # Test with multiple CHI numbers
  expect_message(
    dob_from_chi(c(gen_real_chi(010101), gen_real_chi(010110))),
    regexp = "2 CHI numbers produced ambiguous dates"
  )

  expect_message(
    dob_from_chi(c(gen_real_chi(010101), gen_real_chi(010110))),
    regexp = "Try different values for.*min_date.*max_date"
  )
})

test_that("NA value handling in min_date and max_date", {
  # Test max_date with NA values (should use today's date)
  result_na_max <- dob_from_chi(
    "0101336489",
    min_date = as.Date("1900-01-01"),
    max_date = as.Date(NA)
  )
  expect_false(is.na(result_na_max))

  # Test min_date with NA values (should use 1900-01-01)
  result_na_min <- dob_from_chi(
    "0101336489",
    min_date = as.Date(NA),
    max_date = as.Date("2030-01-01")
  )
  expect_false(is.na(result_na_min))

  # Test both with NA values
  result_both_na <- dob_from_chi(
    "0101336489",
    min_date = as.Date(NA),
    max_date = as.Date(NA)
  )
  expect_false(is.na(result_both_na))
})

test_that("Vector length validation for min_date and max_date", {
  # Test when max_date length doesn't match chi_number length
  expect_error(
    dob_from_chi(
      c("0101336489", "0101405073"),
      max_date = c(as.Date("2023-01-01"), as.Date("2023-01-02"), as.Date("2023-01-03"))
    ),
    "must be size 1 or 2.*not 3"
  )

  # Test when min_date length doesn't match chi_number length
  expect_error(
    dob_from_chi(
      c("0101336489", "0101405073"),
      min_date = c(as.Date("1900-01-01"), as.Date("1900-01-02"), as.Date("1900-01-03"))
    ),
    "must be size 1 or 2.*not 3"
  )

  # Test single chi with multiple dates (should error)
  expect_error(
    dob_from_chi(
      "0101336489",
      max_date = c(as.Date("2023-01-01"), as.Date("2023-01-02"))
    ),
    "must be size 1.*not 2"
  )

  expect_error(
    dob_from_chi(
      "0101336489",
      min_date = c(as.Date("1900-01-01"), as.Date("1900-01-02"))
    ),
    "must be size 1.*not 2"
  )
})

test_that("chi_check parameter works correctly", {
  # Test with chi_check = FALSE (should not validate CHI)
  result_no_check <- dob_from_chi("1234567890", chi_check = FALSE)
  # Invalid CHI but should still try to process it
  expect_true(is.na(result_no_check) || inherits(result_no_check, "Date"))

  # Test with chi_check = TRUE (default) - should validate
  expect_message(
    dob_from_chi("1234567890", chi_check = TRUE),
    "CHI number.*invalid"
  )
})

test_that("Future max_date warning", {
  future_date <- Sys.Date() + 365
  expect_warning(
    dob_from_chi("0101336489", max_date = future_date),
    "Any.*max_date.*values which are in the future will be set to today"
  )
})

test_that("Edge case: date processing with leap years", {
  # Test leap year date that exists in 2000 but not 1900
  leap_chi <- gen_real_chi(290200)  # Feb 29, 2000
  result <- dob_from_chi(leap_chi)
  expect_equal(result, as.Date("2000-02-29"))
})

test_that("Multiple CHI numbers with mixed validity", {
  # Mix of valid and invalid CHI numbers
  mixed_chis <- c("0101336489", "1234567890", "0101405073")
  expect_message(
    result <- dob_from_chi(mixed_chis),
    "1 CHI number.*invalid"
  )
  expect_equal(length(result), 3)
  expect_true(is.na(result[2]))  # Invalid CHI should be NA
  expect_false(is.na(result[1])) # Valid CHI should have date
  expect_false(is.na(result[3])) # Valid CHI should have date
})
