#' @title Format a postcode
#'
#' @description \code{postcode} takes a character string or vector of character
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
#' this reason, \code{postcode} does not validate whether a given postcode
#' actually exists, or whether specific numbers and letters are being used in
#' the appropriate places. It only assesses whether the given input is
#' consistent with the above format and, if so, assigns the appropriate amount
#' of spacing and capitalises any lower case letters.
#'
#' @param string A character string or vector of character strings. Input
#' values which adhere to the standard UK postcode format may be upper or lower
#' case and will be formatted regardless of existing spacing. Any input values
#' which do not adhere to the standard UK postcode format will generate an NA
#' and a warning message - see \strong{Value} section for more information.
#' @param format A character string denoting the desired output format. Valid
#' options are `pc7` and `pc8`. The default is `pc7`. See \strong{Value}
#' section for more information on the string length of output values.
#'
#' @return When \code{format} is set equal to \code{pc7}, \code{postcode}
#' returns a character string of length 7. 5 character postcodes have two
#' spaces after the 2nd character; 6 character postcodes have 1 space after the
#' 3rd character; and 7 character postcodes have no spaces.
#'
#' When \code{format} is set equal to \code{pc8}, \code{postcode} returns a
#' character string with maximum length 8. All postcodes, whether 5, 6 or 7
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
#' postcode("G26QE")
#' postcode(c("KA89NB", "PA152TY"), format = "pc8")
#'
#' library(dplyr)
#' x <- tibble(pc = c("G429BA", "G207AL", "DD37JY", "DG98BS"))
#' x %>% mutate(pc = postcode(pc))
#'
#' @export

postcode <- function(string, format = c("pc7", "pc8")) {

  format <- match.arg(format)

  # Strip out all spaces from the input, so they can be added in again later at
  # the appropriate juncture
  pc <- gsub("\\s", "", string)

  # Calculate the number of non-NA values in the input which do not adhere to
  # the standard UK postcode format
  n <- length(
    pc[!is.na(pc)][!stringr::str_detect(
      pc[!is.na(pc)],
      "^[A-Za-z]{1,2}[0-9][A-Za-z0-9]?[0-9]{1}[A-Za-z]{2}$")])

  # If n is one, the warning message describing the number of values which
  # do not adhere to the standard format should use singular verbs
  # Otherwise, use plural ones
  singular <- "value does"
  multiple <- "values do"

  if (
    !all(
      stringr::str_detect(
        pc[!is.na(pc)],
        "^[A-Za-z]{1,2}[0-9][A-Za-z0-9]?[0-9]{1}[A-Za-z]{2}$"))) {
    warning(glue::glue("{n} non-NA input {ifelse(n == 1, singular, multiple)} ",
                       "not adhere to the standard UK postcode format (with ",
                       "or without spaces) and will be coded as NA. The ",
                       "standard format is:\n",
                       "\U2022 1 or 2 letters, followed by\n",
                       "\U2022 1 number, followed by\n",
                       "\U2022 1 optional letter or number, followed by\n",
                       "\U2022 1 number, followed by\n",
                       "\U2022 2 letters"))
  }

  # Replace postcodes which do not adhere to the standard format with NA (this
  # will also 'replace' NA with NA)
  pc <- replace(pc,
                !stringr::str_detect(
                  pc,
                  "^[A-Za-z]{1,2}[0-9][A-Za-z0-9]?[0-9]{1}[A-Za-z]{2}$"),
                NA_character_)

  if (any(grepl("[a-z]", pc))) {
    warning("Lower case letters in any input value(s) adhering to the ",
            "standard UK postcode format will be converted to upper case")
  }

  pc <- stringr::str_to_upper(pc)

  # pc7 format requires all valid postcodes to be of length 7, meaning:
  # 5 character postcodes have 2 spaces after the 2nd character;
  # 6 character postcodes have 1 space after the 3rd character;
  # 7 character postcodes have no spaces
  if (format == "pc7") {
    return(dplyr::case_when(
      is.na(pc) ~ NA_character_,
      stringr::str_length(pc) == 5 ~ sub("(.{2})", "\\1  ", pc),
      stringr::str_length(pc) == 6 ~ sub("(.{3})", "\\1 ", pc),
      stringr::str_length(pc) == 7 ~ pc
    ))

  } else {

    # pc8 format requires all valid postcodes to be of maximum length 8
    # All postcodes, whether 5, 6 or 7 characters, have one space before the
    # last 3 characters
    return(dplyr::case_when(
      is.na(pc) ~ NA_character_,
      stringr::str_length(pc) %in% 5:7 ~
        # Reverse the order of the postcodes to add a space after 3 characters,
        # then reverse again to get them back the right way around
        stringi::stri_reverse(sub("(.{3})", "\\1 ", stringi::stri_reverse(pc)))
    ))
  }
}
