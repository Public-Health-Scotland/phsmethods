
#' Get Open Data resource
#'
#' @param res_id The resource ID as found on \href{https://www.opendata.nhs.scot/}{NHS Open Data platform}
#' @param rows (optional) specify the max number of rows to return
#' use this when testing code to reduce the size of the request
#' it will default to all data
#'
#' @return a [tibble][tibble::tibble-package] with the data
#' @export
#'
#' @examples opendata_get_resource(res_id = "a794d603-95ab-4309-8c92-b48970478c14")
opendata_get_resource <- function(res_id, rows = NULL){
  
  if (!opendata_check_res_id(res_id)) {
    stop(glue::glue("The resource ID supplied ('{res_id}') is invalid"))
  }
  
  #set ckan connection
  ckan_url <- "https://www.opendata.nhs.scot"
  
  #set resource id-s to use
  res_id <- res_id
  
  if (isTRUE(is.null(rows) || rows > 99999)) {
    
    #extract all data
    
    data <- readr::read_csv(glue::glue("{ckan_url}/datastore/dump/{res_id}?bom=true"))%>%
      dplyr::select(-"_id")
    
    return(data)
    
  }
  
  else {
    query <- list(
      id = res_id,
      limit = rows
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
  
}