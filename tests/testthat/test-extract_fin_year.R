test_that("Date is assigned to the correct financial year", {
  expect_equal(extract_fin_year(as.Date("20120331", "%Y%m%d")), "2011/12")
  expect_equal(extract_fin_year(as.Date("20120401", "%Y%m%d")), "2012/13")
  expect_equal(extract_fin_year(as.POSIXct("20190104", format = "%Y%m%d")), "2018/19")
})

test_that("Date is accepted in various formats", {
  expect_equal(extract_fin_year(as.Date("17111993", "%d%m%Y")), "1993/94")
  expect_equal(extract_fin_year(as.Date("19980404", "%Y%m%d")), "1998/99")
  expect_equal(extract_fin_year(as.Date("21-Jan-2017", "%d-%B-%Y")), "2016/17")
  expect_equal(extract_fin_year(as.POSIXct("20181401", format = "%Y%d%m")), "2017/18")
  expect_equal(extract_fin_year(lubridate::dmy(29102019)), "2019/20")
})

test_that("Non-date formats produce an error", {
  expect_error(extract_fin_year("28102019"))
  expect_error(extract_fin_year("28-Oct-2019"))
  expect_error(extract_fin_year(as.numeric("28102019")))
  expect_error(extract_fin_year(as.factor("28-Oct-2019")))
})

test_that("NAs are handled correctly", {
  expect_equal(extract_fin_year(c(lubridate::dmy(05012020), NA)), c("2019/20", NA))
})
