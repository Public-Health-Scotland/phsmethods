#' @title Assign a date to a financial year
#'
#' @description \code{fin_year} takes a date and assigns it to the correct
#' financial year in the PHI specified format.
#'
#' @details The PHI accepted format for financial year is yyyy/yy e.g. 2017/18.
#'
#' @param date A date which must be supplied with \code{Date} class. The
#' functions as.Date() or lubridate::dmy() are examples of functions that can
#' be used to change a variable to date class.
#'
#' @examples
#' x <- lubridate::dmy(c(21012017, 04042017, 17112017))
#'
#' fin_year(x)
#'
#' @export
fin_year <- function(date){
  if(class(date) != "Date"){
    stop("The input must have Date class.")
  }
  paste0(ifelse(lubridate::month(date) >= 4,
                lubridate::year(date),
                lubridate::year(date) - 1), "/",
         substr(ifelse(lubridate::month(date) >= 4,
                       lubridate::year(date) + 1,
                       lubridate::year(date)), 3, 4))
}
