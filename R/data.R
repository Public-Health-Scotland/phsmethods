#' Codes and names of Scottish geographical and administrative areas.
#'
#' A dataset containing the codes and names of areas used in Scotland.
#'
#' @seealso The script used to create the area_lookup dataset:
#' \url{https://github.com/Health-SocialCare-Scotland/phsmethods/blob/geo_names/data-raw/area_lookup.R}
#'
#' @format A \code{\link[tibble]{tibble}} with 2 variables and over 23,000 rows:
#' \describe{
#'   \item{geo_code}{Standard geography code - 9 characters}
#'   \item{area_name}{Name of the area the code represents}
#' }
#' @source \url{https://statistics.gov.scot/}
"area_lookup"
