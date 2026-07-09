#' Create age groups
#'
#' @description
#' `create_age_groups()` takes a numeric vector and assigns each age to the
#' appropriate age group.
#'
#' @param x a vector of numeric values
#' @param from `r lifecycle::badge("deprecated")` Use `breaks` instead.
#' @param to `r lifecycle::badge("deprecated")` Use `breaks` instead.
#' @param by `r lifecycle::badge("deprecated")` Use `breaks` instead.
#' @param as_factor The default behaviour is to return a character vector. Use
#'   `TRUE` to return a factor vector instead.
#' @param breaks a numeric vector of cut points defining the age groups. The
#'   default is `seq(0, 90, 5)`, which corresponds to the
#'   [European Standard Population](https://www.opendata.nhs.scot/dataset/standard-populations/resource/edee9731-daf7-4e0d-b525-e4c1469b8f69)
#'   age groups.
#'
#' @return A character vector, where each element is the age group for the
#' corresponding element in `x`. If `as_factor = TRUE`, a factor
#' vector is returned instead.
#'
#' @details
#' The `breaks` vector defines the cut points for the age groups. The final
#' age group will capture all ages equal to or greater than the last value in
#' `breaks`, labelled as `last+`. If the cut points are not evenly spaced, the
#' labels will reflect the actual width of each group.
#'
#' @examples
#' age <- c(54, 7, 77, 1, 26, 101)
#'
#' create_age_groups(age)
#' create_age_groups(age, breaks = seq(0, 80, 10))
#'
#' # Non-uniform age groups
#' create_age_groups(age, breaks = c(0, 18, 45, 65, 90))
#'
#' # Final group may start below the last break
#' create_age_groups(age, breaks = seq(0, 65, 10))
#'
#' # To get the output as a factor:
#' create_age_groups(age, as_factor = TRUE)
#' @export
create_age_groups <- function(
  x,
  from = lifecycle::deprecated(),
  to = lifecycle::deprecated(),
  by = lifecycle::deprecated(),
  as_factor = FALSE,
  breaks = seq(0, 90, 5)
) {
  if (!is.numeric(x)) {
    cli::cli_abort(
      "{.arg x} must be an {.cls integer} vector, not a {.cls {class(x)}} vector."
    )
  }
  if (any(x < 0, na.rm = TRUE)) {
    cli::cli_abort("{.arg x} cannot contain negative ages.")
  }
  if (!is.integer(x)) {
    x_int <- as.integer(x)

    if (any(x != x_int, na.rm = TRUE)) {
      cli::cli_warn(c(
        "!" = "{.arg x} contains non-whole number ages. All values will be truncated to integers.",
        "i" = "For example, an age of 17.9 will be labelled {.val 0-17}, despite being over 17."
      ))
    }
    x <- x_int
  }
  if (!is.logical(as_factor)) {
    cli::cli_abort(
      "{.arg as_factor} must be a {.cls logical}, not a {.cls {class(as_factor)}}."
    )
  }
  if (length(as_factor) != 1) {
    cli::cli_abort(
      "{.arg as_factor} must be length 1, not {length(as_factor)}."
    )
  }
  if (!is.numeric(breaks)) {
    cli::cli_abort(
      "{.arg breaks} must be a {.cls numeric} vector, not a {.cls {class(breaks)}} vector."
    )
  }
  if (length(breaks) <= 1) {
    cli::cli_abort(
      "{.arg breaks} must have at least 2 values, not {.val {length(breaks)}}."
    )
  }
  if (is.unsorted(breaks, strictly = TRUE)) {
    cli::cli_abort(
      "{.arg breaks} must be strictly increasing and contain no duplicates."
    )
  }

  if (
    lifecycle::is_present(from) ||
      lifecycle::is_present(to) ||
      lifecycle::is_present(by)
  ) {
    if (missing(breaks)) {
      lifecycle::deprecate_warn(
        when = "1.0.0",
        what = I("create_age_groups(from/to/by)"),
        with = "create_age_groups(breaks)"
      )

      # Fall back to defaults for any missing deprecated arguments
      if (!lifecycle::is_present(from)) {
        from <- 0
      }
      if (!lifecycle::is_present(to)) {
        to <- 90
      }
      if (!lifecycle::is_present(by)) {
        by <- 5
      }

      breaks <- seq(from, to, by)
    } else {
      cli::cli_abort(
        "{.arg from}, {.arg to} or {.arg by} should no longer be used, use {.arg breaks} only."
      )
    }
  }

  breaks <- c(breaks, Inf)
  breaks <- sort(unique(breaks))

  # Create labels based on consecutive values in breaks
  labels <- paste0(utils::head(breaks, -1), "-", utils::tail(breaks, -1) - 1)

  # Reformat label for last value
  labels <- gsub("-Inf", "+", labels)

  agegroup <- cut(
    x,
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
