#' @title Assign a date to a quarter
#'
#' @description
#' The qtr functions take a date input and calculate the relevant
#' quarter-related value from it. They all return the year as part of this
#' value.
#'
#' \itemize{
#' \item `qtr` returns the current quarter
#'
#' \item `qtr_end` returns the last month in the quarter
#'
#' \item `qtr_next` returns the next quarter
#'
#' \item `qtr_prev` returns the previous quarter
#' }
#'
#' @details Quarters are defined as:
#'
#' \itemize{
#' \item January to March (Jan-Mar)
#' \item April to June (Apr-Jun)
#' \item July to September (Jul-Sep)
#' \item October to December (Oct-Dec)
#' }
#'
#' @param date A date which must be supplied with `Date` or `POSIXct`
#' @param format A `character` string specifying the format the quarter
#' should be displayed in. Valid options are `long` (January to March 2018) and
#' `short` (Jan-Mar 2018). The default is `long`.
#'
#' @return A character vector of financial quarters in the specified format.
#'
#' @examples
#' dates <- lubridate::dmy(c(26032012, 04052012, 23092012))
#' qtr(dates)
#' qtr_end(dates, format = "short")
#' qtr_next(dates)
#' qtr_prev(dates, format = "short")
#'
#' @name qtr
#' @export
#' @rdname qtr
NULL

#' @noRd
format_quarter_internal <- function(
  date,
  format,
  type = c("current", "end", "next", "prev")
) {
  quarter_num <- lubridate::quarter(date)
  year <- lubridate::year(date)

  # Adjust quarter number and year based on type
  if (type == "next") {
    # Vectorized calculation for next quarter number and year
    # (quarter_num %% 4L) + 1L handles 1->2, 2->3, 3->4, 4->1
    year_change <- (quarter_num == 4L)
    quarter_num <- (quarter_num %% 4L) + 1L
    year <- year + year_change
  } else if (type == "prev") {
    # Vectorized calculation for previous quarter number and year
    # ((quarter_num + 2L) %% 4L) + 1L handles 1->4, 2->1, 3->2, 4->3
    year_change <- (quarter_num == 1L)
    quarter_num <- ((quarter_num + 2L) %% 4L) + 1L
    year <- year - year_change
  }

  # Select appropriate labels based on type and format
  if (type == "end") {
    labels <- if (format == "long") {
      c("March", "June", "September", "December")
    } else {
      c("Mar", "Jun", "Sep", "Dec")
    }
  } else {
    labels <- if (format == "long") {
      c(
        "January to March",
        "April to June",
        "July to September",
        "October to December"
      )
    } else {
      c("Jan-Mar", "Apr-Jun", "Jul-Sep", "Oct-Dec")
    }
  }

  paste(labels[quarter_num], year)
}

#' @export
#' @rdname qtr
qtr <- function(date, format = c("long", "short")) {
  format <- rlang::arg_match(format)

  if (!inherits(date, c("Date", "POSIXct"))) {
    cli::cli_abort(
      "{.arg date} must be a {.cls Date} or {.cls POSIXct} vector, not a {.cls {class(date)}} vector."
    )
  }

  format_quarter_internal(date, format, type = "current")
}

#' @export
#' @rdname qtr
qtr_end <- function(date, format = c("long", "short")) {
  format <- rlang::arg_match(format)

  if (!inherits(date, c("Date", "POSIXct"))) {
    cli::cli_abort(
      "{.arg date} must be a {.cls Date} or {.cls POSIXct} vector, not a {.cls {class(date)}} vector."
    )
  }

  format_quarter_internal(date, format, type = "end")
}

#' @export
#' @rdname qtr
qtr_next <- function(date, format = c("long", "short")) {
  format <- rlang::arg_match(format)

  if (!inherits(date, c("Date", "POSIXct"))) {
    cli::cli_abort(
      "{.arg date} must be a {.cls Date} or {.cls POSIXct} vector, not a {.cls {class(date)}} vector."
    )
  }

  format_quarter_internal(date, format, type = "next")
}

#' @export
#' @rdname qtr
qtr_prev <- function(date, format = c("long", "short")) {
  format <- rlang::arg_match(format)

  if (!inherits(date, c("Date", "POSIXct"))) {
    cli::cli_abort(
      "{.arg date} must be a {.cls Date} or {.cls POSIXct} vector, not a {.cls {class(date)}} vector."
    )
  }

  format_quarter_internal(date, format, type = "prev")
}
