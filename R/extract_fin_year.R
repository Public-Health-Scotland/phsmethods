#' @title Assign a date to a financial year
#'
#' @description \code{extract_fin_year} takes a date and assigns it to the correct
#' financial year in the PHS specified format.
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
    cli::cli_abort("{.arg date} must be a {.cls Date} or {.cls POSIXct} vector, not a {.cls {class(date)}} vector.")
  }

  # Simply converting all elements of the input vector resulted in poor
  # performance for large vectors. The function was rewritten to extract
  # a vector of unique elements from the input, convert those to financial year
  # and then match them back on to the original input. This vastly improves
  # performance for large inputs.

  x <- tibble::tibble(dates = unique(date)) %>%
    dplyr::mutate(
      fyear = paste0(
        ifelse(lubridate::month(.data$dates) >= 4,
          lubridate::year(.data$dates),
          lubridate::year(.data$dates) - 1
        ),
        "/",
        substr(
          ifelse(lubridate::month(.data$dates) >= 4,
            lubridate::year(.data$dates) + 1,
            lubridate::year(.data$dates)
          ),
          3, 4
        )
      ),
      fyear = ifelse(is.na(.data$dates),
        NA_character_,
        .data$fyear
      )
    )

  tibble::tibble(dates = date) %>%
    dplyr::left_join(x, by = "dates") %>%
    dplyr::pull(.data$fyear)
}
