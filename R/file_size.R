#' @title Calculate file size
#'
#' @description `file_size` takes a filepath and an optional regular
#' expression pattern. It returns the size of all files within that directory
#' which match the given pattern.
#'
#' @details The sizes of files with certain extensions are returned with the
#' type of file prefixed. For example, the size of a 12 KB `.xlsx` file is
#' returned as `Excel 12 KB`. The complete list of explicitly catered-for file
#' extensions and their prefixes are as follows:
#'
#' \itemize{
#' \item `.xls`, `.xlsb`, `.xlsm` and `.xlsx` files are
#' prefixed with `Excel`
#' \item `.csv` files are prefixed with `CSV`
#' \item `.sav` and `.zsav` files are prefixed with `SPSS`
#' \item `.doc`, `.docm` and `.docx` files are prefixed with
#' `Word`
#' \item `.rds` files are prefixed with `RDS`
#' \item `.txt` files are prefixed with `Text`,
#' \item `.fst` files are prefixed with `FST`,
#' \item `.pdf` files are prefixed with `PDF`,
#' \item `.tsv` files are prefixed with `TSV`,
#' \item `.html` files are prefixed with `HTML`,
#' \item `.ppt`, `.pptm` and `.pptx` files are prefixed with
#' `PowerPoint`,
#' \item `.md` files are prefixed with `Markdown`
#' }
#'
#' Files with extensions not contained within this list will have their size
#' returned with no prefix. To request that a certain extension be explicitly
#' catered for, please create an issue on
#' [GitHub](https://github.com/Public-Health-Scotland/phsmethods/issues).
#'
#' File sizes are returned as the appropriate multiple of the unit byte
#' (bytes (B), kilobytes (KB), megabytes (MB), etc.). Each multiple is taken to
#' be 1,024 units of the preceding denomination.
#'
#' @param filepath A character string denoting a filepath. Defaults to the
#' working directory, `getwd()`.
#' @param pattern An optional character string denoting a
#' [`regular expression()`][base::regex] pattern. Only file names which
#' match the regular expression will be returned. See the **See Also**
#' section for resources regarding how to write regular expressions.
#'
#' @return A [tibble::tibble()] listing the names of files within
#' `filepath` which match `pattern` and their respective sizes. The
#' column names of this tibble are `name` and `size`. If no `pattern` is
#' specified, `file_size` returns the names and sizes of all files within
#' `filepath`. File names and sizes are returned in alphabetical order of
#' file name. Sub-folders contained within `filepath` will return a file
#' size of `0 B`.
#'
#' If `filepath` is an empty folder, or `pattern` matches no files
#' within `filepath`, `file_size` returns `NULL`.
#'
#' @examples
#' # Name and size of all files in working directory
#' file_size()
#'
#' # Name and size of .xlsx files only in working directory
#' file_size(pattern = "\\.xlsx$")
#'
#' # Size only of alphabetically first file in working directory
#' library(magrittr)
#' file_size() %>%
#'   dplyr::pull(size) %>%
#'   extract(1)
#'
#' @seealso For more information on using regular expressions, see this
#' [Jumping Rivers blog post](https://www.jumpingrivers.com/blog/regular-expressions-every-r-programmer-should-know/)
#' and this
#' [vignette](https://stringr.tidyverse.org/articles/regular-expressions.html)
#' from the [`stringr()`][stringr::stringr-package] package.
#'
#' @export
file_size <- function(filepath = getwd(), pattern = NULL) {
  if (!file.exists(filepath)) {
    cli::cli_abort("A valid {.arg filepath} must be supplied.")
  }

  if (!inherits(pattern, c("character", "NULL"))) {
    cli::cli_abort("{.arg pattern} must be a {.cls character}, not a {.cls {class(pattern)}}.")
  }

  file_list <- list.files(path = filepath, pattern = pattern)

  if (length(file_list) == 0) {
    return(NULL)
  }

  formatted_size <- file.path(filepath, file_list) %>%
    file.size() %>%
    scales::number_bytes(units = "si")

  file_type <- dplyr::case_when(
    stringr::str_detect(file_list, "\\.xls(b|m|x)?$") ~ "Excel ",
    stringr::str_detect(file_list, "\\.csv$") ~ "CSV ",
    stringr::str_detect(file_list, "\\.z?sav$") ~ "SPSS ",
    stringr::str_detect(file_list, "\\.doc(m|x)?$") ~ "Word ",
    stringr::str_detect(file_list, "\\.rds$") ~ "RDS ",
    stringr::str_detect(file_list, "\\.txt$") ~ "Text ",
    stringr::str_detect(file_list, "\\.fst$") ~ "FST ",
    stringr::str_detect(file_list, "\\.pdf$") ~ "PDF ",
    stringr::str_detect(file_list, "\\.tsv$") ~ "TSV ",
    stringr::str_detect(file_list, "\\.html$") ~ "HTML ",
    stringr::str_detect(file_list, "\\.ppt(m|x)?$") ~ "PowerPoint ",
    stringr::str_detect(file_list, "\\.md$") ~ "Markdown ",
    .default = ""
  )

  tibble::tibble(
    name = file_list,
    size = paste0(file_type, formatted_size)
  )
}
