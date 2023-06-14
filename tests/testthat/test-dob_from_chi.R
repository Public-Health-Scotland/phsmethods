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

# A helper function to work out ages as time passes: Given the age at a given
# date, work out what the age would be today. "2022-04-01" was chosen as the
# default arbitrarily.
expected_age <- function(
    expected_ages,
    expected_at = lubridate::make_date(year = 2022, month = 4, day = 1)
) {
  expected_ages + floor(lubridate::time_length(
    lubridate::interval(expected_at, Sys.Date()),
    "years"
  ))
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
  expect_equal(
    suppressMessages(
      dob_from_chi(
        c(
          "0101336489",
          "0101405073",
          "0101625707"
        ),
        min_date = as.Date("1950-01-01")
      )
    ),
    as.Date(c(NA, NA, "1962-01-01"))
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

  expect_equal(
    suppressMessages(
      dob_from_chi(c(
        gen_real_chi(010101),
        gen_real_chi(010110),
        gen_real_chi(010120)
      ))
    ),
    as.Date(c(NA, NA, NA))
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

test_that("any max_date where it is a future date is changed to date of today", {
  expect_equal(
    suppressWarnings(dob_from_chi(
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
    )),
    as.Date(c(
      "1933-01-01",
      "1940-01-01",
      "1962-01-01"
    ))
  )

  expect_warning(dob_from_chi("0101336489", max_date = as.Date("2030-01-01")),
    regexp = "Any `max_date` values which are in the future will be set to today: .*?$"
  )
})

test_that("dob_from_chi errors properly", {
  expect_error(dob_from_chi(1010101129),
    regexp = "`chi_number` must be a <character> vector, not a <numeric> vector\\.$"
  )

  expect_error(
    dob_from_chi("0101625707",
      min_date = "01-01-2020"
    ),
    regexp = "`min_date` has class <character>, but must be any of <Date/POSIXct>.*"
  )

  expect_error(
    dob_from_chi("0101625707",
      max_date = "01-01-2020"
    ),
    regexp = "max_date` has class <character>, but must be any of <Date/POSIXct>\\.$"
  )

  expect_error(
    dob_from_chi("0101625707",
      min_date = as.Date("2020-01-01"),
      max_date = as.Date("1930-01-01")
    ),
    regexp = "`max_date`, must always be greater than or equal to `min_date`\\.$"
  )

  expect_error(
    dob_from_chi("0101625707",
      min_date = as.Date("2020-01-01"),
      max_date = as.Date("1930-01-01")
    ),
    regexp = "`max_date`, must always be greater than or equal to `min_date`\\.$"
  )
})

test_that("dob_from_chi gives messages when returning NA", {
  # Invalid CHI numbers
  expect_message(dob_from_chi("1234567890"),
    regexp = "1 CHI number is invalid"
  )

  expect_message(dob_from_chi(rep("1234567890", 99999)),
    regexp = "99,999 CHI numbers are invalid"
  )
})

test_that("Returns correct age - no options", {
  # Some standard CHIs
  expect_equal(
    age_from_chi(c(
      "0101336489",
      "0101405073",
      "0101625707"
    )),
    expected_age(c(89, 82, 60))
  )

  # Leap years
  expect_equal(
    age_from_chi(c(
      gen_real_chi(290228),
      gen_real_chi(290236),
      gen_real_chi(290296)
    )),
    expected_age(c(94, 86, 26))
  )

  # Century leap year (hard to test as 1900 is a long time ago!)
  expect_equal(
    age_from_chi(gen_real_chi(290200)),
    expected_age(22)
  )
})

test_that("Returns correct age - fixed age supplied", {
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
      max_age = 101
    ),
    expected_age(c(89, 82, 60))
  )
})

test_that("Returns correct age - unusual fixed age", {
  # Some standard CHIs
  expect_equal(
    suppressMessages(
      age_from_chi(
        c(
          "0101336489",
          "0101405073",
          "0101625707"
        ),
        max_age = 72
      )
    ),
    expected_age(c(NA_real_, NA_real_, 60))
  )
})

test_that("Returns NA when DoB is ambiguous so can't return age", {
  # Default is min_age as 0. max_age is NULL and will be set to the age from 1900-01-01.
  expect_message(
    age_from_chi(gen_real_chi(010101)),
    regexp = "1 CHI number produced an ambiguous date"
  )

  expect_message(
    age_from_chi(c(
      gen_real_chi(010101),
      gen_real_chi(010110),
      gen_real_chi(010120)
    )),
    regexp = "3 CHI numbers produced ambiguous dates"
  )

  expect_equal(
    suppressMessages(
      age_from_chi(c(
        gen_real_chi(010101),
        gen_real_chi(010110),
        gen_real_chi(010120)
      ))
    ),
    c(NA_real_, NA_real_, NA_real_)
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
  expect_error(age_from_chi(1010101129),
    regexp = "`chi_number` must be a <character> vector, not a <numeric> vector\\.$"
  )

  expect_error(
    age_from_chi("0101625707",
      ref_date = "01-01-2020"
    ),
    regexp = "`ref_date` must be a <Date> or <POSIXct> vector, not a <character> vector\\.$"
  )

  expect_error(
    age_from_chi("0101625707",
      min_age = -2
    ),
    regexp = "`min_age` must be a positive integer\\.$"
  )

  expect_error(
    age_from_chi("0101625707",
      min_age = 20, max_age = 10
    ),
    regexp = "`max_age`, must always be greater than or equal to `min_age`\\.$"
  )
})

test_that("age_from_chi gives messages when returning NA", {
  # Invalid CHI numbers
  expect_message(age_from_chi("1234567890"),
    regexp = "1 CHI number is invalid"
  )

  expect_message(age_from_chi(rep("1234567890", 99999)),
    regexp = "99,999 CHI numbers are invalid"
  )
})
