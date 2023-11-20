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
  end <- lubridate::dmy("31/03/2024")
  x <- seq(start, end, by = "day")
  year_breaks <- start + lubridate::years(0:25)
  fin_years <- extract_fin_year(x)

  df <- dplyr::tibble(x = x, fin_years = fin_years)
  out <- dplyr::summarise(df,
                          start = min(x),
                          end = max(x),
                          n = dplyr::n(),
                          .by = fin_years)

  # We'll compare the above output by first creating an expected result
  # This will be a tibble of start and end dates for each financial year
  # We then use that find the number of days that lie between
  # each pair

  start_end_df <- dplyr::tibble(start = seq(start, end, by = "year"))
  start_end_df$end <- start_end_df$start + lubridate::years(1) - lubridate::days(1)

  start_end_df <- start_end_df %>%
    dplyr::group_by(start, end) %>%
    dplyr::mutate(n = sum(dplyr::between(x, start, end)))

  expected_years <- lubridate::year(start_end_df$start)
  expected_years2 <- lubridate::year(start_end_df$end) %% 100
  expected_years2_padded <- stringr::str_pad(expected_years2, width = 2,
                                             side = "left", pad = "0")
  expected_fin_years <- paste0(expected_years, "/", expected_years2_padded)

  expect_equal(out$fin_years, expected_fin_years)
  expect_equal(out$start, start_end_df$start)
  expect_equal(out$end, start_end_df$end)
  expect_equal(out$n, start_end_df$n)
})
