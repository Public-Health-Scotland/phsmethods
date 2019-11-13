context("test-fin_year")

test_that("Date is assigned to the correct financial year", {
  expect_equal(fin_year(as.Date("20120331", "%Y%m%d")), "2011/12")
  expect_equal(fin_year(as.Date("20120401", "%Y%m%d")), "2012/13")
})

test_that("Date is accepted in various formats", {
  expect_equal(fin_year(as.Date("17111993", "%d%m%Y")), "1993/94")
  expect_equal(fin_year(as.Date("19980404", "%Y%m%d")), "1998/99")
  expect_equal(fin_year(as.Date("21-Jan-2017", "%d-%B-%Y")), "2016/17")
  expect_equal(fin_year(lubridate::dmy("29102019")), "2019/20")
})

test_that("Non-date formats produce an error", {
  expect_error(fin_year("28102019"))
  expect_error(fin_year("28-Oct-2019"))
  expect_error(fin_year(as.numeric("28102019")))
  expect_error(fin_year(as.factor("28-Oct-2019")))
})

