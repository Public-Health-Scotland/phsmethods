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
    cli::cli_abort("{.arg x} must be a {.cls character} vector, not a {.cls {class(x)}} vector.")
  }

  # Calculate the number of characters
  nc <- nchar(x)

  # Initialise the output vector to be a character vector
  out <- character(length(x))
  # Check if the first six digits denote a valid date
  out[is.na(lubridate::fast_strptime(substr(x, 1, 6), "%d%m%y"))] <- "Invalid date"
  # Check if the number of characters is less than 10 digits
  out[nc < 10] <- "Too few characters"
  # Check if the number of characters is more than 10 digits
  out[nc > 10] <- "Too many characters"
  # Check if it contains non-numeric characters (e.g. letters and punctuation)
  out[grepl("[^0-9]", x)] <- "Invalid character(s) present"
  # Check if any are empty strings
  out[!is.na(x) & x == ""] <- "Missing (Blank)"
  # Check if any are are missing values
  out[is.na(x)] <- "Missing (NA)"
  # Check if the checksum digit is valid
  out[out == ""] <- ifelse(checksum(x[out == ""]), "Valid CHI", "Invalid checksum")

  out
}

checksum <- function(x) {
  # Get unique values of input to improve efficiency
  xu <- unique(x)

  # Change from character to numeric
  xu_num <- as.numeric(xu)
  # Create a vector to help separate each CHI digit
  denom <- 1000000000 / 10^(0:9)

  # Separate each CHI digit into a matrix
  chi_matrix <- outer(xu_num, denom, function(x, y) x %/% y %% 10)
  # Extract the first nine digits
  chi_matrix_nine <- chi_matrix[, 1:9]
  # Extract the tenth digit
  chi_matrix_ten <- chi_matrix[, 10]

  # Weight factor for checksum calculation
  wg <- 10:2
  # Matrix multiplication
  i <- c(chi_matrix_nine %*% wg)

  j <- floor(i / 11) # Discard remainder
  k <- 11 * (j + 1) - i # Checksum calculation
  k <- ifelse(k == 11, 0, k) # If 11, make 0

  # Return TRUE if k is equal to the tenth digit
  out <- k == chi_matrix_ten
  # Spread the results to all inputs
  out[match(x, xu)]
}
