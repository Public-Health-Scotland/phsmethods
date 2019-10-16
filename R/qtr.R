#' @title Assign a date to a quarter
#' 
#' @description 
#' 
#' The qtr functions take a date input and calculate the relevant
#' quarter-related value from it.
#' 
#' \itemize{
#' \item \code{qtr_year} returns the current quarter and year in either short or
#' long format.
#' 
#' \item \code{qtr_end} returns the last month in the quarter in either short or
#' long format.
#' 
#' \item \code{qtr_prev} returns the previous quarter in either short or long
#' format.
#' }
#' 
#' @param date A date in standard date format YYYY-MM-DD supplied with 
#' \code{Date} class.
#' @param format A \code{character} string specifying the format the quarter
#' should be displayed in. Valid options are `short` (Jan-Mar 2018) and `long`
#' (January to March 2018).
#' 
#' @examples 
#' x <- lubridate::dmy(c("26032012", "04052012", "23092012"))
#' 
#' qtr_year(x, format = "long")
#' 
#' qtr_end(x, format = "short")
#' 
#' qtr_prev(x, format = "long")

#' @export
qtr_year <- function(date, format = c("long", "short")) {
  
  format <- match.arg(format)
  
  if (class(date) != "Date") {
    stop("The date must be provided in standard date format YYYY-MM-DD")
  }
  
  if (format == "long") {
    quarter_num <- lubridate::quarter(date)
    
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0("January to March ", 
                                as.character(lubridate::year(date))),
      quarter_num == 2 ~ paste0("April to June ",
                                as.character(lubridate::year(date))),
      quarter_num == 3 ~ paste0("July to September ",
                                as.character(lubridate::year(date))),
      quarter_num == 4 ~ paste0("October to December ",
                                as.character(lubridate::year(date)))))
  } else {
    quarter_num <- lubridate::quarter(date)
    
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0("Jan-Mar ", 
                                as.character(lubridate::year(date))),
      quarter_num == 2 ~ paste0("Apr-Jun ",
                                as.character(lubridate::year(date))),
      quarter_num == 3 ~ paste0("Jul-Sep ",
                                as.character(lubridate::year(date))),
      quarter_num == 4 ~ paste0("Oct-Dec ",
                                as.character(lubridate::year(date)))))
  }
}

#' @export
qtr_end <- function(date, format = c("long", "short")) {
  
  format <- match.arg(format)
  
  if (class(date) != "Date") {
    stop("The date must be provided in standard date format YYYY-MM-DD")
  }
  
  if (format == "long") {
    quarter_num <- lubridate::quarter(date)
    
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0("March ", 
                                as.character(lubridate::year(date))),
      quarter_num == 2 ~ paste0("June ",
                                as.character(lubridate::year(date))),
      quarter_num == 3 ~ paste0("September ",
                                as.character(lubridate::year(date))),
      quarter_num == 4 ~ paste0("December ",
                                as.character(lubridate::year(date)))))
  } else {
    quarter_num <- lubridate::quarter(date)
    
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0("Mar ", 
                                as.character(lubridate::year(date))),
      quarter_num == 2 ~ paste0("Jun ",
                                as.character(lubridate::year(date))),
      quarter_num == 3 ~ paste0("Sep ",
                                as.character(lubridate::year(date))),
      quarter_num == 4 ~ paste0("Dec ",
                                as.character(lubridate::year(date)))))
  }
}

#' @export
qtr_prev <- function(date, format = c("long", "short")) {
  
  format <- match.arg(format)
  
  if (class(date) != "Date") {
    stop("The date must be provided in standard date format YYYY-MM-DD")
  }
  
  if (format == "long") {
    quarter_num <- lubridate::quarter(date)
    
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0("October to December ", 
                                as.character(lubridate::year(date) - 1)),
      quarter_num == 2 ~ paste0("January to March ",
                                as.character(lubridate::year(date))),
      quarter_num == 3 ~ paste0("April to June ",
                                as.character(lubridate::year(date))),
      quarter_num == 4 ~ paste0("July to September ",
                                as.character(lubridate::year(date)))))
  } else {
    quarter_num <- lubridate::quarter(date)
    
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0("Oct-Dec ", 
                                as.character(lubridate::year(date) - 1)),
      quarter_num == 2 ~ paste0("Jan-Mar ",
                                as.character(lubridate::year(date))),
      quarter_num == 3 ~ paste0("Apr-Jun ",
                                as.character(lubridate::year(date))),
      quarter_num == 4 ~ paste0("Jul-Sep ",
                                as.character(lubridate::year(date)))))
  }
}