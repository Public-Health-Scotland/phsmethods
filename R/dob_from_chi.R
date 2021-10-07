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

  ## TODO
  # Do type checking on the params

  # min and max date are valid dates in a reasonable range

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
