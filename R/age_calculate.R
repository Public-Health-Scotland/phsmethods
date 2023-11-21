#' Calculate age between two dates
#'
#' @description This function calculates the age between two dates using
#' functions in `lubridate`. It calculates age in either years or months.
#'
#' @param start A start date (e.g. date of birth) which must be supplied with
#' `Date` or `POSIXct` or `POSIXlt`
#' class. [base::as.Date()],
#' [`lubridate::dmy()`][lubridate::ymd] and
#' [`as.POSIXct()`][base::as.POSIXlt] are examples of functions which
#' can be used to store dates as an appropriate class.
#' @param end An end date which must be supplied with `Date` or `POSIXct` or
#' `POSIXlt` class. Default is `Sys.Date()` or `Sys.time()` depending on the
#' class of `start`.
#' @param units Type of units to be used. years and months are accepted.
#' Default is `years`.
#' @param round_down Should returned ages be rounded down to the nearest whole
#' number. Default is `TRUE`.
#'
#' @return A numeric vector representing the ages in the given units.
#'
#' @examples
#' library(lubridate)
#' birth_date <- lubridate::ymd("2020-02-29")
#' end_date <- lubridate::ymd("2022-02-21")
#' age_calculate(birth_date, end_date)
#' age_calculate(birth_date, end_date, units = "months")
#'
#' # If the start day is leap day (February 29th), age increases on 1st March
#' # every year.
#' leap1 <- lubridate::ymd("2020-02-29")
#' leap2 <- lubridate::ymd("2022-02-28")
#' leap3 <- lubridate::ymd("2022-03-01")
#'
#' age_calculate(leap1, leap2)
#' age_calculate(leap1, leap3)
#' @export
age_calculate <- function(
    start,
    end = if (lubridate::is.Date(start)) Sys.Date() else Sys.time(),
    units = c("years", "months"),
    round_down = TRUE) {
  make_inheritance_checks(
    list(start = start, end = end),
    target_classes = c("Date", "POSIXt"),
    ignore_null = FALSE
  )

  units <- match.arg(tolower(units), c("years", "months"))

  age_interval <- lubridate::interval(start, end)

  unit_time <- do.call(
    get("period", asNamespace("lubridate")),
    list(num = 1, units = units)
  )

  age_interval <- lubridate::as.period(age_interval, unit = units)

  age <- age_interval / unit_time

  if (any(age < 0, na.rm = TRUE)) {
    cli::cli_warn(c("!" = "There are ages less than 0."))
  }

  if (units == "years") {
    if (any(age > 130, na.rm = TRUE)) {
      cli::cli_warn(c("!" = "There are ages greater than 130 years."))
    }
  } else if (units == "months") {
    if (any(age / 12 > 130, na.rm = TRUE)) {
      cli::cli_warn(c("!" = "There are ages greater than 130 years."))
    }
  }

  if (round_down) {
    age <- trunc(age)
  }

  return(age)
}
