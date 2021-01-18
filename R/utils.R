#' @title Check for date types
#'
#' @description Internal function to check if a column is of
#' Date or POSIXct class
#'
#' @param date an object to check the type of.
#'
#' @return boolean
is_date <- function(date) {
  return(inherits(date, c("Date", "POSIXct")))
}
