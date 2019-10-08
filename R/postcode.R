#' @title Format a postcode
#' @export

postcode <- function(string, format = c("pc7", "pc8")) {

  if(any(is.na(string))) {
    warning("NA values in the input string(s) will be preserved")
  }

  # Convert NA to "NA" for error handling
  # Will be converted back at the end
  string <- stringr::str_replace_na(string)

  if(!all(stringr::str_detect(string, "^[A-Za-z0-9 ]*$"))) {
    stop("Non-NA values in the input string(s) may contain letters, numbers ",
         "and spaces only")
  }

  if(!all(stringr::str_detect(string, "((?=.*[0-9])(?=.*[A-Za-z])|^NA$)"))) {
    stop("Non-NA values in the input string(s) must contain both letters and ",
         "numbers")
  }

  if(any(grepl("[a-z]", string))) {
    warning("Any lower case letters in the input string(s) will be converted ",
            "to upper case")
  }

  string <- stringr::str_to_upper(string)

  pc <- gsub("\\s", "", string)

  if(!all(stringr::str_length(pc)[pc != "NA"] %in% 5:7)) {
    warning("Non-NA values in the input string(s) containing fewer than 5 or ",
            "more than 7 alphanumeric characters will not have their spacing ",
            "altered")
  }

  if (format == "pc7") {
    return(dplyr::case_when(
      pc == "NA" ~ NA_character_,
      stringr::str_length(pc) == 5 ~ sub("(.{2})", "\\1  ", pc),
      stringr::str_length(pc) == 6 ~ sub("(.{3})", "\\1 ", pc),
      stringr::str_length(pc) == 7 ~ pc,
      TRUE ~ string
    ))
  }

  if (format == "pc8") {
    return(dplyr::case_when(
      pc == "NA" ~ NA_character_,
      stringr::str_length(pc) %in% 5:7 ~
        stringi::stri_reverse(sub("(.{3})", "\\1 ", stringi::stri_reverse(pc))),
      TRUE ~ string
    ))
  }

}
