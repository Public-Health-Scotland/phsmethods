test_that("Missing arguments produce an error", {
  expect_error(age_calculate(
    end = as.Date("2022-02-21"),
    units = "years",
    round_down = TRUE
  ), regexp = "argument \"start\" is missing")
})

test_that("End defaults to current date when not supplied", {
  expect_equal(
    age_calculate(
      as.Date(Sys.Date() - 365),
      units = "years",
      round_down = TRUE
    ),
    1
  )
})

test_that("Invalid units produce an error", {
  expect_error(age_calculate(
    as.Date("2021-02-01"),
    as.Date("2022-02-21"),
    units = "days",
    round_down = TRUE
  ), regexp = "should be one of \"years\", \"months\"")
})

test_that("NA values in start or end ", {
  expect_equal(age_calculate(
    as.Date(c(NA)),
    as.Date("2022-02-21"),
    units = "years",
    round_down = TRUE
  ), NA_real_)
  expect_equal(age_calculate(
    as.Date("2021-02-01"),
    as.Date(c(NA)),
    units = "years",
    round_down = TRUE
  ), NA_real_)
})

test_that("Vectorized inputs of unequal lengths", {
  expect_equal(age_calculate(
    as.Date(c("2021-02-01", "2020-02-29")),
    as.Date("2022-02-21"),
    units = "years",
    round_down = TRUE
  ), c(1, 1))

  expect_equal(age_calculate(
    as.Date("2021-02-21"),
    as.Date(c("2022-02-01", "2021-02-28")),
    units = "years",
    round_down = TRUE
  ), c(0, 0))
})

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

test_that("Leap year calculation with round_down = FALSE", {
  expect_equal(
    age_calculate(
      as.Date("2020-02-29"),
      as.Date("2021-03-01"),
      units = "years",
      round_down = FALSE
    ),
    1.002732240
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

test_that("Timezone differences are handled correctly", {
  expect_equal(
    age_calculate(
      as.POSIXct("2021-02-01 12:00:00", tz = "UTC"),
      as.POSIXct("2022-02-01 12:00:00", tz = "America/New_York"),
      units = "years",
      round_down = TRUE
    ),
    1
  )
})

test_that("Mixed date classes are handled correctly", {
  expect_equal(
    age_calculate(
      as.Date("2021-02-01"),
      as.POSIXct("2022-02-21 12:00:00"),
      units = "years",
      round_down = TRUE
    ),
    1
  )
})

test_that("Rounding behavior for borderline cases", {
  expect_equal(
    age_calculate(
      as.Date("2021-02-01"),
      as.Date("2022-02-21"),
      units = "years",
      round_down = FALSE
    ),
    1.0546448
  )
  expect_equal(
    age_calculate(
      as.Date("2021-02-01"),
      as.Date("2022-02-01"),
      units = "years",
      round_down = TRUE
    ),
    1
  )
})

test_that("Large date ranges are handled correctly", {
  expect_equal(
    age_calculate(
      as.Date("1000-01-01"),
      as.Date("2000-01-01"),
      units = "years",
      round_down = TRUE
    ),
    1000
  ) |>
    expect_warning("There are ages greater than 130 years\\.$")
})


test_that("Age is calculated correctly when start date is a leap day", {
  expect_equal(
    age_calculate(
      as.Date("2020-02-29"),
      as.Date("2021-02-28"),
      units = "years",
      round_down = TRUE
    ),
    0
  )
  expect_equal(
    age_calculate(
      as.Date("2020-02-29"),
      as.Date("2021-03-01"),
      units = "years",
      round_down = TRUE
    ),
    1
  )
})

test_that("Age is calculated correctly when end date is a leap day", {
  expect_equal(
    age_calculate(
      as.Date("2019-02-28"),
      as.Date("2020-02-29"),
      units = "years",
      round_down = TRUE
    ),
    1
  )
  expect_equal(
    age_calculate(
      as.Date("2018-03-01"),
      as.Date("2020-02-29"),
      units = "years",
      round_down = TRUE
    ),
    1
  )
})

test_that("Age is calculated correctly when both start and end dates are leap days", {
  expect_equal(
    age_calculate(
      as.Date("2020-02-29"),
      as.Date("2024-02-29"),
      units = "years",
      round_down = TRUE
    ),
    4
  )
})

test_that("Age is calculated correctly around leap years when rounding down", {
  expect_equal(
    age_calculate(
      as.Date("2020-02-29"),
      as.Date("2024-02-28"),
      units = "years",
      round_down = TRUE
    ),
    3
  )
})

test_that("Age is calculated correctly for leap day with months as units", {
  expect_equal(
    age_calculate(
      as.Date("2020-02-29"),
      as.Date("2021-02-28"),
      units = "months",
      round_down = TRUE
    ),
    11
  )
  expect_equal(
    age_calculate(
      as.Date("2020-02-29"),
      as.Date("2021-03-01"),
      units = "months",
      round_down = TRUE
    ),
    12
  )
  expect_equal(
    age_calculate(
      as.Date("2020-02-29"),
      as.Date("2024-02-29"),
      units = "months",
      round_down = TRUE
    ),
    48
  )
})

test_that("Age is calculated correctly when leap day is in the middle of the interval", {
  expect_equal(
    age_calculate(
      as.Date("2019-06-01"),
      as.Date("2020-03-01"),
      units = "years",
      round_down = TRUE
    ),
    0
  )
  expect_equal(
    age_calculate(
      as.Date("2019-06-01"),
      as.Date("2020-03-01"),
      units = "months",
      round_down = TRUE
    ),
    9
  )
})
