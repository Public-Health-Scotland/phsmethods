#' Percentages
#'
#' @description
#'
#' `percent` is a lightweight S3 class allowing for pretty
#' printing of proportions as percentages. \cr
#' It aims to remove the need for creating character vectors of percentages.
#'
#' @param x `[numeric]` vector of proportions.
#' @param digits `[numeric(1)]` - The number of digits that will be used for
#' formatting. This is by default 2 and is applied whenever `format()`,
#'  `as.character()` and `print()` are called. This can also be controlled
#' directly via `format()`.
#'
#' @returns
#' An object of class `percent`.
#'
#' @details
#'
#' ### Rounding
#'
#' The rounding for percent vectors differs to that of base R rounding,
#' namely in that halves are rounded up instead of rounded to even.
#' This means that `round(x)` will round the percent vector `x` using
#' halves-up rounding (like in the janitor package).
#'
#' ### Formatting
#'
#' By default all percentages are formatted to 2 decimal places which can be
#' overwritten using `format()` or using `round()` if your required digits are
#' less than 2. It's worth noting that the digits argument in
#' `format.percent` uses decimal rounding instead of the usual
#' significant digit rounding that `format.default()` uses.
#'
#' @examples
#' # Convert proportions to percentages
#' as_percent(seq(0, 1, 0.1))
#'
#' # You can use round() as usual
#' p <- as_percent(15.56 / 100)
#' round(p)
#' round(p, digits = 1)
#'
#' p2 <- as_percent(0.0005)
#' signif(p2, 2)
#' floor(p2)
#' ceiling(p2)
#'
#' # We can do basic math operations as usual
#'
#' # Order of operations doesn't matter
#' 10 * as_percent(c(0, 0.5, 2))
#' as_percent(c(0, 0.5, 2)) * 10
#'
#' as_percent(0.1) + as_percent(0.2)
#'
#' # Formatting options
#' format(as_percent(2.674 / 100), digits = 2, symbol = " (%)")
#' # Prints nicely in data frames (and tibbles)
#' library(dplyr)
#' starwars %>%
#'   count(eye_color) %>%
#'   mutate(perc = as_percent(n/sum(n))) %>%
#'   arrange(desc(perc))  %>% # We can do numeric sorting with percent vectors
#'   mutate(perc_rounded = round(perc))
#' @rdname percent
#' @export
as_percent <- function(x, digits = 2){
  if (inherits(x, "percent")){
    return(new_percent(x, digits))
  }
  if (!inherits(x, c("numeric", "integer", "logical"))){
    cli::cli_abort("{.arg x} must be a {.cls numeric} vector, not a {.cls {class(x)}} vector.")
  }
  new_percent(as.numeric(x), digits = digits)
}
#' @rdname percent
#' @export
NA_percent_ <- structure(NA_real_, class = "percent", .digits = 2)

new_percent <- function(x, digits = 2){
  class(x) <- "percent"
  attr(x, ".digits") <- digits
  x
}
get_perc_digits <- function(x){
  attr(x, ".digits") %||% 2
}
round_half_up <- function(x, digits = 0){
  if (is.null(digits) || (length(digits) == 1 && digits == Inf)){
    return(x)
  }
  trunc(
    abs(x) * 10^digits + 0.5 +
      sqrt(.Machine$double.eps)
  ) /
    10^digits * sign(x)
}
signif_half_up <- function(x, digits = 6){
  if (is.null(digits) || (length(digits) == 1 && digits == Inf)){
    return(x)
  }
  round_half_up(x, digits - ceiling(log10(abs(x))))
}

#' @export
as.character.percent <- function(x, digits = get_perc_digits(x), ...){
  out <- stringr::str_c(
    format(unclass(round(x, digits) * 100), trim = TRUE, digits = NULL),
    "%"
  )
  out[is.na(x)] <- NA
  out
}

#' @export
format.percent <- function(x, symbol = "%", trim = TRUE,
                           digits = get_perc_digits(x),
                           ...){
  out <- stringr::str_c(
    format(unclass(round(x, digits) * 100), trim = trim, digits = NULL, ...),
    symbol
  )
  out[is.na(x)] <- NA
  names(out) <- names(x)
  out
}

#' @export
print.percent <- function(x, max = NULL, trim = TRUE,
                          digits = get_perc_digits(x),
                          ...){
  out <- x
  N <- length(out)
  if (N == 0){
    print("as_percent(numeric())")
    return(invisible(x))
  }
  if (is.null(max)) {
    max <- getOption("max.print", 9999L)
  }
  suffix <- character()
  max <- min(max, N)
  if (max < N) {
    out <- out[seq_len(max)]
    suffix <- stringr::str_c(
      " [ reached 'max' / getOption(\"max.print\") -- omitted",
      N - max, "entries ]\n",
      sep = " "
    )
  }
  print(format(out, trim = trim, digits = digits), ...)
  cat(suffix)
  invisible(x)
}

#' @export
`[.percent` <- function(x, ..., drop = TRUE){
  cl <- oldClass(x)
  class(x) <- NULL
  out <- NextMethod("[")
  class(out) <- cl
  attr(out, ".digits") <- get_perc_digits(x)
  out
}

#' @export
unique.percent <- function(x, incomparables = FALSE, ...){
  cl <- oldClass(x)
  class(x) <- NULL
  out <- NextMethod("unique")
  class(out) <- cl
  attr(out, ".digits") <- get_perc_digits(x)
  out
}

#' @export
rep.percent <- function(x, ...){
  cl <- oldClass(x)
  class(x) <- NULL
  out <- NextMethod("rep")
  class(out) <- cl
  attr(out, ".digits") <- get_perc_digits(x)
  out
}

#' @export
Math.percent <- function(x, ...){
  rounding_math <- switch(.Generic,
                          `floor` =,
                          `ceiling` =,
                          `trunc` =,
                          `round` =,
                          `signif` = TRUE, FALSE)
  x <- unclass(x)

  if (switch(.Generic, `sign` = TRUE, FALSE)){
    NextMethod(.Generic)
  } else if (rounding_math){
    x <- x * 100
    if (.Generic == "round"){
      out <- do.call(round_half_up, list(x, ...))
    } else if (.Generic == "signif"){
      out <- do.call(signif_half_up, list(x, ...))
    } else {
      out <- NextMethod(.Generic)
    }
    new_percent(out / 100, get_perc_digits(x))
  } else {
    out <- NextMethod(.Generic)
    new_percent(out, get_perc_digits(x))
  }
}
#' @export
Summary.percent <- function(x, ...){
  summary_math <- switch(.Generic,
                          `sum` =,
                          `prod` =,
                          `min` =,
                          `max` =,
                          `range` = TRUE, FALSE)
  x <- unclass(x)
  out <- NextMethod(.Generic)
  if (summary_math){
    out <- new_percent(out, get_perc_digits(x))
  }
  out
}
#' @export
mean.percent <- function(x, ...){
  new_percent(mean(unclass(x), ...), get_perc_digits(x))
}
