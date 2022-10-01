#' Performs checks if arguments have classes specified by 'target_classes' and prints out each argument which is lacking the specified class or is NULL.
#' Throws an exception if one argument does not pass the checks.
#' Argument must have AT LEAST ONE of the specified classes to pass.
#' @param arguments a list object containing argument_name=argument pairs for each argument. Argument names must be provided or else they will be ignored.
#' @param target_classes array of classes (string).

make_inheritance_checks <- function(arguments, target_classes, ignore_null = T) {
  caller_func <- deparse(sys.calls()[[sys.nframe() - 1]])
  failures <- lapply(names(arguments), FUN = function(argument) {
    if (is.null(arguments[[argument]])) {
      if (ignore_null) {
        cli_alert_info("{.fn make_inheritance_checks}: Argument {.arg { argument }} is {.val NULL}, but argument {.strong {.code ignore_null = TRUE}}.")
        return(NULL)
      } else {
        return(glue("Argument {.arg {.strong {% argument %}}} is {.val NULL} and argument {.strong {.code ignore_null = FALSE}}", .open = "{%", .close = "%}"))
      }
    }
    if (!inherits(arguments[[argument]], target_classes) & !is.null(arguments[[argument]])) {
      return(glue("Argument {.arg {.strong {% argument %}}} has class {.cls {% class(arguments[[argument]]) %}}, but must have any of classes {.cls {target_classes}}", .open = "{%", .close = "%}"))
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
    cli_rule()
    cli_abort(c(
      "x" = "inheritance checks {col_red('failed')} in function call: {.strong {.code {caller_func}}} due to following errors:",
      failures_out
    ))
  }
  cli_alert_success("inheritance checks {col_green('passed')}")
}
