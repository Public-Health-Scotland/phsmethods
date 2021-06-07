#' @title Check the validity of a CHI number
#'
#' @description \code{chi_check} takes a CHI number or a vector of CHI numbers
#' with \code{character} class. It returns feedback on the validity of the
#' entered CHI number and, if found to be invalid, provides an explanation as
#' to why.
#'
#' @details The Community Health Index (CHI) is a register of all patients in
#' NHS Scotland. A CHI number is a unique, ten-digit identifier assigned to
#' each patient on the index.
#'
#' The first six digits of a CHI number are a patient's date of birth in
#' DD/MM/YY format. The first digit of a CHI number must, therefore, be 3 or
#' less.
#'
#' The ninth digit of a CHI number identifies a patient's sex: odd for men,
#' even for women. The tenth digit is a check digit, denoted `checksum`.
#'
#' While a CHI number is made up exclusively of numeric digits, it cannot be
#' stored with \code{numeric} class in R. This is because leading zeros in
#' numeric values are silently dropped, a practice not exclusive to R. For this
#' reason, \code{chi_check} accepts input values of \code{character} class
#' only. A leading zero can be added to a nine-digit CHI number using
#' \code{\link{chi_pad}}.
#'
#' \code{chi_check} assesses whether an entered CHI number is valid by checking
#' whether the answer to each of the following criteria is `Yes`:
#'
#' \itemize{
#' \item Does it contain no non-numeric characters?
#' \item Is it ten digits in length?
#' \item Do the first six digits denote a valid date?
#' \item Is the checksum digit correct?
#' }
#'
#' @param x a CHI number or a vector of CHI numbers with \code{character} class.
#'
#' @return \code{chi_check} returns a character string. Depending on the
#' validity of the entered CHI number, it will return one of the following:
#'
#' \itemize{
#' \item `Valid CHI`
#' \item `Invalid character(s) present`
#' \item `Too many characters`
#' \item `Too few characters`
#' \item `Invalid date`
#' \item `Invalid checksum`
#' \item `Missing`
#' }
#'
#' @examples
#' chi_check("0101011237")
#' chi_check(c("0101201234", "3201201234"))
#'
#' library(dplyr)
#' df <- tibble(chi = c("3213201234", "123456789", "12345678900", "010120123?", NA))
#' df %>% mutate(validity = chi_check(chi))
#'
#' @export

chi_check <- function(x) {

  if (!inherits(x, "character")) {
    stop("The input must be of character class")
  }

  # Store unchanged input for checking missing values
  y <- x

  # Replace entries containing invalid characters (letters and punctuation)
  # with NA
  x <- ifelse(grepl("[[:punct:][:alpha:]]", x),
              NA,
              x)

  # Perform checks and return feedback
  dplyr::case_when(
    is.na(y) ~ "Missing",
    is.na(x) ~ "Invalid character(s) present",
    nchar(x) > 10 ~ "Too many characters",
    nchar(x) < 10 ~  "Too few characters",
    is.na(lubridate::fast_strptime(substr(x, 1, 6), "%d%m%y")) ~ "Invalid date",
    checksum(x) == FALSE ~ "Invalid checksum",
    TRUE ~ "Valid CHI")
}

checksum <- function(x) {

  # Multiply by weights and add together
  i <- sub_num(x, 1) + sub_num(x, 2) +
    sub_num(x, 3) + sub_num(x, 4) +
    sub_num(x, 5) + sub_num(x, 6) +
    sub_num(x, 7) + sub_num(x, 8) +
    sub_num(x, 9)

  j <- floor(i / 11) # Discard remainder
  k <- 11 * (j + 1) - i # Checksum calculation
  k <- ifelse(k == 11, 0, k) # If 11, make 0

  # Check if output matches the checksum
  ifelse(k == substr(x, 10, 10), TRUE, FALSE)
}

sub_num <- function(x, num) {

  # Weight factor for checksum calculation
  wg <- 10:2

  # Extract character by position
  x_ex <- substr(x, num, num)

  # Multiply by weight factor
  as.numeric(x_ex) * wg[num]
}

#' @title Add a leading zero to nine-digit CHI numbers
#'
#' @description \code{chi_pad} takes a nine-digit CHI number with
#' \code{character} class and prefixes it with a zero. Any values provided
#' which are not a string comprised of nine numeric digits remain unchanged.
#'
#' @details The Community Health Index (CHI) is a register of all patients in
#' NHS Scotland. A CHI number is a unique, ten-digit identifier assigned to
#' each patient on the index.
#'
#' The first six digits of a CHI number are a patient's date of birth in
#' DD/MM/YY format. The first digit of a CHI number must, therefore, be 3 or
#' less. Depending on the source, CHI numbers are sometimes mising a leading
#' zero.
#'
#' While a CHI number is made up exclusively of numeric digits, it cannot be
#' stored with \code{numeric} class in R. This is because leading zeros in
#' numeric values are silently dropped, a practice not exclusive to R. For this
#' reason, \code{chi_pad} accepts input values of \code{character} class
#' only, and returns values of the same class. It does not assess the validity
#' of a CHI number - please see \code{\link{chi_check}} for that.
#'
#' @inheritParams chi_check
#'
#' @examples
#' chi_pad(c("101011237", "101201234"))
#'
#' @export

chi_pad <- function(x) {

  if (!inherits(x, "character")) {
    stop("The input must be of character class")
  }

  # Add a leading zero to any string comprised of nine numeric digits
  sub("^([0-9]{9})$", "0\\1", x)
}


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
#' @param as_factor logical, optionally return as a factor with lables \code{'Male'}
#' and \code{'Female'}. Note that this will overide any custom values supplied with
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
  male_type <- class(male_value)
  female_type <- class(female_value)
  if (male_type != female_type) {
    stop(paste0(
      "Supplied male and female values must be of the same class ",
      "(male_value is: ", male_type,
      ", female_value is: ", female_type, ")."
    ))
  }

  # Show message if using custom values for male/female
  if (male_value != 1L | female_value != 2L) {
    message(paste0(
      "Using custom values: Male = ",
      male_value, " Female = ", female_value,
      ".\nThe return variable will be ", male_type, "."
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
