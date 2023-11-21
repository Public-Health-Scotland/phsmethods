#' Create age groups
#'
#' @description
#' `create_age_groups()` takes a numeric vector and assigns each age to the
#' appropriate age group.
#'
#' @param x a vector of numeric values
#' @param from the start of the smallest age group. The default is `0`.
#' @param to the end point of the age groups. The default is `90`.
#' @param by the size of the age groups. The default is `5`.
#' @param as_factor The default behaviour is to return a character vector. Use
#' `TRUE` to return a factor vector instead.
#'
#' @return A character vector, where each element is the age group for the
#' corresponding element in `x`. If `as_factor = TRUE`, a factor
#' vector is returned instead.
#'
#' @details
#' The `from`, `to` and `by` values are used to create distinct
#' age groups. `from` dictates the starting age of the lowest age group,
#' and `by` indicates how wide each group should be. `to` stipulates
#' the cut-off point at which all ages equal to or greater than this value
#' should be categorised together in a `to+` group. If the specified value
#' of `to` is not a multiple of `by`, the value of `to` is
#' rounded down to the nearest multiple of `by`.
#'
#' The default values of `from`, `to` and `by` correspond to the
#' [European Standard Population](https://www.opendata.nhs.scot/dataset/standard-populations/resource/edee9731-daf7-4e0d-b525-e4c1469b8f69)
#' age groups.
#'
#' @examples
#' age <- c(54, 7, 77, 1, 26, 101)
#'
#' create_age_groups(age)
#' create_age_groups(age, from = 0, to = 80, by = 10)
#'
#' # Final group may start below 'to'
#' create_age_groups(age, from = 0, to = 65, by = 10)
#'
#' # To get the output as a factor:
#' create_age_groups(age, as_factor = TRUE)
#' @export
create_age_groups <- function(x,
                              from = 0,
                              to = 90,
                              by = 5,
                              as_factor = FALSE) {
  breaks <- seq(from, to, by)
  breaks <- c(breaks, Inf)
  breaks <- sort(unique(breaks))

  # Create labels based on consecutive values in breaks
  labels <- paste0(utils::head(breaks, -1), "-", utils::tail(breaks, -1) - 1)

  # Reformat label for last value
  labels <- gsub("-Inf", "+", labels)

  agegroup <- cut(x,
    breaks = breaks,
    labels = labels,
    right = FALSE,
    ordered_result = TRUE
  )

  if (as_factor == FALSE) {
    agegroup <- as.character(agegroup)
  }

  agegroup
}
