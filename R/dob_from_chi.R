#' @title Extract Date of Birth (DoB) from the CHI number
#'
#' @description `dob_from_chi` takes a CHI number or a vector of CHI numbers
#' and returns the Date of Birth (DoB) as implied by the CHI number(s). If the
#' DoB is ambiguous it will return NA.
#'
#' @param chi_number a CHI number or a vector of CHI numbers with `character`
#' class.
#' @param min_date,max_date optional min and/or max dates that the
#' DoB could take as the century needs to be guessed. Must be either length 1
#' for a 'fixed' date or the same length as `chi_number` for a date
#' per CHI number. `min_date` can be date based on common sense in the dataset,
#' whilst `max_date` can be date when an event happens such as discharge date.
#' @param chi_check logical, optionally skip checking the CHI for validity which
#' will be faster but should only be used if you have previously checked the
#' CHI(s). The default (TRUE) will check the CHI numbers.
#'
#' @return a date vector of DoB. It will be the same length as `chi_number`.
#' @export
#'
#' @examples
#' dob_from_chi("0101336489")
#'
#' library(tibble)
#' library(dplyr)
#' data <- tibble(chi = c(
#'   "0101336489",
#'   "0101405073",
#'   "0101625707"
#' ), adm_date = as.Date(c(
#'   "1950-01-01",
#'   "2000-01-01",
#'   "2020-01-01"
#' )))
#'
#' data %>%
#'   mutate(chi_dob = dob_from_chi(chi))
#'
#' data %>%
#'   mutate(chi_dob = dob_from_chi(chi,
#'     min_date = as.Date("1930-01-01"),
#'     max_date = adm_date
#'   ))
dob_from_chi <- function(
  chi_number,
  min_date = NULL,
  max_date = NULL,
  chi_check = TRUE
) {
  # Do type checking on the params
  if (!inherits(chi_number, "character")) {
    cli::cli_abort(
      "{.arg chi_number} must be a {.cls character} vector, not a {.cls {class(chi_number)}} vector."
    )
  }

  make_inheritance_checks(
    list(min_date = min_date, max_date = max_date),
    target_classes = c("Date", "POSIXct")
  )

  if (is.null(max_date)) {
    # Default the max_date to today (person can't be born after today)
    max_date <- Sys.Date()
  } else if (anyNA(max_date)) {
    # Fill in today's date to where max_date is missing
    max_date[is.na(max_date)] <- Sys.Date()
  }

  n_chis <- length(chi_number)

  if (is.null(min_date)) {
    # Default the min_date to 1 Jan 1900
    min_date <- as.Date("1900-01-01")
  } else if (anyNA(min_date)) {
    # Fill in 1 Jan 1900 where min_date is missing
    min_date[is.na(min_date)] <- as.Date("1900-01-01")
  }

  if (length(min_date) != 1L) {
    if (n_chis != 1L && n_chis != length(min_date)) {
      cli::cli_abort(
        "{.arg min_date} must be size {length(chi_number)} (the same as {.arg chi_number}) not {length(min_date)}."
      )
    } else if (n_chis == 1L) {
      cli::cli_abort(
        "{.arg min_date} must be size 1 (the same as {.arg chi_number}) not {length(min_date)}."
      )
    }
  }

  if (length(max_date) != 1L) {
    if (n_chis != 1L && n_chis != length(max_date)) {
      cli::cli_abort(
        "{.arg max_date} must be size {length(chi_number)} (the same as {.arg chi_number}) not {length(max_date)}."
      )
    } else if (n_chis == 1L) {
      cli::cli_abort(
        "{.arg max_date} must be size 1 (the same as {.arg chi_number}) not {length(max_date)}."
      )
    }
  }

  # min and max date are in a reasonable range
  if (any(max_date < min_date)) {
    cli::cli_abort(
      "{.arg max_date}, must always be greater than or equal to {.arg min_date}."
    )
  }

  if (any(max_date > Sys.Date())) {
    # max_date should not be a future date
    to_replace <- max_date > Sys.Date()
    max_date[to_replace] <- Sys.Date()
    cli::cli_warn(
      c(
        "!" = "Any {.arg max_date} values which are in the future will be set to today: {.val {Sys.Date()}}."
      )
    )
  }

  na_count <- sum(is.na(chi_number))

  guess_dob <- cpp_dob_from_chi(chi_number, min_date, max_date)

  new_na_count <- sum(is.na(guess_dob)) - na_count

  if (new_na_count > 0) {
    message <- c(
      "!" = "{format(new_na_count, big.mark = ',')}{cli::qty(new_na_count)} CHI number{?s} produced {?an/} ambiguous date{?s} and will be given {.val NA} for {?its/their} Date{?s} of Birth."
    )

    # If the CHIs haven't been checked, note that this could be the reason
    if (!chi_check) {
      message <- append(
        message,
        c(
          "i" = "This could be because of invalid CHIs, use {.arg chi_check} to automatically check."
        )
      )
    }

    # Check if we're being called from age_from_chi
    call_context <- rlang::caller_call()
    from_age_function <- !is.null(call_context) &&
      "age_from_chi" %in% as.character(call_context)

    if (from_age_function) {
      cli::cli_inform(append(
        message,
        c(
          "v" = "Try different values for {.arg min_age} and/or {.arg max_age}."
        )
      ))
    } else {
      cli::cli_inform(append(
        message,
        c(
          "v" = "Try different values for {.arg min_date} and/or {.arg max_date}."
        )
      ))
    }
  }

  return(guess_dob)
}
