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
#' less. Depending on the source, CHI numbers are sometimes missing a leading
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
#' @export

chi_pad <- function(x) {
  if (!inherits(x, "character")) {
    cli::cli_abort("The input must be a {.cls character} vector, not a {.cls {class(x)}} vector.")
  }

  # Add a leading zero to any string comprised of nine numeric digits
  sub("^([0-9]{9})$", "0\\1", x)
}
