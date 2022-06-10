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
#' DD/MM/YY format.
#'
#' The ninth digit of a CHI number identifies a patient's sex: odd for male,
#' even for female. The tenth digit is a check digit, denoted `checksum`.
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
#' \item `Missing (NA)`
#' \item `Missing (Blank)`
#' }
#'
#' @examples
#' chi_check("0101011237")
#' chi_check(c("0101201234", "3201201234"))
#'
#' library(dplyr)
#' df <- tibble(chi = c("3213201234", "123456789", "12345678900", "010120123?", NA))
#' df %>%
#'   mutate(validity = chi_check(chi))
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
    x
  )

  # Perform checks and return feedback
  dplyr::case_when(
    is.na(y) ~ "Missing (NA)",
    x == "" ~ "Missing (Blank)",
    is.na(x) ~ "Invalid character(s) present",
    nchar(x) > 10 ~ "Too many characters",
    nchar(x) < 10 ~ "Too few characters",
    is.na(lubridate::fast_strptime(substr(x, 1, 6), "%d%m%y")) ~ "Invalid date",
    checksum(x) == FALSE ~ "Invalid checksum",
    TRUE ~ "Valid CHI"
  )
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