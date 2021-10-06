test_that("Returns correct DoB - no options", {
  gen_real_chi <- function(first_6) {
    for (i in 1111:9999) {
      chi <- chi_pad(as.character(first_6 * 10000 + i))

      if (chi_check(chi) == "Valid CHI") {
        return(chi)
      }
    }
  }

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

  # Centuary leap year (hard to test as 1900 is a long time ago!)
  expect_equal(dob_from_chi(gen_real_chi(290200)), as.Date("2000-02-29"))
})

test_that("Returns correct DoB - options supplied", {

})

test_that("Returns NA when DoB is ambiguous", {

})

test_that("Supplied ages override supplied dates", {

})

test_that("Can supply different max dates per CHI", {

})
