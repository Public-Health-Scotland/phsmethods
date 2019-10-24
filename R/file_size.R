#' @export
#'
file_size <- function(filepath = getwd(), pattern = NULL) {

  if (!file.exists(filepath)) {
    stop("A valid filepath must be supplied")
  }

  if (!class(pattern) %in% c("character", "NULL")) {
    stop("A specified pattern must be of character class in order to be ",
         "evaluated as a regular expression")
  }

  x <- dir(path = filepath, pattern = pattern)

  if(length(x) == 0) {
    return(NULL)
  }

  y <- x %>%
    purrr::map(~file.info(paste0(filepath, "/", .))$size) %>%
    unlist() %>%
    gdata::humanReadable(standard = "IEC", digits = 0) %>%
    gsub("i", "", .) %>%
    trimws()

  k <- dplyr::case_when(
    stringr::str_detect(x, ".xlsx?$") ~ "Excel ",
    stringr::str_detect(x, ".csv$") ~ "CSV ",
    stringr::str_detect(x, ".z?sav$") ~ "SPSS ",
    stringr::str_detect(x, ".docx?$") ~ "Word ",
    stringr::str_detect(x, ".rds$") ~ "RDS ",
    TRUE ~ ""
  )

  paste0(k, y)

}
