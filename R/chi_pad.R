#' @title Add a leading zero to nine-digit CHI numbers
#'
#' @description `chi_pad` takes a nine-digit CHI number with
#' `character` class and prefixes it with a zero. Any values provided
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
#' stored with `numeric` class in R. This is because leading zeros in
#' numeric values are silently dropped, a practice not exclusive to R. For this
#' reason, `chi_pad` accepts input values of `character` class
#' only, and returns values of the same class.
#' @param chi_check logical, optionally check the CHI for validity (after
#' padding), any invalid CHIs will be substituted with `NA`. The default (FALSE)
#' will skip checking but we recommend you check any padded CHIs.This uses
#' [chi_check()].
#'
#' @inheritParams chi_check
#'
#' @return The original character vector with CHI numbers padded if applicable.
#'
#' @examples
#' chi_pad(c("101011237", "101201234"))
#' @export
chi_pad <- function(
  chi_number,
  chi_check = FALSE,
  check_mod11 = TRUE,
  check_mod10 = TRUE
) {
  if (!inherits(chi_number, "character")) {
    cli::cli_abort(
      "{.arg chi_number} must be a {.cls character} vector, not a {.cls {class(chi_number)}} vector."
    )
  }

  # Pad the 9-digit numbers first
  if (any(nchar(chi_number) == 9L, na.rm = TRUE)) {
    chi_number <- sub("^([0-9]{9})$", "0\\1", chi_number, perl = TRUE)
  }

  # Check the CHI after padding
  if (chi_check) {
    na_count <- sum(is.na(chi_number))
    valid_chi <- chi_check(
      chi_number,
      check_mod11 = check_mod11,
      check_mod10 = check_mod10
    ) ==
      "Valid CHI"

    chi_number[!valid_chi] <- NA_character_

    new_na_count <- sum(is.na(chi_number)) - na_count

    if (new_na_count > 0) {
      cli::cli_alert_warning(
        "{format(new_na_count, big.mark = ',')} {cli::qty(new_na_count)} CHI number{?s} {?is/are} invalid even after padding and will be set as {.val NA}."
      )
    }
  }

  return(chi_number)
}
