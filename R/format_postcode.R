#' @title Format a postcode
#'
#' @description \code{format_postcode} takes a character string or vector of character
#' strings. It extracts the input values which adhere to the standard UK
#' postcode format (with or without spaces), assigns the appropriate amount
#' of spacing to them (for both pc7 and pc8 formats) and ensures all letters
#' are capitalised.
#'
#' @details The standard UK postcode format (without spaces) is:
#'
#' \itemize{
#' \item 1 or 2 letters, followed by
#' \item 1 number, followed by
#' \item 1 optional letter or number, followed by
#' \item 1 number, followed by
#' \item 2 letters
#' }
#'
#' \href{https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/283357/ILRSpecification2013_14Appendix_C_Dec2012_v1.pdf}{UK government regulations}
#' mandate which letters and numbers can be used in specific sections of a
#' postcode. However, these regulations are liable to change over time. For
#' this reason, \code{format_postcode} does not validate whether a given
#' postcode actually exists, or whether specific numbers and letters are being
#' used in the appropriate places. It only assesses whether the given input is
#' consistent with the above format and, if so, assigns the appropriate amount
#' of spacing and capitalises any lower case letters.
#'
#' @param x A character string or vector of character strings. Input values
#' which adhere to the standard UK postcode format may be upper or lower case
#' and will be formatted regardless of existing spacing. Any input values which
#' do not adhere to the standard UK postcode format will generate an NA and a
#' warning message - see \strong{Value} section for more information.
#' @param format A character string denoting the desired output format. Valid
#' options are `pc7` and `pc8`. The default is `pc7`. See \strong{Value}
#' section for more information on the string length of output values.
#' @param quiet (optional) If quiet is `TRUE` all messages and warnings will be
#' suppressed. This is useful in a production context and when you are sure of
#' the data or you are specifically using this function to remove invalid
#' postcodes. This will also make the function a bit quicker as fewer checks
#' are performed.
#'
#' @return When \code{format} is set equal to \code{pc7}, \code{format_postcode}
#' returns a character string of length 7. 5 character postcodes have two
#' spaces after the 2nd character; 6 character postcodes have 1 space after the
#' 3rd character; and 7 character postcodes have no spaces.
#'
#' When \code{format} is set equal to \code{pc8}, \code{format_postcode} returns
#'  a character string with maximum length 8. All postcodes, whether 5, 6 or 7
#' characters, have one space before the last 3 characters.
#'
#' Any input values which do not adhere to the standard UK postcode format will
#' generate an NA output value and a warning message. A warning is generated
#' rather than an error so as not to let one erroneously recorded postcode in a
#' large input vector prevent the remaining entries from being appropriately
#' formatted.
#'
#' Any input values which do adhere to the standard UK postcode format but
#' contain lower case letters will generate a warning message explaining that
#' these letters will be capitalised.
#'
#' @examples
#' format_postcode("G26QE")
#' format_postcode(c("KA89NB", "PA152TY"), format = "pc8")
#'
#' library(dplyr)
#' df <- tibble(postcode = c("G429BA", "G207AL", "DD37JY", "DG98BS"))
#' df %>%
#'   mutate(postcode = format_postcode(postcode))
#' @export
format_postcode <- function(x, format = c("pc7", "pc8"), quiet = FALSE) {
  if (!inherits(x, "character")) {
    cli::cli_abort("The input must be a {.cls character} vector,
                   not a {.cls {class(x)}} vector.")
  }
  if (!inherits(quiet, "logical")) {
    cli::cli_abort(
      "{.arg quiet} must be a {.cls logical}, not a {.cls {class(x)}}."
      )
  }
  format <- match.arg(format)

  x_upper <- stringr::str_to_upper(x)

  if (!quiet) {
    n_lowercase <- sum(x != x_upper, na.rm = TRUE)
    if (n_lowercase > 0) {
      cli::cli_warn(
        "{n_lowercase} value{?s} {?has/have} lower case letters these will be
        converted to upper case."
      )
    }
  }
  # The standard regex for a UK postcode
  uk_pc_regex <- "^[A-Z]{1,2}[0-9][A-Z0-9]?[0-9][A-Z]{2}$"

  # Strip out all spaces from the input, so they can be added in again later at
  # the appropriate juncture
  x_upper <- gsub(" ", "", x_upper, fixed = TRUE)

  # Calculate the number of non-NA values in the input which do not adhere to
  # the standard UK postcode format
  bad_format <- stringr::str_detect(x_upper, uk_pc_regex, negate = TRUE)
  n_bad_format <- sum(bad_format, na.rm = TRUE)

  if (n_bad_format > 0) {
    if (!quiet) {
      cli::cli_warn(c(
        "{n_bad_format} non-NA input value{?s} {?does/do} not adhere to the
        standard UK postcode format (with or without spaces) and will be
        coded as NA.",
        "The standard format is:",
        "*" = "1 or 2 letters, followed by",
        "*" = "1 number, followed by",
        "*" = "1 optional letter or number, followed by",
        "*" = "1 number, followed by",
        "*" = "2 letters"
      ))
    }

    # Replace postcodes which do not adhere to the standard format with NA
    # (this will also 'replace' NA with NA)
    x_upper <- replace(x_upper, bad_format, NA_character_)
  }

  # pc7 format requires all valid postcodes to be of length 7, meaning:
  # 5 character postcodes have 2 spaces after the 2nd character;
  # 6 character postcodes have 1 space after the 3rd character;
  # 7 character postcodes have no spaces
  x_upper_len <- nchar(x_upper)
  if (format == "pc7") {
    return(dplyr::case_when(
      is.na(x_upper) ~ NA_character_,
      x_upper_len == 5 ~ paste0(
        substr(x_upper, 1, 2),
        "  ",
        substr(x_upper, 3, 5)
      ),
      x_upper_len == 6 ~ paste0(
        substr(x_upper, 1, 3),
        " ",
        substr(x_upper, 4, 6)
      ),
      x_upper_len == 7 ~ x_upper
    ))
  } else {
    # pc8 format requires all valid postcodes to be of maximum length 8
    # All postcodes, whether 5, 6 or 7 characters, have one space before the
    # last 3 characters
    return(dplyr::case_when(
      is.na(x_upper) ~ NA_character_,
      x_upper_len %in% 5:7 ~ paste(
        stringr::str_sub(x_upper, end = -4),
        stringr::str_sub(x_upper, start = -3)
      )
    ))
  }
}
