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
#' @param format The format to return the Financial Year
#'  * (Default) As a character vector in the form '2017/18'
#'  * As an integer e.g. 2017 for '2017/18'.
#'
#' @return A character vector of financial years in the form '2017/18'.
#'
#' @examples
#' x <- lubridate::dmy(c(21012017, 04042017, 17112017))
#' extract_fin_year(x)
#' @export
extract_fin_year <- function(date, format = c("full", "numeric")) {
  if (!inherits(date, c("Date", "POSIXt"))) {
    cli::cli_abort("{.arg date} must be a {.cls Date} or {.cls POSIXt} vector,
                   not a {.cls {class(date)}} vector.")
  }

  format <- rlang::arg_match(format)

  if (inherits(date, "POSIXlt")) {
    posix <- date
  } else {
    posix <- as.POSIXlt(date, tz = lubridate::tz(date))
  }

  year <- posix$year + 1900L
  month <- posix$mon
  fy_num <- year - (month < 3L)

  if (format == "numeric") {
    return(fy_num)
  }

  next_fy <- (fy_num + 1L) %% 100L

  fin_year_chr <- sprintf("%.4d/%02d", fy_num, next_fy)

  fin_year_chr[is.na(date)] <- NA_character_

  return(fin_year_chr)
}
