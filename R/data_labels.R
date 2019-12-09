#' @title Read variable or value labels from an SPSS file
#'
#' @description \code{data_labels} takes an SPSS data file and reads any value
#' or variable labels, returning a tibble.
#'
#' @details The options of labels to read are:
#'
#' \itemize{
#' \item `var` - variable labels
#' \item `val` - value labels
#' \item `all` - both variable and value labels
#' }
#'
#' @param df A dataframe which must be supplied with \code{df} class.
#' @param lab_type The type of labels to be read. Valid options are `var`,
#' `val` and `all`. The default is `var`.
#'
#' @return When \code{lab_type} is set equal to \code{var}, \code{data_labels}
#' returns a tibble of ....
#'
#' @return When \code{lab_type} is set equal to \code{val}, \code{data_labels}
#' returns a tibble of ....
#'
#' @return When \code{lab_type} is set equal to \code{all}, \code{data_labels}
#' returns a tibble of ....
#'
#' @examples
#' data_labels(training_dataset, "var")
#' x <- data_labels(training_dataset_2, "all")
#'
#' @export

# library(haven)
# library(purrr)
# library(dplyr)
# library(tibble)
# library(readr)


data_labels <- function(df, lab_type = c("var", "val", "all")) {

  if (!file.exists(df)) {
    stop("File does not exist. Please check filepath and filename.")
  }

  lab_type <- match.arg(lab_type)

  df <- haven::read_spss(df)
  if (lab_type == "var") {
    # Create a tibble for variable labels
    var_desc <- purrr::map(df, ~ attributes(.)[["label"]])
    var_desc <- purrr::map(var_desc, ~ replace(attr(.x, "label"),
                                             is.null(attr(.x, "label")),
                                             NA))
    unlist(var_desc)
    #Move this warning to be better placed???
    if (any(purrr::some(var_desc, ~ str_detect(., NA_character_)))) {
      warning("Empty labels(s) have been replaced with NA")
    }
    var_desc_tib <- tibble::tibble(var_order = 1L:ncol(df),
                                   var = names(df),
                                   var_desc = var_desc)
    return(var_desc_tib)
  }
  else if (lab_type == "val") {
    # Create a tibble for value labels
    vals <- purrr::map(df, ~ attributes(.)[["labels"]])
    val_lab <- purrr::map(df, ~ names(attributes(.)[["labels"]]))

    val_desc_tib <- tibble::tibble(var = rep(names(vals),
                                             map_int(vals, length)),
                                   code = unlist(vals, use.names = FALSE),
                                   code_desc = unlist(val_lab, use.names = FALSE))
    return(val_desc_tib)
  }
  else if (lab_type == "all") {
    # Create a tibble for variable labels
    var_desc <- purrr::map(df, ~ attributes(.)[["label"]])
    var_desc <- purrr::map_chr(var_desc, ifelse(is.null(.), NA, .))

    var_desc_tib <- tibble::tibble(var_order = 1L:ncol(df),
                                   var = names(df),
                                   var_desc = var_desc)
    # Create a tibble for value labels
    vals <- purrr::map(df, ~ attributes(.)[["labels"]])
    val_lab <- purrr::map(df, ~ names(attributes(.)[["labels"]]))

    val_desc_tib <- tibble::tibble(var = rep(names(vals),
                                             map_int(vals, length)),
                                   code = unlist(vals, use.names = FALSE),
                                   code_desc = unlist(val_lab, use.names = FALSE))
    # Join them together
    all_lab_tib <- dplyr::left_join(val_desc_tib, val_desc_tib, by = "var")
    return(all_lab_tib)
  }
}

data_labels("/conf/linkage/output/lookups/Unicode/Geography/DataZone2011/DataZone2011.sav", "all")
