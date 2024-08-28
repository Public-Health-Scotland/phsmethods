#' Check that a set of arguments inherits from a set of classes
#' Throws an exception if one argument does not pass the checks.
#' Argument must have AT LEAST ONE of the specified classes to pass.
#' @param arguments a list object containing argument_name=argument pairs for
#' each argument. Argument names must be provided or else they will be ignored.
#' @param target_classes character vector of the classes to check for.
#' @param ignore_null boolean. Indicates whether to ignore arguments with value
#' NULL (TRUE) or to throw an exception (FALSE). Default = TRUE.
#' @internal
#' @noRd
make_inheritance_checks <- function(arguments,
                                    target_classes,
                                    ignore_null = TRUE) {
  caller_func <- ifelse(length(sys.calls()) > 1,
    deparse(sys.calls()[[sys.nframe() - 1]]),
    NA
  )

  if (!is.list(arguments)) {
    cli::cli_abort(
      "make_inheritance_checks {cli::col_red('failed')}: 'arguments' must be a list."
    )
  }

  failures <- lapply(names(arguments), FUN = function(argument) {
    if (is.null(arguments[[argument]])) {
      if (ignore_null) {
        return(NULL)
      } else {
        return(
          stringr::str_glue(
            "{.arg {% argument %}} is {.val NULL} but must be {cli::qty(target_classes)} {?any of }{.cls {target_classes}}.",
            .open = "{%",
            .close = "%}"
          )
        )
      }
    }
    if (!inherits(arguments[[argument]], target_classes) & !is.null(arguments[[argument]])) {
      return(stringr::str_glue("{.arg {% argument %}} has class {.cls {% class(arguments[[argument]]) %}}, but must be {cli::qty(target_classes)} {?any of }{.cls {target_classes}}.", .open = "{%", .close = "%}"))
    }
  })
  names(failures) <- names(arguments)
  failures <- Filter(function(x) !is.null(x), failures)
  if (!all(sapply(failures, is.null))) {
    failures_out <- sapply(names(failures), FUN = function(argument) {
      if (!is.null(failures[[argument]])) {
        return(failures[[argument]])
      }
    })

    if (is.na(caller_func)) {
      cli::cli_abort(c(
        "x" = "make_inheritance_checks {cli::col_red('failed')}, check the arguments:",
        failures_out
      ))
    } else {
      cli::cli_abort(c(
        "x" = "{.strong {.code {caller_func}}} {cli::col_red('failed')}, check the arguments:",
        failures_out
      ))
    }
  }
  return(NULL)
}
