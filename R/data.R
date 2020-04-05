#' Codes and names of Scottish geographical and administrative areas.
#'
#' A dataset containing Scotland's geography codes and associated area names.
#' It is used within \code{\link{match_area}}.
#'
#' @details \code{geo_code} contains geography codes pertaining to Health
#' Boards, Council Areas, Health and Social Care Partnerships, Intermediate
#' Zones, Data Zones (2001 and 2011), Electoral Wards, Scottish Parliamentary
#' Constituencies, UK Parliamentary Constituencies, Travel to work areas,
#' National Parks, Commmunity Health Partnerships, Localities (S19),
#' Settlements (S20) and Scotland.
#'
#' @seealso The script used to create the \code{area_lookup} dataset on
#' \href{https://github.com/Health-SocialCare-Scotland/phsmethods/blob/master/data-raw/area_lookup.R}{GitHub}.
#'
#' @format A \code{\link[tibble]{tibble}} with 2 variables and over 17,000 rows:
#' \describe{
#'   \item{geo_code}{Standard geography code - 9 characters}
#'   \item{area_name}{Name of the area the code represents}
#' }
#' @source \url{https://statistics.gov.scot/}
"area_lookup"
