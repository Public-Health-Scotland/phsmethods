#' @title Assign a date to a financial year
#'
#' @description \code{fin_year} takes a date and assigns it to the correct
#' financial year in the PHS specified format.
#'
#' @details The PHS accepted format for financial year is yyyy/yy e.g. 2017/18.
#'
#' @param date A date which must be supplied with \code{Date} or \code{POSIXct}
#' class. The functions as.Date() or lubridate::dmy() as.POSIXct() are examples
#' of functions that can be used to change a variable to the appropriate class.
#'
#' @examples
#' x <- lubridate::dmy(c(21012017, 04042017, 17112017))
#'
#' fin_year(x)
#'
#' @export
fin_year <- function(date) {

  if (!inherits(date, c("Date", "POSIXct"))) {
    stop("The input must have Date or POSIXct class.")
  }

  unique_dates <- tibble::tibble(dates = unique(date)) %>%

  dplyr::mutate(fin_year = paste0(ifelse(lubridate::month(dates) >= 4,
                                  lubridate::year(dates),
                                  lubridate::year(dates) - 1), "/",
                           substr(ifelse(lubridate::month(dates) >= 4,
                                         lubridate::year(dates) + 1,
                                         lubridate::year(dates)), 3, 4))) %>%
    dplyr::right_join(tibble::tibble(dates = date))

  unique_dates$dates

}
