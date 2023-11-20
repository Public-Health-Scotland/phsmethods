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

test_that("YYYY/YY format applied correctly", {
  expect_equal(extract_fin_year(c(lubridate::dmy(NA, "01/April/1999"), NA)),
               c(NA, "1999/00", NA))
  expect_equal(extract_fin_year(c(lubridate::dmy(NA, "01/April/2000"), NA)),
               c(NA, "2000/01", NA))
  expect_equal(extract_fin_year(c(lubridate::dmy(NA, "01/April/2001"), NA)),
               c(NA, "2001/02", NA))
  expect_equal(extract_fin_year(c(lubridate::dmy(NA, "31/March/1999"), NA)),
               c(NA, "1998/99", NA))
  expect_equal(extract_fin_year(c(lubridate::dmy(NA, "31/March/2000"), NA)),
               c(NA, "1999/00", NA))
  expect_equal(extract_fin_year(c(lubridate::dmy(NA, "31/March/2001"), NA)),
               c(NA, "2000/01", NA))
  expect_equal(extract_fin_year(c(lubridate::dmy(NA, "01/December/1999"), NA)),
               c(NA, "1999/00", NA))
  expect_equal(extract_fin_year(c(lubridate::dmy(NA, "01/December/2000"), NA)),
               c(NA, "2000/01", NA))
  expect_equal(extract_fin_year(c(lubridate::dmy(NA, "01/December/2999"), NA)),
               c(NA, "2999/00", NA))
  expect_equal(extract_fin_year(c(lubridate::dmy(NA, "01/December/3000"), NA)),
               c(NA, "3000/01", NA))

  expect_equal(extract_fin_year(
    lubridate::as_datetime(
      c(lubridate::dmy(NA, "01/April/1999"), NA)
    )
  ),
  c(NA, "1999/00", NA))

  expect_equal(extract_fin_year(
    lubridate::as_datetime(
      c(lubridate::dmy(NA, "01/December/2000"), NA)
    )
  ),
  c(NA, "2000/01", NA))

  expect_equal(extract_fin_year(
    lubridate::as_datetime(
      c(lubridate::dmy(NA, "01/April/0001"), NA)
    )
  ),
  c(NA, "0001/02", NA))
})

test_that("Correct outputs", {
  start <- lubridate::dmy("01/04/1999")
  end <- lubridate::dmy("31/03/2011")
  x <- seq(start, end, by = "day")
  fin_years <- extract_fin_year(x)

  df <- data.frame(x = x, fin_years = fin_years)
  out <- dplyr::summarise(df,
                          start = min(x),
                          end = max(x),
                          n = dplyr::n(),
                          .by = fin_years)
  expect_snapshot(out)
})
