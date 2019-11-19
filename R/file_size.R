#' @title Calculate file size
#'
#' @description \code{file_size} takes a filepath and an optional regex pattern.
#' It returns the size of any files within that directory which match the given
#' pattern.
#'
#' @param filepath A filepath. Defaults to the working directory,
#' \code{getwd()}.
#' @inheritParams base::list.files
#'
#' @return A \code{\link[tibble]{tibble}} listing the names of the files within
#' \code{filepath} which match \code{pattern} and their respective file sizes.
#' If no \code{pattern} is specified, \code{file_size} returns the names and
#' file sizes of all files within \code{filepath}.
#'
#' If \code{filepath} is an empty folder, or \code{pattern} matches no files
#' within \code{filepath}, \code{file_size} returns \code{NULL}.
#'
#' @seealso For more information on using regular expressions, see this
#' \href{https://www.jumpingrivers.com/blog/regular-expressions-every-r-programmer-should-know/}{Jumping Rivers blog post}
#' and this
#' \href{https://stringr.tidyverse.org/articles/regular-expressions.html}{vignette}
#' from the \href{https://stringr.tidyverse.org/}{stringr} package.
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
    stringr::str_detect(x, ".txt$") ~ "Text ",
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
