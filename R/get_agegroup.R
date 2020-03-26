#' Create age groups
#'
#' @description
#' A wrapper for \code{\link[base]{cut}} tailored for creating age groups. For
#' each value of integer \code{x}, what age group does it fall into.
#'
#' @param x a vector of numeric values
#' @param from,to,by start, end and increment values for a sequence of age
#'   groups.
#' @param as_factor The default behaviour is to return a character vector. Use
#'   \code{TRUE} to return a factor vector instead.
#'
#' @return A character vector, where each element is the age group for the
#'   corresponding element in \code{x}. If \code{as_factor = FALSE} a factor
#'   vector is returned instead.
#'
#' @details
#' The \code{from},\code{to} and \code{by} are used to create distinct age
#' groups \code{from-from+by}, ..., up to \code{to+}, or a value less than
#' \code{to} if \code{to} is not an exact multiple. The dafault values provide
#' the standard five year age groups.
#'
#' @export
#' @examples
#' age <- c(54, 7, 77, 1, 26, 101)
#'
#' age_group(age)
#' age_group(age, 0, 80, 10)
#'
#' #Final group may start below 'to'
#' age_group(age, 0, 65, 10)
#'
#' #To get the output as a factor:
#' age_group(age, as_factor = TRUE)
#'

age_group <- function(x, from = 0, to = 90, by = 5,
                      as_factor = FALSE) {

  breaks <- seq(from, to, by)
  breaks <- c(breaks, Inf)
  breaks <- sort(unique(breaks))

  # Create labels based on consecutive values in breaks
  labels <- paste0(utils::head(breaks, -1), "-", utils::tail(breaks,-1) - 1)

  # Reformat label for last value
  labels <- gsub("-Inf", "+", labels)

  agegroup <- cut(as.numeric(x),
                  breaks = breaks,
                  labels = labels,
                  right = FALSE,
                  ordered_result = TRUE)

  if(as_factor == F)
    agegroup <- as.character(agegroup)

  return(agegroup)
}
