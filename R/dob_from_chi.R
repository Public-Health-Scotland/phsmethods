#' @title Extract Date of Birth (DoB) from the CHI number
#'
#' @description \code{dob_from_chi} takes a CHI number or a vector of CHI numbers
#' and returns the DoB as implied by the CHI number(s). If the DoB is ambiguous
#' it will return NA
#'
#' @param chi_number
#' @param min_date
#' @param max_date
#' @param chi_check
#'
#' @return
#' @export
#'
#' @examples
dob_from_chi <- function(chi_number, min_date = NULL, max_date = NULL, chi_check = TRUE) {

  # Do type checking on the params
  stopifnot(typeof(chi_number) == "character")

  if (!is.null(min_date) & !inherits(min_date, c("Date", "POSIXct"))) {
    stop("min_date must have Date or POSIXct class")
  }

  if (!is.null(max_date) & !inherits(max_date, c("Date", "POSIXct"))) {
    stop("max_date must have Date or POSIXct class")
  }

  # min and max date are in a reasonable range
  if (!is.null(min_date) & !is.null(max_date)) stopifnot(min_date <= max_date)

  # Default the max_date to today (person can't be born after today)
  if (is.null(max_date)) max_date <- Sys.Date()

  # Default the min_date to 1 Jan 1900 (person can't be born before then)
  # TODO - Find out what the earliest CHI date was?
  if (is.null(min_date)) min_date <- as.Date("1900-01-01")

  # Default behaviour: Check the CHI number
  # for invalid CHIs we will return NA
  if (chi_check) {
    # Don't use any CHIs which don't pass the validity check
    chi_number <- dplyr::if_else(chi_check(chi_number) == "Valid CHI", chi_number, NA_character_)
  }

  # Parse the digits of the chi number as a date
  # Create dates as all DD/MM/19YY
  date_1900 <- lubridate::fast_strptime(
    substr(chi_number, 1, 6),
    "%d%m%y",
    cutoff_2000 = -1L
  )

  # Create dates as all DD/MM/20YY
  date_2000 <- lubridate::fast_strptime(
    substr(chi_number, 1, 6),
    "%d%m%y",
    cutoff_2000 = 100L
  )

  guess_dob <- as.Date(dplyr::case_when(
    is.na(date_1900) ~ date_2000,
    is.na(date_2000) ~ date_1900,
    date_1900 < min_date ~ date_2000,
    date_2000 > max_date ~ date_1900
  ))

  return(guess_dob)
}

#' @title Extract age from the CHI number
#'
#' @description \code{age_from_chi} takes a CHI number or a vector of CHI numbers
#' and returns the age as implied by the CHI number(s). If the DoB is ambiguous
#' it will return NA. It uses \code{dob_from_chi}.
#'
#' @param chi_number
#' @param ref_date
#' @param min_age
#' @param max_age
#' @param chi_check
#'
#' @return
#' @export
#'
#' @examples
age_from_chi <- function(chi_number, ref_date = NULL, min_age = 0, max_age = NULL, chi_check = TRUE) {

  # Do type checking on the params
  stopifnot(typeof(chi_number) == "character")

  if (!is.null(ref_date) & !inherits(ref_date, c("Date", "POSIXct"))) {
    stop("ref_date must have Date or POSIXct class")
  }

  # min and max ages are in a reasonable range
  stopifnot(min_age >= 0)

  if (!is.null(max_age)) stopifnot(max_age >= min_age)

  if (is.null(ref_date)) ref_date <- Sys.Date()

  max_date.age <- ref_date - lubridate::years(min_age)

  if (is.null(max_age)) {
    min_date.age <- NULL
  } else {
    min_date.age <- ref_date - lubridate::years(max_age)
  }

  dobs <- dob_from_chi(chi_number = chi_number,
                       min_date = min_date.age,
                       max_date = max_date.age,
                       chi_check = chi_check)

  ages <- lubridate::as.period(lubridate::interval(dobs, ref_date))$year

}
