#' Codes and names of Scottish geographical and administrative areas.
#'
#' A dataset containing Scotland's geography codes and associated area names.
#' It is used within [match_area()].
#'
#' @details `geo_code` contains geography codes pertaining to Health
#' Boards, Council Areas, Health and Social Care Partnerships, Intermediate
#' Zones, Data Zones (2001 and 2011), Electoral Wards, Scottish Parliamentary
#' Constituencies, UK Parliamentary Constituencies, Travel to work areas,
#' National Parks, Community Health Partnerships, Localities (S19),
#' Settlements (S20) and Scotland.
#'
#' @seealso The script used to create the `area_lookup` dataset on
#' [GitHub](https://github.com/Public-Health-Scotland/phsmethods/blob/master/data-raw/area_lookup.R).
#'
#' @format A [tibble::tibble()] with 2 variables and over 17,000 rows:
#' \describe{
#'   \item{geo_code}{Standard geography code - 9 characters}
#'   \item{area_name}{Name of the area the code represents}
#' }
#' @source <https://statistics.gov.scot/>
"area_lookup"
