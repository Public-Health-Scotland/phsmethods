#' Performs checks if elements have classes specified by 'target_classes' and prints out each element which is lacking the specified class or is NULL.
#' Throws an exception if one element does not pass the checks.
#' Element must have AT LEAST ONE of the specified classes to pass.
#' @param elements a list object containing element_name=element pairs for each element. Element names must be provided or else they will be ignored.
#' @param target_classes array of classes (string).

make_inheritance_checks <- function(elements, target_classes) {
  caller_func <- deparse(sys.calls()[[sys.nframe()-1]])
  failures <- lapply(names(elements), FUN = function(element) {
    if (is.null(elements[[element]])) {
      return(paste0("Element ", "'", element, "'", " is null."))
    }
    if (!inherits(elements[[element]], target_classes)) {
      return(paste0("Argument: ", "'", element, "'", " must have class: ", paste0(target_classes, collapse = " or ")))
    }
  })
  names(failures) <- names(elements)
  failures <- Filter(function(x) !is.null(x), failures)
  if (!all(sapply(failures, is.null))) {
    failures_out <- sapply(names(failures), FUN = function(element) {
      if(!is.null(failures[[element]])) {
        return(paste0(paste0(failures[[element]], collapse = "\n"), "\nClasses of ", "'", element, "': ", class(elements[[element]]), "\n"))
      }
    })
    stop(cat(paste0("[make_inheritance_checks] failed in function call: ", "'", caller_func, "'", ":\n", paste0(failures_out, collapse = "\n"))))
  }
}
