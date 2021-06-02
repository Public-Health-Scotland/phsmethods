
#' Get Open Data resource
#'
#' @param res_id The resource ID as found on \href{https://www.opendata.nhs.scot/}{NHS Open Data platform}
#' @param rows (optional) specify the max number of rows to return
#' use this when testing code to reduce the size of the request
#' it will default to the either all the data or 99,999 (the hard limit on this API endpoint)
#'
#' @return a [tibble][tibble::tibble-package] with the data
#' @export
#'
#' @examples opendata_get_resource(res_id = "a794d603-95ab-4309-8c92-b48970478c14")
opendata_get_resource <- function(res_id, rows = NULL) {
  if (!opendata_check_res_id(res_id)) {
    stop(glue::glue("The resource ID supplied ('{res_id}') is invalid"))
  }

  # Get the max rows allowed by the API if rows isn't specified
  # 99999 is the limit for the API row selection but some resources are larger than this
  # We are considering options for returning these resources in an efficient way.
  max_rows <- min(rows, 99999)

  query <- list(
    id = res_id,
    limit = max_rows
  )

  url <- httr::modify_url(opendata_ds_search_url(),
    query = query
  )

  ua <- opendata_ua()

  response <- httr::GET(url = url, user_agent = ua)

  httr::stop_for_status(response)

  stopifnot(httr::http_type(response) == "application/json")


  parsed <- httr::content(response, "text") %>%
    jsonlite::fromJSON()

  data <- parsed$result$records %>%
    tibble::as_tibble()

  return(data)
}

#' Open Data user agent
#' @description
#' This is used internally to return a standard useragent
#' Supplying a user agent means requests using the package
#' can be tracked more easily
#'
#' @return a {httr} user_agent string
opendata_ua <- function() {
  httr::user_agent("https://github.com/Public-Health-Scotland/phsmethods")
}


#' Check if a resource ID is valid
#'
#' @description
#' Used to attempt to validate a res_id before submitting it to the API
#'
#' @param res_id a resource ID
#'
#' @return TRUE / FALSE indicating the validity of the res_id
opendata_check_res_id <- function(res_id) {
  if (!inherits(res_id, "character")) {
    return(FALSE)
  } else if (FALSE) {
    # Can be extended with other checks e.g. does res_id match a regex?
  } else {
    return(TRUE)
  }
}

#' Creates the URL for the datastore search end-point
#'
#' @return a url
opendata_ds_search_url <- function() {
  httr::modify_url("https://www.opendata.nhs.scot",
    path = "/api/3/action/datastore_search"
  )
}
