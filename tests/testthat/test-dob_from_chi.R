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
    dob_from_chi(c(
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
    dob_from_chi(c(
      "0101336489",
      "0101405073",
      "0101625707"
    ),
    min_date = as.Date("1950-01-01")
    ),
    as.Date(c(
      "2033-01-01",
      "2040-01-01",
      "1962-01-01"
    ))
  )
})

test_that("Returns NA when DoB is ambiguous", {

  # Default is min 1 Jan 1900, max today.
  # So any dates 1 Jan 2000 to today are 'ambiguous'
  expect_message(
    dob_from_chi(gen_real_chi(010101)),
    regexp = "^1 CHI number produced an ambiguous date and will be given NA for DoB"
  )

  expect_message(
    dob_from_chi(c(
      gen_real_chi(010101),
      gen_real_chi(010110),
      gen_real_chi(010120)
    )),
    regexp = "^3 CHI numbers produced ambiguous dates and will be given NA for DoB"
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
    dob_from_chi(c(
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

test_that("dob_from_chi errors properly", {
  expect_error(dob_from_chi(1010101129),
    regexp = "typeof\\(chi_number\\) == \"character\" is not TRUE"
  )

  expect_error(dob_from_chi("0101625707",
    min_date = "01-01-2020"
  ),
  regexp = "min_date must have Date or POSIXct class"
  )

  expect_error(dob_from_chi("0101625707",
    max_date = "01-01-2020"
  ),
  regexp = "max_date must have Date or POSIXct class"
  )
})

test_that("dob_from_chi gives messages when returning NA", {

  # Invalid CHI numbers
  expect_message(dob_from_chi("1234567890"),
    regexp = "^1 CHI number was invalid and will be given NA for DoB"
  )

  expect_message(dob_from_chi(rep("1234567890", 99999)),
    regexp = "^99,999 CHI numbers were invalid and will be given NA for DoB"
  )
})
