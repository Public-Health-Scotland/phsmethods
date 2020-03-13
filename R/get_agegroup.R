#' Create age groups
#'
#' @description
#' A wrapper for \code{\link[base]{cut}} tailored for creating age groups. For
#' each value of integer \code{x}, what age group does it fall into, based on a
#' given set of age group breakpoints.
#'
#' @param x a vector of numeric values
#' @param breaks a vector of numeric values to be used as breakpoints. These are
#'   sorted before use by the function. The defualt value is the agegroups of the
#'   \href{https://www.opendata.nhs.scot/dataset/standard-populations/resource/edee9731-daf7-4e0d-b525-e4c1469b8f69}{European Standard Population}.
#' @param include_zero If \code{TRUE}, zero will be appended to the start of the
#'   breakpoints (unless it is already included). If \code{FALSE}, the function
#'   will return \code{NA} for any value less than the smallest breakpoint.
#' @param include_inf If \code{TRUE}, \code{Inf} will be appended to the end of
#'   the breakpoints (unless it is already included). If \code{FALSE}, the
#'   function return \code{NA} for any value greater than or equal to the
#'   largest breakpoint.
#' @param as_factor The default behaviour is to return a factor vector. Use
#'   \code{FALSE} to return a character vector instead.
#' @param sep a character string to seperate the start and end year in each age
#'   group label. Not \code{\link[base]{NA_character_}}.
#' @param above.char a character string to append to the final (top) age group
#'   if it extends to infinity.
#' @param from,to,by start, end and increment values for a sequence of age
#'   breaks. These are passed to \code{\link[base]{seq}} to generate the breaks.
#' @param ... further arguments passed to \code{get_agegroup()}
#'
#' @return A factor vector, where each element corresponds to the same element
#'   in \code{x}. If \code{as_factor = FALSE} a character vector is returned
#'   instead.
#'
#' @details
#' The breakpoints are used to create distinct contiguous age groups which cover
#' the whole range between the smallest and largest points (or zero and
#' \code{Inf} depending on which options are used).
#'
#' \code{get_agegroup_seq} provides an alternative way of specifing the age
#' groupings using \code{\link[base]{seq}} arguments.
#'
#' @note
#' Only contiguous age groups can be created with a single call of
#' \code{get_agegroup}. To create overlapping age groups (e.g. 65+ and 75+) or
#' age groups with gaps (e.g. 0-17, 65+, but nothing in between) it will be
#' necessary to do some additional work or use additional calls of this
#' function.
#'
#' @export
#' @examples
#' age <- c(54, 7, 77, 1, 26, 58, 46, 79, 31, 85, 13, 101)
#' get_agegroup(age)
#'
#' get_agegroup(age, c(5, 15, 25, 45, 65, 75, 85))
#'
#' get_agegroup_seq(age, from=0, to=90, by=10)
#'
#' #If \code{include_zero} or \code{include_inf} are set to \code{FALSE}, values
#' #outside of the range will return \code{NA}:
#' get_agegroup(age, c(5, 15, 25, 45, 65, 75, 85), include_zero = FALSE)
#'
#' #Other functions can be used to specify the breaks, e.g. \code\link[base]{seq}:
#' get_agegroup(age, seq(0, 100, by = 10))
#'
#' #To get the output as a vector of character:
#' get_agegroup(age, as_factor = FALSE)

get_agegroup <- function(x,
                         breaks = c(seq(0, 90, by = 5), Inf),
                         include_zero = TRUE,
                         include_inf = TRUE,
                         as_factor = TRUE,
                         sep = "-",
                         above.char = "+") {

  if(is.null(x))
    stop("argument 'x' is missing or NULL, with no default")

  if(!is.numeric(x)){
    warning("Non-numeric values found in 'x'. Attempting to convert to numeric")
    x <- as.numeric(x)
  }

  ### Handling for breaks vector ----
  if(!is.numeric(breaks) | any(is.na(breaks)) | any(is.nan(breaks)))
    stop("non-numeric value found in 'breaks'")

  if(any(breaks < 0))
    warning("Negative values in breaks. Check output carefully")

  # If include_zero is true (default) and last break value is not already 0
  # add 0 to the break vector
  if(include_zero & !(0 %in% breaks))
    breaks <- c(0, breaks)

  # If include_inf is true (default) and last break value is not already Inf
  # add Inf to the break vector
  if(include_inf & !(Inf %in% breaks))
    breaks <- c(breaks, Inf)

  # Sort breaks so the limits are in the correct order
  breaks <- sort(unique(breaks))

  # If there's only one break value, add a second value so cut function will run
  if(length(breaks) == 1)
    breaks <- c(breaks, breaks+1)

  ### Creation of labels list ----
  # Create labels based on consecutive values in breaks
  labels <- paste(utils::head(breaks, -1), utils::tail(breaks,-1)-1, sep=sep)

  # Reformat label for last value (if appropriate)
  labels <- gsub(paste0(sep,"Inf"), above.char, labels)

  # Reformat labels for single values (if appropriate)
  labels[utils::head(breaks, -1) == utils::tail(breaks, -1)-1] <-
   utils::head(breaks, -1)[utils::head(breaks, -1) == utils::tail(breaks, -1)-1]

  if(any(trunc(breaks) != breaks)){
    warning("Non-integer values found in breaks. Using ranges as labels")
    labels = NULL
  }

  ### Age grouping ----
  # Create age groups
  agegroup <- cut(x,
                  breaks = breaks,
                  labels = labels,
                  right = FALSE,
                  ordered_result = TRUE)

  if(as_factor == F)
    agegroup <- as.character(agegroup)

  return(agegroup)
}

#' @rdname get_agegroup
#' @export
get_agegroup_seq <- function(x, from = 0, to = 90, by = 5, ...){

  # Including breaks in dots could cause odd behaviour, so check for this
  if("breaks" %in% names(list(...)))
    stop(paste0("unused argument (breaks)"))

  get_agegroup(x, breaks=seq(from, to, by), ...)
}
