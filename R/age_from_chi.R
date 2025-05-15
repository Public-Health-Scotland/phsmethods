#' @title Extract age from the CHI number
#'
#' @description `age_from_chi` takes a CHI number or a vector of CHI numbers
#' and returns the age as implied by the CHI number(s). If the Date of Birth
#' (DoB) is ambiguous it will return NA. It uses [dob_from_chi()].
#'
#' @param chi_number a CHI number or a vector of CHI numbers with `character`
#' class.
#' @param ref_date calculate the age at this date, default is to use
#' `Sys.Date()` i.e. today.
#' @param min_age,max_age optional min and/or max dates that the DoB could take
#' as the century needs to be guessed.
#' Must be either length 1 for a 'fixed' age or the same length as `chi_number`
#' for an age per CHI number.
#' `min_age` can be age based on common sense in the dataset, whilst `max_age`
#' can be age when an event happens such as the age at discharge.
#' @param chi_check logical, optionally skip checking the CHI for validity which
#' will be faster but should only be used if you have previously checked the
#' CHI(s), the default (TRUE) will to check the CHI numbers.
#'
#' @return an integer vector of ages in years truncated to the nearest year.
#' It will be the same length as `chi_number`.
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
age_from_chi <- function(
    chi_number,
    ref_date = NULL,
    min_age = 0,
    max_age = NULL,
    chi_check = TRUE) {
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
