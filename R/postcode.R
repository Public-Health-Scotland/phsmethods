#' @title Format a postcode
#' @export

postcode <- function(string, format = c("pc7", "pc8")) {

  format <- match.arg(format)

  if(!all(stringr::str_detect(string[!is.na(string)], "^[A-Za-z0-9 ]*$"))) {
    stop("Non-NA input values may contain letters, numbers and spaces only")
  }

  # Strip out all spaces from the input, so they can be added in again later at
  # the appropriate juncture
  pc <- gsub("\\s", "", string)

  # Calculate the number of non-NA values in the input which do not match the
  # standard UK postcode format
  n <- length(
    pc
    [!is.na(pc)]
    [!stringr::str_detect(pc[!is.na(pc)],
                          "^[A-Za-z]{1,2}[0-9]{1,2}[0-9]{1}[A-Za-z]{2}$")])

  # If n is one, the warning message describing the number of values which
  # don't match the standard format should use singular verbs
  # Otherwise, use plural ones
  singular <- "value does"
  multiple <- "values do"

  if(!all(
    stringr::str_detect(pc[!is.na(pc)],
                        "^[A-Za-z]{1,2}[0-9]{1,2}[0-9]{1}[A-Za-z]{2}$"))) {
    warning(glue::glue("{n} non-NA input {ifelse(n == 1, singular, multiple)} ",
                       "not follow the standard UK postcode format (with or ",
                       "without spaces) and will be coded as NA. The standard ",
                       "format is:\n",
                       "\U2022 1 or 2 letters, followed by\n",
                       "\U2022 1 or 2 numbers, followed by\n",
                       "\U2022 1 number, followed by\n",
                       "\U2022 2 letters"))
  }

  # Replace postcodes which don't meet standard UK format with NA (this will
  # also 'replace' NA with NA)
  pc <- replace(pc,
                !stringr::str_detect(
                  pc,
                  "^[A-Za-z]{1,2}[0-9]{1,2}[0-9]{1}[A-Za-z]{2}$"),
                NA_character_)

  if(any(grepl("[a-z]", pc))) {
    warning("Lower case letters in the input string(s) which form part of a ",
            "valid postcode will be converted to upper case")
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
