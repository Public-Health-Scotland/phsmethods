#' @title Format a postcode
#' @export

postcode <- function(string, format = c("pc7", "pc8")) {

  format <- match.arg(format)

  if(!all(stringr::str_detect(string[!is.na(string)], "^[A-Za-z0-9 ]*$"))) {
    stop("Non-NA values in the input string(s) may contain letters, numbers ",
         "and spaces only")
  }

  # Strip out all spaces from the input, so they can be added in again later at
  # the appropriate juncture
  pc <- gsub("\\s", "", string)

  if(!all(
    stringr::str_detect(pc[!is.na(pc)],
                        "^[A-Za-z]{1,2}[0-9]{1,2}[0-9]{1}[A-Za-z]{2}$"))) {
    warning("Values in the input string(s) which do not follow the standard ",
            "UK postcode format (with or without spaces) will not be altered. ",
            "The standard format is:\n",
            "\U2022 1 or 2 letters, followed by\n",
            "\U2022 1 or 2 numbers, followed by\n",
            "\U2022 1 number, followed by\n",
            "\U2022 2 letters")
  }

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
      is.na(string) ~ NA_character_,
      stringr::str_length(pc) == 5 ~ sub("(.{2})", "\\1  ", pc),
      stringr::str_length(pc) == 6 ~ sub("(.{3})", "\\1 ", pc),
      stringr::str_length(pc) == 7 ~ pc,
      TRUE ~ string
    ))

  } else {

    # pc8 format requires all valid postcodes to be of maximum length 8
    # All postcodes, whether 5, 6 or 7 characters, have one space before the
    # last 3 characters
    return(dplyr::case_when(
      is.na(string) ~ NA_character_,
      stringr::str_length(pc) %in% 5:7 ~
        # Reverse the order of the postcodes to add a space after 3 characters,
        # then reverse again to get them back the right way around
        stringi::stri_reverse(sub("(.{3})", "\\1 ", stringi::stri_reverse(pc))),
      TRUE ~ string
    ))
  }
}
