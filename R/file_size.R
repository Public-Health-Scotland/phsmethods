#' @title Calculate file sizes
#'
#' @importFrom magrittr %>%
#'
#' @export

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

  z <- dplyr::case_when(
    stringr::str_detect(x, ".xls(b|m|x)?$") ~ "Excel ",
    stringr::str_detect(x, ".csv$") ~ "CSV ",
    stringr::str_detect(x, ".z?sav$") ~ "SPSS ",
    stringr::str_detect(x, ".doc(m|x)?$") ~ "Word ",
    stringr::str_detect(x, ".rds$") ~ "RDS ",
    stringr::str_detect(x, ".tsv$") ~ "Text ",
    stringr::str_detect(x, ".fst$") ~ "FST ",
    stringr::str_detect(x, ".pdf$") ~ "PDF ",
    stringr::str_detect(x, ".tsv$") ~ "TSV ",
    stringr::str_detect(x, ".html$") ~ "HTML ",
    stringr::str_detect(x, ".ppt(m|x)?$") ~ "PowerPoint ",
    stringr::str_detect(x, ".md$") ~ "Markdown ",
    TRUE ~ ""
  )

  tibble::tibble(file_name = list.files(filepath, pattern),
                 file_size = paste0(z, y))

}
