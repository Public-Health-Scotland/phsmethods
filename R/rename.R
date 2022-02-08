#' Functions renamed in December 2021
#'
#' @description
#' `r lifecycle::badge('deprecated')`
#'
#' We renamed a number of function to improve code clarity.
#' The old functions are still usable but will produce a warning.
#' After a reasonable amount of time they will be removed completely.
#'
#' * `postcode()` -> `format_postcode()`
#' * `age_group()` -> `create_age_groups()`
#' * `fin_year()` -> `extract_fin_year()`
#'
#'
#' @keywords internal
#' @name rename
#' @aliases NULL
#' @md
NULL

#' @rdname rename
#' @export
postcode <- function(x, format = c("pc7", "pc8")) {
  lifecycle::deprecate_warn("0.2.1", "postcode()", "format_postcode()")

  return(format_postcode(x = x, format = format))
}

#' @rdname rename
#' @export
age_group <- function(x,
                      from = 0,
                      to = 90,
                      by = 5,
                      as_factor = FALSE) {
  lifecycle::deprecate_warn("0.2.1", "age_group()", "create_age_groups()")

  return(create_age_groups(x = x,
                           from = from,
                           to = to,
                           by = by,
                           as_factor = as_factor))
}

#' @rdname rename
#' @export
fin_year <- function(date) {
  lifecycle::deprecate_warn("0.2.1", "fin_year()", "extract_fin_year()")

  return(extract_fin_year(date = date))
}
