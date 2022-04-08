test_that("Age is calculated correctly for all units", {
  expect_equal(age_calculate(as.Date("2021-02-01"), as.Date("2022-02-21"),
                             units = "years", date_class = "period",
                             round_down = TRUE), 1)
  expect_equal(age_calculate(as.Date("2021-02-01"), as.Date("2022-02-21"),
                             units = "months", date_class = "period",
                             round_down = TRUE), 12)
  expect_equal(age_calculate(as.Date("2021-02-01"), as.Date("2022-02-21"),
                             units = "weeks", date_class = "period",
                             round_down = TRUE), 55)
  expect_equal(age_calculate(as.Date("2021-02-01"), as.Date("2022-02-21"),
                             units = "days", date_class = "period",
                             round_down = TRUE), 385)
  expect_equal(age_calculate(as.Date("2021-02-01"), as.Date("2022-02-21"),
                             units = "hours", date_class = "period",
                             round_down = TRUE), 9240)
  expect_equal(age_calculate(as.Date("2021-02-01"), as.Date("2022-02-21"),
                             units = "minutes", date_class = "period",
                             round_down = TRUE), 554400)
  expect_equal(age_calculate(as.Date("2021-02-01"), as.Date("2022-02-21"),
                             units = "seconds", date_class = "period",
                             round_down = TRUE), 33264000)
})

test_that("Age is calculated correctly for leap years", {
  expect_equal(age_calculate(as.Date("2020-02-29"), as.Date("2022-02-28"),
                             units = "years", date_class = "period",
                             round_down = TRUE), 1)
  expect_equal(age_calculate(as.Date("2020-02-29"), as.Date("2022-03-01"),
                             units = "years", date_class = "period",
                             round_down = TRUE), 2)
  expect_equal(age_calculate(as.Date("2020-02-20"), as.Date("2020-03-01"),
                             units = "days", date_class = "period",
                             round_down = TRUE), 10)
})

test_that("Non-date formats for start or end date produce an error", {
  expect_error(age_calculate("01022021", as.Date("2022-02-21"),
                             units = "years", date_class = "period",
                             round_down = TRUE))
  expect_error(age_calculate(as.Date("2021-02-01"), "21022022",
                             units = "years", date_class = "period",
                             round_down = TRUE))
  expect_error(age_calculate("2021-02-01", "2022-02-21",
                             units = "years", date_class = "period",
                             round_down = TRUE))
  expect_error(age_calculate("2021-02-01", "21-Feb-2022",
                             units = "years", date_class = "period",
                             round_down = TRUE))
})

test_that("Upper case units can be dealt with", {
  expect_equal(age_calculate(as.Date("2021-02-01"), as.Date("2022-02-21"),
                             units = "YEARS", date_class = "period",
                             round_down = TRUE), 1)
  expect_equal(age_calculate(as.Date("2021-02-01"), as.Date("2022-02-21"),
                             units = "WEEKS", date_class = "period",
                             round_down = TRUE), 55)
})

test_that("date_class has to be either period or duration", {
  expect_error(age_calculate(as.Date("2021-02-01"), as.Date("2022-02-21"),
                             units = "years", date_class = "periods",
                             round_down = TRUE))
  expect_error(age_calculate(as.Date("2021-02-01"), as.Date("2022-02-21"),
                             units = "years", date_class = "durations",
                             round_down = TRUE))
})

test_that("date_class works properly for duration", {
  expect_equal(age_calculate(as.Date("2020-02-29"), as.Date("2022-04-08"),
                             round_down = FALSE, date_class = "duration") * 365.25, 769)
})

test_that("round_down works properly if it is FALSE", {
  expect_equal(age_calculate(as.Date("2021-02-01"), as.Date("2022-02-21"),
                             units = "years", date_class = "period",
                             round_down = FALSE), 1.05475702)
})

test_that("Age is calculated correctly for a dataframe", {
  expect_equal(age_calculate(as.Date(c("1933-01-01",
                                       "1940-01-01",
                                       "1962-01-01")),
                             as.Date(c("1950-01-01",
                                       "2000-01-01",
                                       "2020-01-01"))
                             ), c(17, 60, 58))
})

test_that("Return warning if age is less than 0", {
  expect_warning(age_calculate(as.Date(c("1960-01-01",
                                       "2010-01-01",
                                       "1962-01-01")),
                             as.Date(c("1950-01-01",
                                       "2000-01-01",
                                       "2020-01-01"))
  ), regexp = "There are age less than 0")
})

test_that("Return warning if age is greater than 130", {
  expect_warning(age_calculate(as.Date(c("1889-01-01",
                                         "1940-01-01",
                                         "1962-01-01")),
                               as.Date(c("2020-01-01",
                                         "2000-01-01",
                                         "2020-01-01"))
  ), regexp = "There are age greater than 130")
})