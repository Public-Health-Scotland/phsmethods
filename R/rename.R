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
#'
#'
#' @keywords internal
#' @name rename
#' @aliases NULL
NULL

#' @rdname rename
#' @export
postcode <- function(x, format = c("pc7", "pc8")) {
  lifecycle::deprecate_warn("0.2.0", "postcode()", "format_postcode()")

  return(format_postcode(x = x, format = format))
}

