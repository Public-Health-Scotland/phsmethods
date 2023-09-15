#' @title Extract sex from the CHI number
#'
#' @description \code{sex_from_chi} takes a CHI number or a vector of CHI numbers
#' and returns the sex as implied by the CHI number(s). The default return type is
#' an integer but this can be modified.
#'
#' @details The Community Health Index (CHI) is a register of all patients in
#' NHS Scotland. A CHI number is a unique, ten-digit identifier assigned to
#' each patient on the index.
#'
#' The ninth digit of a CHI number identifies a patient's sex: odd for men,
#' even for women.
#'
#' The default behaviour for \code{sex_from_chi} is to first check the CHI number is
#' valid using \code{check_chi} and then to return 1 for male and 2 for female.
#'
#' There are options to return custom values e.g. \code{'M'} and \code{'F'} or to return
#' a factor which will have labels \code{'Male'} and \code{'Female')}
#'
#' @param chi_number a CHI number or a vector of CHI numbers with \code{character} class.
#' @param male_value,female_value optionally supply custom values for Male and Female. Note
#' that that these must be of the same class.
#' @param as_factor logical, optionally return as a factor with labels \code{'Male'}
#' and \code{'Female'}. Note that this will override any custom values supplied with
#' \code{male_value} or \code{female_value}.
#' @param chi_check logical, optionally skip checking the CHI for validity which will be
#' faster but should only be used if you have previously checked the CHI(s).
#'
#' @return a vector with the same class as \code{male_value} and \code{female_value}, (integer
#' by default) unless \code{as_factor} is \code{TRUE} in which case a factor will be returned.
#' @export
#'
#' @examples
#' sex_from_chi("0101011237")
#' sex_from_chi(c("0101011237", "0101336489", NA))
#' sex_from_chi(c("0101011237", "0101336489", NA), male_value = "M", female_value = "F")
#' sex_from_chi(c("0101011237", "0101336489", NA), as_factor = TRUE)
#'
#' library(dplyr)
#' df <- tibble(chi = c("0101011237", "0101336489", NA))
#' df %>% mutate(chi_sex = sex_from_chi(chi))
sex_from_chi <- function(chi_number, male_value = 1L, female_value = 2L, as_factor = FALSE, chi_check = TRUE) {
  # Do type checking on male/female values
  male_class <- class(male_value)
  female_class <- class(female_value)
  if (male_class != female_class) {
    cli::cli_abort(c(
      "{.arg male_value} and {.arg female_value} must be of the same class.",
      "*" = "Supplied {.arg male_value} is {.cls {male_class}}",
      "*" = "Supplied {.arg female_value} is {.cls {female_class}}"
    ))
  }

  # Show message if using custom values for male/female
  if (male_value != 1L | female_value != 2L) {
    cli::cli_inform(c(
      "Using custom values: Male = {.val {male_value}}, Female = {.val {female_value}}",
      "The return variable will be {.cls {male_class}}."
    ))
  }

  # Parse the 9th digit of the chi number as an integer
  sex_digit <- readr::parse_integer(substr(chi_number, 9, 9))

  # Default behaviour: Check the CHI number
  # for invalid CHIs we will return NA for sex
  if (chi_check) {
    # Don't use any CHIs which don't pass the validity check
    sex_digit[which(chi_check(chi_number) != "Valid CHI")] <- NA_integer_
  }

  # Check if the digit is odd or even to determine the sex
  sex <- ifelse(sex_digit %% 2L == 0L, female_value, male_value)

  # Convert to a factor if required
  if (as_factor) {
    sex <- factor(sex, levels = c(male_value, female_value), labels = c("Male", "Female"))
  }

  return(sex)
}
