#' @title Extract the formatted financial year from a date
#'
#' @description \code{extract_fin_year} takes a date and assigns it to the
#' correct financial year in the PHS specified format.
#'
#' @details The PHS accepted format for financial year is YYYY/YY e.g. 2017/18.
#'
#' @param date A date which must be supplied with \code{Date} or \code{POSIXct}
#' class. \code{\link[base:as.Date]{as.Date()}},
#' \code{\link[lubridate:ymd]{lubridate::dmy()}} and
#' \code{\link[base:as.POSIXlt]{as.POSIXct()}} are examples of functions which
#' can be used to store dates as an appropriate class.
#'
#' @examples
#' x <- lubridate::dmy(c(21012017, 04042017, 17112017))
#' extract_fin_year(x)
#' @export
extract_fin_year <- function(date) {
  if (!inherits(date, c("Date", "POSIXct"))) {
    cli::cli_abort("{.arg date} must be a {.cls Date} or {.cls POSIXct} vector,
                   not a {.cls {class(date)}} vector.")
  }

  # Simply converting all elements of the input vector resulted in poor
  # performance for large vectors. The function was rewritten to extract
  # a vector of unique elements from the input, convert those to financial year
  # and then match them back on to the original input. This vastly improves
  # performance for large inputs.

  unique_date <- unique(date)

  unique_fy_q <-
    lubridate::year(unique_date) - (lubridate::month(unique_date) %in% 1:3)

  unique_fy <- ifelse(
    is.na(unique_date),
    NA_character_,
    paste0(unique_fy_q, "/", (unique_fy_q %% 100L) + 1L)
  )

  fin_years <- unique_fy[match(date, unique_date)]

  return(fin_years)
}
