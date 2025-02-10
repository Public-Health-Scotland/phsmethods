#' @title Extract the formatted financial year from a date
#'
#' @description `extract_fin_year` takes a date and extracts the
#' correct financial year in the PHS specified format from it.
#'
#' @details The PHS accepted format for financial year is YYYY/YY e.g. 2017/18.
#'
#' @param date A date which must be supplied with `Date`, `POSIXct`, `POSIXlt` or
#' `POSIXt` class. [base::as.Date()],
#' [`lubridate::dmy()`][lubridate::ymd] and
#' [`as.POSIXct()`][base::as.POSIXlt] are examples of functions which
#' can be used to store dates as an appropriate class.
#'
#' @return A character vector of financial years in the form '2017/18'.
#'
#' @examples
#' x <- lubridate::dmy(c(21012017, 04042017, 17112017))
#' extract_fin_year(x)
#' @export
extract_fin_year <- function(date) {
  if (!inherits(date, c("Date", "POSIXt"))) {
    cli::cli_abort("{.arg date} must be a {.cls Date} or {.cls POSIXt} vector,
                   not a {.cls {class(date)}} vector.")
  }

  # Note: lubridate year and month coerce to double
  # We only need integers for our purposes
  posix <- as.POSIXlt(date, tz = lubridate::tz(date))
  y <- posix$year + 1900L
  m <- posix$mon
  fy <- y - (m < 3L)
  next_fy <- (fy + 1L) %% 100L
  out <- sprintf("%.4d/%02d", fy, next_fy)
  out[is.na(date)] <- NA_character_
  out
}
