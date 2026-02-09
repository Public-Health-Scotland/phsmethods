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

test_that("Returns correct age - no options except fixed reference date", {
  # Some standard CHIs
  expect_equal(
    age_from_chi(
      c(
        "0101336489",
        "0101405073",
        "0101625707"
      ),
      ref_date = as.Date("2023-11-01")
    ),
    c(90, 83, 61)
  )

  # Leap years
  expect_equal(
    age_from_chi(
      c(
        gen_real_chi(290228),
        gen_real_chi(290236),
        gen_real_chi(290296)
      ),
      ref_date = as.Date("2023-03-01")
    ),
    c(95, 87, 27)
  )

  # Century leap year (hard to test as 1900 is a long time ago!)
  expect_equal(
    age_from_chi(gen_real_chi(290200), ref_date = as.Date("2023-03-01")),
    23
  )
})

test_that("Returns correct age - fixed age and reference date supplied", {
  # Some standard CHIs
  # Fixed min age e.g. All patients are younger than X
  expect_equal(
    age_from_chi(
      c(
        "0101336489",
        "0101405073",
        "0101625707"
      ),
      min_age = 1,
      max_age = 101,
      ref_date = as.Date("2023-11-01")
    ),
    c(90, 83, 61)
  )
})

test_that("Returns correct age - unusual fixed age with fixed reference date", {
  # Some standard CHIs
  expect_message(
    expect_equal(
      age_from_chi(
        c(
          "0101336489",
          "0101405073",
          "0101625707"
        ),
        max_age = 72,
        ref_date = as.Date("2023-11-01")
      ),
      c(NA_real_, NA_real_, 61)
    ),
    "2 CHI numbers produced ambiguous dates"
  )
})

test_that("Returns NA when DoB is ambiguous so can't return age", {
  # Default is min_age as 0. max_age is NULL and will be set to the age from 1900-01-01.
  expect_message(
    expect_equal(
      age_from_chi(gen_real_chi(010101)),
      NA_integer_
    ),
    regexp = "1 CHI number produced an ambiguous date"
  )

  expect_message(
    expect_equal(
      age_from_chi(c(
        gen_real_chi(010101),
        gen_real_chi(010110),
        gen_real_chi(010120)
      )),
      c(NA_real_, NA_real_, NA_real_)
    ),
    regexp = "3 CHI numbers produced ambiguous dates"
  )
})

test_that("Can supply different reference dates per CHI", {
  # Some standard CHIs / dates
  # Reference date per CHI, e.g. Date of discharge
  expect_equal(
    age_from_chi(
      c(
        "0101336489",
        "0101405073",
        "0101625707"
      ),
      ref_date = as.Date(c(
        "1950-01-01",
        "2000-01-01",
        "2020-01-01"
      ))
    ),
    c(17, 60, 58)
  )
})

test_that("age_from_chi errors properly", {
  expect_error(
    age_from_chi(1010101129),
    regexp = "`chi_number` must be a <character> vector, not a <numeric> vector\\.$"
  )

  expect_error(
    age_from_chi("0101625707", ref_date = "01-01-2020"),
    regexp = "`ref_date` must be a <Date> or <POSIXct> vector, not a <character> vector\\.$"
  )

  expect_error(
    age_from_chi("0101625707", min_age = -2),
    regexp = "`min_age` must be a positive integer\\.$"
  )

  expect_error(
    age_from_chi("0101625707", min_age = 20, max_age = 10),
    regexp = "`max_age`, must always be greater than or equal to `min_age`\\.$"
  )
})

test_that("age_from_chi gives messages when returning NA", {
  # Invalid CHI numbers
  expect_message(age_from_chi("1234567890"), regexp = "1 CHI number is invalid")

  expect_message(
    age_from_chi(rep("1234567890", 99999)),
    regexp = "99,999 CHI numbers are invalid"
  )
})

test_that("age_from_chi returns correct age when chi_check = FALSE", {
  ref_date <- as.Date("2024-01-01")

  # Test with a valid CHI
  expect_equal(
    age_from_chi(gen_real_chi(010185), ref_date = ref_date, chi_check = FALSE),
    39
  )

  # Test with an invalid CHI (should return NA as the date part is invalid)
  expect_message(
    expect_equal(
      age_from_chi("1234567890", ref_date = ref_date, chi_check = FALSE),
      NA_real_ # age_calculate returns numeric NA
    )
  )

  # Test with a mix of valid and invalid CHIs
  mixed_chis <- c(gen_real_chi(010185), "1234567890", gen_real_chi(150790))
  expect_message(
    expect_equal(
      age_from_chi(mixed_chis, ref_date = ref_date, chi_check = FALSE),
      c(39, NA_real_, 33)
    )
  )

  expect_message(
    expect_equal(
      age_from_chi(
        mixed_chis,
        ref_date = ref_date,
        max_age = 35,
        chi_check = FALSE
      ),
      c(NA_real_, NA_real_, 33)
    )
  )
})

test_that("age_from_chi handles NA values in vectorised ref_date", {
  # CHIs: 01/01/1933, 01/01/1940, 01/01/1962
  chis <- c("0101336489", "0101405073", "0101625707")

  # ref_date vector with NAs
  ref_dates <- as.Date(c("2000-01-01", NA, "2020-01-01")) # NA should default to Sys.Date()

  # Expected ages:
  # 1933-01-01 at 2000-01-01 -> 67
  # 1940-01-01 at Sys.Date() -> depends on today's date (e.g., 85 if Sys.Date() is 2025-05-15)
  # 1962-01-01 at 2020-01-01 -> 58

  # Calculate expected age for the NA case based on Sys.Date()
  expected_age_na <- age_calculate(as.Date("1940-01-01"), Sys.Date())

  expect_equal(
    age_from_chi(chis, ref_date = ref_dates),
    c(67, expected_age_na, 58)
  )

  # Test with all NA ref_dates
  all_na_ref_dates <- as.Date(c(NA, NA, NA))
  expected_ages_all_na <- age_calculate(
    as.Date(c("1933-01-01", "1940-01-01", "1962-01-01")),
    Sys.Date()
  )

  expect_equal(
    age_from_chi(chis, ref_date = all_na_ref_dates),
    expected_ages_all_na
  )
})

test_that("age_from_chi handles NA values in vectorised min_age", {
  # CHIs: 01/01/1933, 01/01/1940, 01/01/1962
  chis <- c("0101336489", "0101405073", "0101625707")
  ref_date <- as.Date("2024-01-01") # Fixed reference date

  # min_age vector with NAs
  min_ages <- c(10, NA, 70) # NA should default to 0

  expect_message(
    expect_equal(
      age_from_chi(
        chis,
        ref_date = ref_date,
        min_age = min_ages,
        max_age = 120
      ),
      c(91, 84, NA_real_)
    )
  )

  # Test with all NA min_ages (should all default to 0)
  all_na_min_ages <- as.integer(c(NA, NA, NA))
  expect_equal(
    age_from_chi(
      chis,
      ref_date = ref_date,
      min_age = all_na_min_ages,
      max_age = 120
    ),
    c(91, 84, 62)
  )
})

test_that("age_from_chi handles NA values in vectorised max_age", {
  # CHIs: 01/01/1933, 01/01/1940, 01/01/1962
  chis <- c("0101336489", "0101405073", "0101625707")
  ref_date <- as.Date("2024-01-01") # Fixed reference date

  # max_age vector with NAs
  max_ages <- c(100, NA, 60) # NA should default to age from 1900-01-01 relative to ref_date

  expect_message(
    expect_equal(
      age_from_chi(chis, ref_date = ref_date, min_age = 0, max_age = max_ages), # Use min_age 0 to isolate max_age effect
      c(91, 84, NA_real_)
    )
  )

  # Test with all NA max_ages (should all default to age from 1900-01-01)
  all_na_max_ages <- as.integer(c(NA, NA, NA))
  expect_equal(
    age_from_chi(
      chis,
      ref_date = ref_date,
      min_age = 0,
      max_age = all_na_max_ages
    ),
    c(91, 84, 62) # All ages are <= 124
  )
})

test_that("age_from_chi handles mixed NA values in vectorised inputs", {
  # CHIs: 01/01/1933, 01/01/1940, 01/01/1962
  chis <- c("0101336489", "0101405073", "0101625707")

  # Mixed NA inputs
  ref_dates <- as.Date(c("2000-01-01", NA, "2020-01-01")) # NA defaults to Sys.Date()
  min_ages <- c(10, 0, NA) # NA defaults to 0
  max_ages <- c(100, NA, 60) # NA defaults to age from 1900-01-01 relative to ref_date

  # Calculate default max_age for the second element (ref_date is Sys.Date())
  default_max_age_2nd <- age_calculate(as.Date("1900-01-01"), Sys.Date())

  expected_age_2nd <- age_calculate(as.Date("1940-01-01"), Sys.Date())

  expect_equal(
    age_from_chi(
      chis,
      ref_date = ref_dates,
      min_age = min_ages,
      max_age = max_ages
    ),
    c(67, expected_age_2nd, 58)
  )
})

test_that("min_age validation works correctly", {
  expect_error(
    age_from_chi(
      "0101336489",
      ref_date = as.Date("2025-01-01"),
      min_age = 0:10
    ),
    regexp = "must be size 1"
  )

  expect_error(
    age_from_chi(
      c(
        "0101336489",
        gen_real_chi(150790),
        gen_real_chi(150190)
      ),
      min_age = c(20, 50)
    ),
    regexp = "must be size 3"
  )
})

test_that("max_age validation works correctly", {
  expect_error(
    age_from_chi(
      "0101336489",
      max_age = 1:10
    ),
    regexp = "must be size 1"
  )

  expect_error(
    age_from_chi(
      c(
        "0101336489",
        gen_real_chi(150790),
        gen_real_chi(150190)
      ),
      max_age = 1:10
    ),
    regexp = "must be size 3"
  )
})

test_that("ref_date validation w correctly", {
  expect_error(
    age_from_chi(
      "0101336489",
      ref_date = seq.Date(
        as.Date("1990-01-01"),
        as.Date("2000-01-01"),
        by = "year"
      )
    ),
    regexp = "must be size 1"
  )

  expect_error(
    age_from_chi(
      c(
        "0101336489",
        gen_real_chi(150790),
        gen_real_chi(150190)
      ),
      ref_date = seq.Date(
        as.Date("1990-01-01"),
        as.Date("2000-01-01"),
        by = "year"
      )
    ),
    regexp = "must be size 3"
  )
})

test_that("Checking types works", {
  expect_error(
    age_from_chi(gen_real_chi(150790), min_age = "12"),
    "`min_age` must be a "
  )

  expect_error(
    age_from_chi(gen_real_chi(150790), max_age = "50"),
    "`max_age` must be a "
  )
})

test_that("Context-aware messaging suggests min_age/max_age when called from age_from_chi", {
  # Test that when age_from_chi calls dob_from_chi, it suggests min_age/max_age
  expect_message(
    age_from_chi(gen_real_chi(010101)),
    regexp = "Try different values for.*min_age.*max_age"
  )

  # Test that the base message is still correct
  expect_message(
    age_from_chi(gen_real_chi(010101)),
    regexp = "1 CHI number produced an ambiguous date"
  )

  # Test with multiple CHI numbers
  expect_message(
    age_from_chi(c(gen_real_chi(010101), gen_real_chi(010110))),
    regexp = "2 CHI numbers produced ambiguous dates"
  )

  expect_message(
    age_from_chi(c(gen_real_chi(010101), gen_real_chi(010110))),
    regexp = "Try different values for.*min_age.*max_age"
  )
})

test_that("NA value handling works correctly", {
  # Test ref_date with NA values - need matching vector lengths
  expected_age_na <- age_calculate(as.Date("1933-01-01"), Sys.Date())
  
  expect_equal(
    age_from_chi(
      c("0101336489", "0101336489"),
      ref_date = c(as.Date("2023-01-01"), as.Date(NA)),
      min_age = 0,
      max_age = 150
    ),
    c(90, expected_age_na) # Should use today's date for NA ref_date
  )

  # Test min_age with NA values
  expect_equal(
    age_from_chi(
      "0101336489",
      ref_date = as.Date("2023-01-01"),
      min_age = NA_integer_, # Should default to 0
      max_age = 150
    ),
    90
  )

  # Test max_age with NA values (should use age from 1900-01-01)
  result_na_max <- age_from_chi(
    "0101336489",
    ref_date = as.Date("2023-01-01"),
    min_age = 0,
    max_age = NA_integer_
  )
  expect_true(is.numeric(result_na_max))
  expect_false(is.na(result_na_max))
})

test_that("Vector length validation works correctly", {
  # Test when ref_date length doesn't match chi_number length
  expect_error(
    age_from_chi(
      c("0101336489", "0101405073"),
      ref_date = c(
        as.Date("2023-01-01"),
        as.Date("2023-01-02"),
        as.Date("2023-01-03")
      )
    ),
    "must be size 2.*not 3"
  )

  # Test when max_age length doesn't match chi_number length
  expect_error(
    age_from_chi(
      c("0101336489", "0101405073"),
      max_age = c(100, 110, 120)
    ),
    "must be size 2.*not 3"
  )

  # Test when min_age length doesn't match chi_number length
  expect_error(
    age_from_chi(
      c("0101336489", "0101405073"),
      min_age = c(0, 5, 10)
    ),
    "must be size 2.*not 3"
  )

  # Test single chi with multiple ref_dates (should error)
  expect_error(
    age_from_chi(
      "0101336489",
      ref_date = c(as.Date("2023-01-01"), as.Date("2023-01-02"))
    ),
    "must be size 1.*not 2"
  )
})

test_that("Edge case: negative min_age", {
  expect_error(
    age_from_chi("0101336489", min_age = -1),
    "must be a positive integer"
  )
})

test_that("Edge case: max_age less than min_age", {
  expect_error(
    age_from_chi("0101336489", min_age = 50, max_age = 30),
    "must always be greater than or equal"
  )
})
