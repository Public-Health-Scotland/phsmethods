context("test-qtr")

test_that("Returns correct quarter in correct format", {
  expect_equal("Jan-Mar 2018",
               qtr_year(date = lubridate::dmy(25032018), format = "short"))
  expect_equal("January to March 2018",
               qtr_year(date = lubridate::dmy(25032018), format = "long"))

  expect_equal("Oct-Dec 2018",
               qtr_year(date = lubridate::dmy(15102018), format = "short"))
  expect_equal("October to December 2018",
               qtr_year(date = lubridate::dmy(15102018), format = "long"))

  expect_equal("Sep 2018",
               qtr_end(date = lubridate::dmy(03072018), format = "short"))
  expect_equal("September 2018",
               qtr_end(date = lubridate::dmy(03072018), format = "long"))

  expect_equal("Dec 2018",
               qtr_end(date = lubridate::dmy(15112018), format = "short"))
  expect_equal("December 2018",
               qtr_end(date = lubridate::dmy(15112018), format = "long"))

  expect_equal("Oct-Dec 2017",
               qtr_prev(date = lubridate::dmy(25032018), format = "short"))
  expect_equal("October to December 2017",
               qtr_prev(date = lubridate::dmy(25032018), format = "long"))

  expect_equal("Jul-Sep 2018",
               qtr_prev(date = lubridate::dmy(15102018), format = "short"))
  expect_equal("July to September 2018",
               qtr_prev(date = lubridate::dmy(15102018), format = "long"))
})

test_that("Errors if the input date is not in date format", {
  expect_error(qtr_year(date = "2018-03-25", format = "short"))
  expect_error(qtr_end(date = as.factor("2018-03-25"), format = "long"))
  expect_error(qtr_prev(date = as.numeric(lubridate::dmy(25032018)),
                        format = "short"))
})
