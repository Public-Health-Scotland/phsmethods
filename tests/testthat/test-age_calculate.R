test_that("Age is calculated correctly for all units", {
  expect_equal(
    age_calculate(
      as.Date("2021-02-01"),
      as.Date("2022-02-21"),
      units = "years",
      round_down = TRUE
    ),
    1
  )
  expect_equal(
    age_calculate(
      as.Date("2021-02-01"),
      as.Date("2022-02-21"),
      units = "months",
      round_down = TRUE
    ),
    12
  )
})

test_that("Age is calculated correctly for leap years", {
  expect_equal(
    age_calculate(
      as.Date("2020-02-29"),
      as.Date("2022-02-28"),
      units = "years",
      round_down = TRUE
    ),
    1
  )
  expect_equal(
    age_calculate(
      as.Date("2020-02-29"),
      as.Date("2022-03-01"),
      units = "years",
      round_down = TRUE
    ),
    2
  )
})

test_that("Non-date formats for start or end date produce an error", {
  expect_error(age_calculate(
    "01022021",
    as.Date("2022-02-21"),
    units = "years",
    round_down = TRUE
  ))
  expect_error(age_calculate(
    as.Date("2021-02-01"),
    "21022022",
    units = "years",
    round_down = TRUE
  ))
  expect_error(age_calculate(
    "2021-02-01",
    "2022-02-21",
    units = "years",
    round_down = TRUE
  ))
  expect_error(age_calculate(
    "2021-02-01",
    "21-Feb-2022",
    units = "years",
    round_down = TRUE
  ))
})

test_that("Upper case units can be dealt with", {
  expect_equal(
    age_calculate(
      as.Date("2021-02-01"),
      as.Date("2022-02-21"),
      units = "YEARS",
      round_down = TRUE
    ),
    1
  )
  expect_equal(
    age_calculate(
      as.Date("2021-02-01"),
      as.Date("2022-02-21"),
      units = "MONTHS",
      round_down = TRUE
    ),
    12
  )
})

test_that("round_down works properly if it is FALSE", {
  expect_equal(
    age_calculate(
      as.Date("2021-02-01"),
      as.Date("2022-02-21"),
      units = "years",
      round_down = FALSE
    ),
    1.05464481
  )
})

test_that("Age is calculated correctly for a dataframe", {
  expect_equal(age_calculate(
    as.Date(
      c(
        "1933-01-01",
        "1940-01-01",
        "1962-01-01"
      )
    ),
    as.Date(
      c(
        "1950-01-01",
        "2000-01-01",
        "2020-01-01"
      )
    )
  ), c(17, 60, 58))
})

test_that("Return warning if age is less than 0", {
  expect_warning(age_calculate(
    as.Date(
      c(
        "1960-01-01",
        "2010-01-01",
        "1962-01-01"
      )
    ),
    as.Date(
      c(
        "1950-01-01",
        "2000-01-01",
        "2020-01-01"
      )
    )
  ), regexp = "There are ages less than 0\\.$")
})

test_that("Return warning if age is greater than 130", {
  expect_warning(age_calculate(
    as.Date(
      c(
        "1889-01-01",
        "1940-01-01",
        "1962-01-01"
      )
    ),
    as.Date(
      c(
        "2020-01-01",
        "2000-01-01",
        "2020-01-01"
      )
    )
  ), regexp = "There are ages greater than 130 years\\.$")
  expect_warning(age_calculate(
    as.Date(
      c(
        "1889-01-01",
        "1940-01-01",
        "1962-01-01"
      )
    ),
    as.Date(
      c(
        "2020-01-01",
        "2000-01-01",
        "2020-01-01"
      )
    ),
    units = "months"
  ), regexp = "There are ages greater than 130 years\\.$")
})
