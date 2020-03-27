#' Create age groups
#'
#' @description
#' age_group() takes a numeric vector and assigns each age to the appropriate
#' age group.
#'
#' @param x a vector of numeric values
#' @param from the start of the smallest age group. The default is \code{0}.
#' @param to the end point of the age groups. The default is \code{90}.
#' @param by the size of the age groups. The default is \code{5}.
#' @param as_factor The default behaviour is to return a character vector. Use
#'   \code{TRUE} to return a factor vector instead.
#'
#' @return A character vector, where each element is the age group for the
#'   corresponding element in \code{x}. If \code{as_factor = TRUE} a factor
#'   vector is returned instead.
#'
#' @details
#' The \code{from}, \code{to} and \code{by} values are used to create distinct
#' age groups. \code{from} dictates the starting age of the lowest age group,
#' and \code{by} indicates how wide each group should be. \code{to} stipulates
#' the cut-off point at which all ages equal to or greater than this value
#' should be categorised together in a \code{to+} group. If the specified value
#' of \code{to} is not a multiple of \code{by}, the value of \code{to} is
#' rounded down to the nearest multiple of \code{by}.
#'
#' The default values of \code{from}, \code{to} and \code{by} correspond to the
#' \href{https://www.opendata.nhs.scot/dataset/standard-populations/resource/
#' edee9731-daf7-4e0d-b525-e4c1469b8f69}{European Standard Population} age
#' groups.
#'
#' @examples
#' age <- c(54, 7, 77, 1, 26, 101)
#'
#' age_group(age)
#' age_group(age, from = 0, to = 80, by = 10)
#'
#' # Final group may start below 'to'
#' age_group(age, from = 0, to = 65, by = 10)
#'
#' # To get the output as a factor:
#' age_group(age, as_factor = TRUE)
#'
#' @export
age_group <- function(x,
                      from = 0,
                      to = 90,
                      by = 5,
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

  if(as_factor == FALSE)
    agegroup <- as.character(agegroup)

  return(agegroup)
}
