#' @title Extract Date of Birth (DoB) from the CHI number
#'
#' @description \code{dob_from_chi} takes a CHI number or a vector of CHI numbers
#' and returns the DoB as implied by the CHI number(s). If the DoB is ambiguous
#' it will return NA
#'
#' @param chi_number
#' @param min_date
#' @param max_date
#' @param min_age
#' @param max_age
#' @param chi_check
#'
#' @return
#' @export
#'
#' @examples
dob_from_chi <- function(chi_number, min_date = NULL, max_date = NULL, min_age = 0, max_age = 120, chi_check = TRUE) {

  ## TODO
  # Do type checking on the params

  # min and max date are valid dates in a reasonable range

  # min and max ages are integers in a reasonable range

  # Convert the age into a date
  max_date.age <- Sys.time() - lubridate::years(min_age)
  min_date.age <- Sys.time() - lubridate::years(max_age)


  if (is.null(max_date) || max_date.age < max_date) {
    ## TODO provide message about usage of age vs supplied date
    max_date <- max_date.age
  }

  if (is.null(min_date) || min_date.age < min_date) {
    ## TODO provide message about usage of age vs supplied date
    min_date <- min_date.age
  }

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
    date_1900 < min_date ~ date_2000,
    date_2000 > max_date ~ date_1900
  ))

  return(guess_dob)
}
