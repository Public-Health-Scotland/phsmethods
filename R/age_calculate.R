#' Calculate age between two dates
#'
#' @description This function calculates the age between two dates using `lubridate`.
#' It calculates age in either years or months.
#'
#' @param start A start date (e.g. date of birth) which must be supplied with \code{Date} or \code{POSIXct} or \code{POSIXlt}
#' class. \code{\link[base:as.Date]{as.Date()}},
#' \code{\link[lubridate:ymd]{lubridate::dmy()}} and
#' \code{\link[base:as.POSIXlt]{as.POSIXct()}} are examples of functions which
#' can be used to store dates as an appropriate class.
#' @param end An end date which must be supplied with \code{Date} or \code{POSIXct} or \code{POSIXlt} class.
#' Default is `Sys.Date()` or `Sys.time()` depending on the class of `start`.
#' @param units Type of units to be used. years and months are accepted. Default is \code{years}.
#' @param round_down Should returned ages be rounded down to the nearest whole number. Default is \code{TRUE}.
#' @examples
#' \dontrun{
#' library(phsmethods)
#' library(lubridate)
#' my_date <- ymd("2020-02-29")
#' end_date <- today()
#' age_calculate(my_date, end_date)
#' age_calculate(my_date, end_date, round_down = FALSE)
#' age_calculate(my_date, end_date, units = "months")
#'
#' # It's worth noting that `lubridate` periods classify leap year birthdays
#' # slightly differently to UK law where (in the UK) legally speaking
#' # leaplings become a year older on the 1st March on non-leap years.
#' leap1 <- dmy("29-02-2020")
#' leap2 <- dmy("28-02-2022")
#' leap3 <- dmy("01-03-2022")
#' age_calculate(leap1, leap2)
#' age_calculate(leap1, leap3)
#' }
#' @export
age_calculate <- function(start, end = if (lubridate::is.Date(start)) Sys.Date() else Sys.time(),
                          units = c("years", "months"), round_down = TRUE) {
  if (!inherits(start, c("Date", "POSIXt"))) {
    stop("The start date must have Date or POSIXct or POSIXlt class")
  }

  if (!inherits(end, c("Date", "POSIXt"))) {
    stop("The end date must have Date or POSIXct or POSIXlt class")
  }

  units <- match.arg(tolower(units), c("years", "months"))

  age_interval <- lubridate::interval(start, end)

  unit_time <- do.call(
    get("period", asNamespace("lubridate")),
    list(num = 1, units = units)
  )

  age_interval <- lubridate::as.period(age_interval, unit = units)

  age <- age_interval / unit_time

  if (any(age < 0, na.rm = TRUE)) warning("There are ages less than 0")
  if (units == "years" & any(age > 130, na.rm = TRUE)) warning("There are ages greater than 130 years")
  if (units == "months" & any(age / 12 > 130, na.rm = TRUE)) warning("There are ages greater than 130 years")
  if (round_down) age <- trunc(age)
  return(age)
}
