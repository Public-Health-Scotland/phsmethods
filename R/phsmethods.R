#' `phsmethods` package
#'
#' Standard Methods for use in PHS.
#'
#' See the README on
#' [GitHub](https://github.com/Public-Health-Scotland/phsmethods#readme).
#'
#' @docType package
#' @name phsmethods
#' @importFrom magrittr %>%
#' @importFrom magrittr %<>%
#' @importFrom rlang .data
#' @importFrom tibble tibble
#' @importFrom lifecycle deprecated
NULL

# Stops notes from appearing in R CMD check because of undefined global
# variable '.' and allows area_lookup dataset to be used inside match_area
# function
if (getRversion() >= "2.15.1") utils::globalVariables(c(".", "area_lookup"))
