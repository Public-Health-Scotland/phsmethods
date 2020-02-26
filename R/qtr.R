#' @title Assign a date to a quarter
#'
#' @description
#'
#' The qtr functions take a date input and calculate the relevant
#' quarter-related value from it. They all return the year as part of this
#' value.
#'
#' \itemize{
#' \item \code{qtr} returns the current quarter.
#'
#' \item \code{qtr_end} returns the last month in the quarter.
#' 
#' \item \code{qtr_start} returns the first month in the quarter.
#'
#' \item \code{qtr_next} returns the next quarter.
#'
#' \item \code{qtr_prev} returns the previous quarter.
#' }
#'
#' @details Quarters are defined as:
#'
#' \itemize{
#' \item January to March (Jan-Mar, Q1)
#' \item April to June (Apr-Jun, Q2)
#' \item July to September (Jul-Sep, Q3)
#' \item October to December (Oct-Dec, Q4)
#' }
#'
#' @param date A date supplied with \code{Date} class.
#' @param format A \code{character} string specifying the format the quarter
#' should be displayed in. Valid options are `long` (January to March 2018) and
#' `short` (Jan-Mar 2018). The default is `long`.
#'
#' @examples
#' x <- lubridate::dmy(c(26032012, 04052012, 23092012))
#'
#' qtr(x)
#'
#' qtr_end(x, format = "short")
#'
#' qtr_next(x)
#'
#' qtr_prev(x, format = "short")

#' @export
#' @rdname qtr
qtr <- function(date, format = c("long", "short", "open")) {
  
  format <- match.arg(format)
  
  if (!inherits(date, "Date")) {
    stop("The input must have Date class.")
  }
  
  quarter_num <- lubridate::quarter(date)
  
  if (format == "long") {
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0("January to March ",
                                lubridate::year(date)),
      quarter_num == 2 ~ paste0("April to June ",
                                lubridate::year(date)),
      quarter_num == 3 ~ paste0("July to September ",
                                lubridate::year(date)),
      quarter_num == 4 ~ paste0("October to December ",
                                lubridate::year(date))))
  } else if(format == "open"){
    return(paste0(lubridate::year(date), "Q", quarter_num))
  } else{
    
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0("Jan-Mar ",
                                lubridate::year(date)),
      quarter_num == 2 ~ paste0("Apr-Jun ",
                                lubridate::year(date)),
      quarter_num == 3 ~ paste0("Jul-Sep ",
                                lubridate::year(date)),
      quarter_num == 4 ~ paste0("Oct-Dec ",
                                lubridate::year(date))))
  } 
}

#' @export
#' @rdname qtr
qtr_end <- function(date, format = c("long", "short", "open")) {
  
  format <- match.arg(format)
  
  if (!inherits(date, "Date")) {
    stop("The input must have Date class.")
  }
  
  quarter_num <- lubridate::quarter(date)
  
  if (format == "long") {
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0("March ",
                                lubridate::year(date)),
      quarter_num == 2 ~ paste0("June ",
                                lubridate::year(date)),
      quarter_num == 3 ~ paste0("September ",
                                lubridate::year(date)),
      quarter_num == 4 ~ paste0("December ",
                                lubridate::year(date))))
  }
  else if(format == "open"){
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0(lubridate::year(date), "03"),
      quarter_num == 2 ~ paste0(lubridate::year(date), "06"),
      quarter_num == 3 ~ paste0(lubridate::year(date), "09"),
      quarter_num == 4 ~ paste0(lubridate::year(date), "12")))
  } else{
    
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0("Mar ",
                                lubridate::year(date)),
      quarter_num == 2 ~ paste0("Jun ",
                                lubridate::year(date)),
      quarter_num == 3 ~ paste0("Sep ",
                                lubridate::year(date)),
      quarter_num == 4 ~ paste0("Dec ",
                                lubridate::year(date))))
  }
}

#' @export
#' @rdname qtr
qtr_start <- function(date, format = c("long", "short", "open")) {
  
  format <- match.arg(format)
  
  if (!inherits(date, "Date")) {
    stop("The input must have Date class.")
  }
  
  quarter_num <- lubridate::quarter(date)
  
  if (format == "long") {
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0("January ",
                                lubridate::year(date)),
      quarter_num == 2 ~ paste0("April ",
                                lubridate::year(date)),
      quarter_num == 3 ~ paste0("July ",
                                lubridate::year(date)),
      quarter_num == 4 ~ paste0("October ",
                                lubridate::year(date))))
  }
  else if(format == "open"){
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0(lubridate::year(date), "01"),
      quarter_num == 2 ~ paste0(lubridate::year(date), "04"),
      quarter_num == 3 ~ paste0(lubridate::year(date), "07"),
      quarter_num == 4 ~ paste0(lubridate::year(date), "10")))
  } else{
    
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0("Jan ",
                                lubridate::year(date)),
      quarter_num == 2 ~ paste0("Apr ",
                                lubridate::year(date)),
      quarter_num == 3 ~ paste0("Jul ",
                                lubridate::year(date)),
      quarter_num == 4 ~ paste0("Oct ",
                                lubridate::year(date))))
  }
}

#' @export
#' @rdname qtr
qtr_next <- function(date, format = c("long", "short", "open")) {
  
  format <- match.arg(format)
  
  if (!inherits(date, "Date")) {
    stop("The input must have Date class.")
  }
  
  quarter_num <- lubridate::quarter(date)
  
  if (format == "long") {
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0("April to June ",
                                lubridate::year(date)),
      quarter_num == 2 ~ paste0("July to September ",
                                lubridate::year(date)),
      quarter_num == 3 ~ paste0("October to December ",
                                lubridate::year(date)),
      quarter_num == 4 ~ paste0("January to March ",
                                lubridate::year(date) + 1)))
  } else if(format == "open"){
    if(quarter_num == 4){
      return(paste0(lubridate::year(date) + 1, "Q1"))
    }
    else{
      return(paste0(lubridate::year(date), "Q", as.character(quarter_num + 1)))  
    }
    # return(dplyr::if_else(quarter_num == 4, paste0(lubridate::year(date), "Q", 1), paste0(lubridate::year(date), "Q", quarter_num + 1))
  } else{
    
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0("Apr-Jun ",
                                lubridate::year(date)),
      quarter_num == 2 ~ paste0("Jul-Sep ",
                                lubridate::year(date)),
      quarter_num == 3 ~ paste0("Oct-Dec ",
                                lubridate::year(date)),
      quarter_num == 4 ~ paste0("Jan-Mar ",
                                lubridate::year(date) + 1)))
  }
}

#' @export
#' @rdname qtr
qtr_prev <- function(date, format = c("long", "short", "open")) {
  
  format <- match.arg(format)
  
  if (!inherits(date, "Date")) {
    stop("The input must have Date class.")
  }
  
  quarter_num <- lubridate::quarter(date)
  
  if (format == "long") {
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0("October to December ",
                                lubridate::year(date) - 1),
      quarter_num == 2 ~ paste0("January to March ",
                                lubridate::year(date)),
      quarter_num == 3 ~ paste0("April to June ",
                                lubridate::year(date)),
      quarter_num == 4 ~ paste0("July to September ",
                                lubridate::year(date))))
  } else if(format == "open"){
    if(quarter_num == 1){
      return(paste0(lubridate::year(date) - 1, "Q4"))
    } else{
      return(paste0(lubridate::year(date), "Q", as.character(quarter_num - 1)))
    }
  } else{
    
    return(dplyr::case_when(
      quarter_num == 1 ~ paste0("Oct-Dec ",
                                lubridate::year(date) - 1),
      quarter_num == 2 ~ paste0("Jan-Mar ",
                                lubridate::year(date)),
      quarter_num == 3 ~ paste0("Apr-Jun ",
                                lubridate::year(date)),
      quarter_num == 4 ~ paste0("Jul-Sep ",
                                lubridate::year(date))))
  } 
}
