#' @title Format a postcode

postcode <- function(string) {

  if(!any(is.na(string)) &&
     !all(stringr::str_detect(string, "^[A-Za-z0-9 ]*$"))) {
    stop("Non-NA values in the input string(s) may contain letters, numbers ",
         "and spaces only")
  }

  if(!any(is.na(string)) &&
     !all(stringr::str_detect(string, "(?=.*[0-9])(?=.*[A-Za-z])"))) {
    stop("Non-NA values in the input string(s) must contain both letters and ",
         "numbers")
  }

  if(!any(is.na(string)) && any(grepl("[a-z]", string))) {
    warning("Any lower case letters in the input string(s) will be converted ",
            "to upper case")
  }

  string <- stringr::str_to_upper(string)

  string <- gsub("\\s", "", string)

  dplyr::case_when(
    is.na(string) ~ NA_character_,
    stringr::str_length(string) == 5 ~ sub("(.{2})", "\\1  ", string),
    stringr::str_length(string) == 6 ~ sub("(.{3})", "\\1 ", string),
    TRUE ~ string
  )
}
