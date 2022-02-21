#' Calculate age between two dates
#'
#' @description This function calculates the age between two dates using `lubridate` periods.
#' `lubridate` duration is measured in seconds whereas period is human interpretable unit and varies depending on the context.
#' Easily switch between the two with the `date_class` argument. Defaulted as "period".
#'
#' @param start A start date (typically date of birth) which must be supplied with \code{Date} or \code{POSIXct}
#' class. \code{\link[base:as.Date]{as.Date()}},
#' \code{\link[lubridate:ymd]{lubridate::dmy()}} and
#' \code{\link[base:as.POSIXlt]{as.POSIXct()}} are examples of functions which
#' can be used to store dates as an appropriate class.
#' @param end An end date which must be supplied with \code{Date} or \code{POSIXct} class. Defaulted as Sys.time()
#' @param units Type of units to be used. Seconds, minutes, hours, days, weeks, months and years are accepted.
#' @param round_down Should returned ages be rounded down to the nearest whole number. Defaulted as `TRUE`.
#' @param date_class Type of `lubridate` date class. Accepted arguments are "period" and "duration".
#' @examples
#' \dontrun{
#' require(phsmethods)
#' require(lubridate)
#' my_date <- ymd("2020-02-29")
#' end_date <- today()
#' age_calculate(my_date, end_date)
#' age_calculate(my_date, end_date, round_down = FALSE)
#' age_calculate(my_date, end_date, round_down = FALSE, date_class = "period")
#' age_calculate(my_date, end_date, units = "days")
#'
#' # Default date class is period
#' age_calculate(my_date, end_date, round_down = FALSE) * 365.25
#' age_calculate(my_date, end_date, round_down = FALSE, date_class = "duration") * 365.25
#'
#' # Can switch between date classes easily
#' ( dst1 <- ymd_hms("2021-10-31 00:30:00", tz = "GB") )
#' ( dst2 <- dst1 + days(1) )
#' age_calculate(dst1, dst2, unit = "hours", date_class = "duration")
#' age_calculate(dst1, dst2, unit = "hours", date_class = "period")
#'
#' # It's worth noting that `lubridate` periods classify leap year birthdays
#' # slightly differently to UK law where (in the UK) legally speaking
#' # leaplings become a year older on the 1st March on non-leap years.
#' leap1 <- dmy("29-02-2020")
#' leap2 <- dmy("28-02-2022")
#' age_calculate(leap1, leap2, date_class = "duration")
#' age_calculate(leap1, leap2, date_class = "period")
#' }
#' @export
age_calculate <- function(start, end = Sys.time(), units = "years",
                date_class = c("period", "duration"), round_down = TRUE){

  if (!inherits(start, c("Date", "POSIXct"))) {
    stop("The start date must have Date or POSIXct class")
  }

  if (!inherits(end, c("Date", "POSIXct"))) {
    stop("The end date must have Date or POSIXct class")
  }

  units <- match.arg(tolower(units), c("years", "months", "weeks", "days",
                                       "hours", "minutes", "seconds"))

  date_class <- match.arg(date_class)

  age_interval <- lubridate::interval(start, end)

  unit_time <- do.call(get(date_class, asNamespace("lubridate")),
                       list(num = 1, units = units))

  if (date_class == "period" & !units %in% c("week", "weeks")) {
    age_interval <- lubridate::as.period(age_interval, unit = units)
  }

  if (round_down) {
    age_interval %/% unit_time
  } else {
    age_interval / unit_time
  }
}
