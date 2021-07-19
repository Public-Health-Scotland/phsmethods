#' Get Open Data resources from a dataset
#'
#' @param dataset_name name of the dataset as found on \href{https://www.opendata.nhs.scot/}{NHS Open Data platform}
#' @param max_resources (optional) the maximum number of resources
#' to return, use for testing code,
#' it will retunr the n latest resources
#' @param rows (optional) specify the max number of rows to return for each resource
#' use this when testing code to reduce the size of the request
#' it will default to all data
#'
#' @return a [tibble][tibble::tibble-package] with the data
#' @export
#'
#' @examples opendata_get_dataset("gp-practice-populations",
#'   max_resources = 2, rows = 10
#' )
opendata_get_dataset <- function(dataset_name, max_resources = NULL, rows = NULL) {
  if (!opendata_check_dataset_name(dataset_name)) {
    stop(glue::glue("The dataset name supplied ('{dataset_name}') is invalid"))
  }

  query <- list(id = dataset_name)

  url <- httr::modify_url(opendata_package_show_url(),
    query = query
  )

  ua <- opendata_ua()

  response <- httr::GET(url = url, user_agent = ua)

  httr::stop_for_status(response)

  stopifnot(httr::http_type(response) == "application/json")


  parsed <- httr::content(response, "text") %>%
    jsonlite::fromJSON()

  if (is.null(max_resources)) {
    resource_id_list <- parsed$result$resources$id %>%
      as.list()
  } else {
    n_res <- length(parsed$result$resources$id)
    resource_id_list <- parsed$result$resources$id[1:min(n_res, max_resources)] %>%
      as.list()
  }

  all_data <- purrr::map_dfr(resource_id_list, opendata_get_resource, rows = rows)

  return(all_data)
}

#' Creates the URL for the package_show end-point
#'
#' @return a url
opendata_package_show_url <- function() {
  httr::modify_url("https://www.opendata.nhs.scot",
    path = "/api/3/action/package_show"
  )
}

#' Check if a dataset name is valid
#'
#' @description
#' Used to attempt to validate a dataset name before submitting it to the API
#'
#' @param dataset_name a resource ID
#'
#' @return TRUE / FALSE indicating the validity of the dataset name
opendata_check_dataset_name <- function(dataset_name) {
  # Starts and ends in a lowercase letter or number
  # Has only lowercase alphanum or hyphens inbetween
  dataset_name_regex <- "^[a-z0-9][a-z0-9\\-]+?[a-z0-9]$"

  if (!inherits(dataset_name, "character")) {
    return(FALSE)
  } else if (!grepl(dataset_name_regex, dataset_name)) {
    return(FALSE)
  } else {
    return(TRUE)
  }
}
