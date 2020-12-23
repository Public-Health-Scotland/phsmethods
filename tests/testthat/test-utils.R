test_that("is_date returns TRUE for accepted date types", {
  expect_true(is_date(date = Sys.Date()))
  expect_true(is_date(date = as.POSIXct("31/12/2020")))
  expect_true(is_date(date = as.Date("31/12/2020")))
  expect_true(is_date(date = lubridate::dmy(31122020)))
  expect_true(is_date(date = lubridate::as_date("2020-12-31")))
  expect_true(is_date(date = lubridate::as_datetime("2020-12-31")))
})


test_that("is_date returns FALSE for non-dates", {
  expect_false(is_date(date = "2018-03-25"))
  expect_false(is_date(date = as.factor("2018-03-25")))
  expect_false(is_date(date = NULL))
  expect_false(is_date(date = as.numeric(lubridate::dmy(25032018))))
})
