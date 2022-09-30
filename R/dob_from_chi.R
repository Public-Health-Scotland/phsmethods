#' @title Extract Date of Birth (DoB) from the CHI number
#'
#' @description \code{dob_from_chi} takes a CHI number or a vector of CHI numbers
#' and returns the DoB as implied by the CHI number(s). If the DoB is ambiguous
#' it will return NA
#'
#' @param chi_number a CHI number or a vector of CHI numbers with \code{character} class.
#' @param min_date,max_date optional min and/or max dates that the Date of Birth could take as the century needs to be guessed.
#' Must be either length 1 for a 'fixed' date or the same length as \code{chi_number} for a date per CHI number.
#' min_date can be date based on common sense in the dataset, whilst max_date can be date when an event happens such as discharge date.
#' @param chi_check logical, optionally skip checking the CHI for validity which will be
#' faster but should only be used if you have previously checked the CHI(s). The default (TRUE) will check the CHI numbers.
#'
#' @return a date vector of DoB. It will be the same length as \code{chi_number}.
#' @export
#'
#' @examples
#' dob_from_chi("0101336489")
#'
#' library(tibble)
#' library(dplyr)
#' data <- tibble(chi = c(
#'   "0101336489",
#'   "0101405073",
#'   "0101625707"
#' ), adm_date = as.Date(c(
#'   "1950-01-01",
#'   "2000-01-01",
#'   "2020-01-01"
#' )))
#'
#' data %>%
#'   mutate(chi_dob = dob_from_chi(chi))
#'
#' data %>%
#'   mutate(chi_dob = dob_from_chi(chi,
#'     min_date = as.Date("1930-01-01"),
#'     max_date = adm_date
#'   ))
dob_from_chi <- function(chi_number, min_date = NULL, max_date = NULL, chi_check = TRUE) {

  # Do type checking on the params
  if (!inherits(chi_number, "character")) {
    cli::cli_abort("{.arg chi_number} must be a {.cls character} vector, not a {.cls {class(chi_number)}} vector.")
  }

  make_inheritance_checks(list(min_date=min_date, max_date=max_date), target_classes = c("Date", "POSIXct"))

  # min and max date are in a reasonable range
  if (!is.null(min_date) & !is.null(max_date)) {
    if (any(max_date < min_date)) {
      cli::cli_abort("{.arg max_date}, must always be greater than or equal to {.arg min_date}.")
    }
  }

  # Default the max_date to today (person can't be born after today)
  if (is.null(max_date)) max_date <- Sys.Date()

  # Fill in today's date to where max_date is missing
  if (any(is.na(max_date))) max_date[is.na(max_date)] <- Sys.Date()

  # max_date should not be a future date
  if (any(max_date > Sys.Date())) {
    to_replace <- max_date > Sys.Date()
    max_date[to_replace] <- Sys.Date()
    cli::cli_warn(c("!" = "Any {.arg max_date} values which are in the future will be set to today: {.val {Sys.Date()}}."))
  }

  # Default the min_date to 1 Jan 1900
  if (is.null(min_date)) min_date <- as.Date("1900-01-01")

  # Default behaviour: Check the CHI number
  # for invalid CHIs we will return NA
  if (chi_check) {
    # Don't use any CHIs which don't pass the validity check
    na_count <- sum(is.na(chi_number))
    chi_number <- dplyr::if_else(chi_check(chi_number) == "Valid CHI", chi_number, NA_character_)
    new_na_count <- sum(is.na(chi_number)) - na_count

    if (new_na_count > 0) {
      cli::cli_alert_warning(("{format(new_na_count, big.mark = ',')}{cli::qty(new_na_count)} CHI number{?s} {?is/are} invalid and will be given {.val NA} for {?its/their} Date{?s} of Birth."))
    }
  }

  # Parse the digits of the chi number as a date
  date_from_chi <- substr(chi_number, 1, 6)

  # Create dates as all DD/MM/19YY
  date_1900 <- lubridate::fast_strptime(
    date_from_chi,
    "%d%m%y",
    cutoff_2000 = -1L
  )

  # Create dates as all DD/MM/20YY
  date_2000 <- lubridate::fast_strptime(
    date_from_chi,
    "%d%m%y",
    cutoff_2000 = 100L
  )

  na_count <- sum(is.na(chi_number))

  guess_dob <- as.Date(dplyr::case_when(
    # Date is NA - missing, invalid or an invalid leap year date in 19XX.
    is.na(date_1900) ~ date_2000,
    # Invalid leap year date in 20XX.
    is.na(date_2000) ~ date_1900,
    # When 20XX date is in the valid range and the 19XX date isn't, 20XX is guessed.
    (date_2000 >= min_date & date_2000 <= max_date) &
      !(date_1900 >= min_date & date_1900 <= max_date) ~ date_2000,
    # When 19XX date is in the valid range and the 20XX date isn't, 19XX is guessed.
    (date_1900 >= min_date & date_1900 <= max_date) &
      !(date_2000 >= min_date & date_2000 <= max_date) ~ date_1900
  ))

  new_na_count <- sum(is.na(guess_dob)) - na_count

  if (new_na_count > 0) {
    cli::cli_inform(c(
      "!" = "{format(new_na_count, big.mark = ',')}{cli::qty(new_na_count)} CHI number{?s} produced {?an/} ambiguous date{?s} and will be given {.val NA} for {?its/their} Date{?s} of Birth.",
      "v" = "Try different values for {.arg min_date} and/or {.arg max_date}."
    ))
  }

  return(guess_dob)
}

#' @title Extract age from the CHI number
#'
#' @description \code{age_from_chi} takes a CHI number or a vector of CHI numbers
#' and returns the age as implied by the CHI number(s). If the DoB is ambiguous
#' it will return NA. It uses \code{dob_from_chi}.
#'
#' @param chi_number a CHI number or a vector of CHI numbers with \code{character} class.
#' @param ref_date calculate the age at this date, default is to use \code{Sys.Date()} i.e. today.
#' @param min_age,max_age optional min and/or max dates that the Date of Birth could take as the century needs to be guessed.
#' Must be either length 1 for a 'fixed' age or the same length as \code{chi_number} for an age per CHI number.
#' min_age can be age based on common sense in the dataset, whilst max_age can be age when an event happens such as the age at discharge.
#' @param chi_check logical, optionally skip checking the CHI for validity which will be
#' faster but should only be used if you have previously checked the CHI(s), the default (TRUE) will to check the CHI numbers.
#'
#' @return an integer vector of ages in years truncated to the nearest year. It will be the same length as \code{chi_number}.
#' @export
#'
#' @examples
#' age_from_chi("0101336489")
#'
#' library(tibble)
#' library(dplyr)
#' data <- tibble(chi = c(
#'   "0101336489",
#'   "0101405073",
#'   "0101625707"
#' ), dis_date = as.Date(c(
#'   "1950-01-01",
#'   "2000-01-01",
#'   "2020-01-01"
#' )))
#'
#' data %>%
#'   mutate(chi_age = age_from_chi(chi))
#'
#' data %>%
#'   mutate(chi_age = age_from_chi(chi, min_age = 18, max_age = 65))
#'
#' data %>%
#'   mutate(chi_age = age_from_chi(chi,
#'     ref_date = dis_date
#'   ))
age_from_chi <- function(chi_number, ref_date = NULL, min_age = 0, max_age = NULL, chi_check = TRUE) {

  # Do type checking on the params
  if (!inherits(chi_number, "character")) {
    cli::cli_abort("{.arg chi_number} must be a {.cls character} vector, not a {.cls {class(chi_number)}} vector.")
  }

  if (!is.null(ref_date) & !inherits(ref_date, c("Date", "POSIXct"))) {
    cli::cli_abort("{.arg ref_date} must be a {.cls Date} or {.cls POSIXct} vector, not a {.cls {class(ref_date)}} vector.")
  }

  # min and max ages are in a reasonable range
  if (min_age < 0) {
    cli::cli_abort("{.arg min_age} must be a positive integer.")
  }

  if (!is.null(max_age)) {
    if (any(max_age < min_age)) {
      cli::cli_abort("{.arg max_age}, must always be greater than or equal to {.arg min_age}.")
    }
  }

  if (is.null(ref_date)) ref_date <- Sys.Date()

  max_date.age <- ref_date - lubridate::years(min_age)

  if (is.null(max_age)) {
    min_date.age <- NULL
  } else {
    min_date.age <- ref_date - lubridate::years(max_age)
  }

  guess_dob <- dob_from_chi(
    chi_number = chi_number,
    min_date = min_date.age,
    max_date = max_date.age,
    chi_check = chi_check
  )

  guess_age <- age_calculate(guess_dob, ref_date)

  return(guess_age)
}
