#' @title Match geography codes with their names
#'
#' @description \code{match_area_names} takes a geography code and brings back the
#' name of the area.
#'
#' @details It uses the standard 9 digit codes for matching with the names.
#' It can match with any of the current and previous versions of the codes (e.g
#' 2014 and 2019 Health Boards).
#'
#' It works for Health Boards, Council Areas, Health and Social Care Partnerships,
#' Intermediate Zones, Data Zones (2001 and 2011), Electoral Wards,
#' Scottish Parliamentary Constituencies, UK Parliamentary Constituencies,
#' Travel to work areas, National Parks, Commmunity Health Partnerships,
#' Localities (S19), Settlements (S20) and Scotland
#'
#' @param dataset Data frame/tibble that contains the geography code variable.
#' @param code_var The variable that contains the geography codes. Needs to be
#' between quotes.
#'
#' @examples
#' test_df <- data.frame(code = c("S20000010", "S01002363", "S01004303",
#' "S02000656", "S02001042", "S08000020", "S12000013", "S12000048",
#' "S13002522", "S13002873", "S14000020", "S16000124", "S22000004"))
#'
#' # match_area_names(dataset = test_df, code_var = "code")
#' # test_df %>% match_area_names("code")
#'
#' @export
match_area <- function(x, by = c("code", "name")) {

  by <- match.arg(by)

  if (!inherits(x, c("character", "list", "factor"))) {
    stop("The input vector must be of character, list or factor class")
  }

  x <- as.character(x)

  if (by == "code") {

    return(dplyr::left_join(tibble::enframe(x,
                                            name = NULL,
                                            value = "geo_code"),
                            area_lookup,
                            by = "geo_code") %>%
             dplyr::pull())

  } else {

    return(dplyr::left_join(tibble::enframe(x,
                                            name = NULL,
                                            value = "area_name"),
                            area_lookup,
                            by = "area_name") %>%
             dplyr::mutate(area_name = forcats::fct_inorder(area_name)) %>%
             dplyr::group_by(area_name) %>%
             dplyr::summarise(geo_code = stringr::str_c(geo_code,
                                                        collapse = ", ")) %>%
             dplyr::ungroup() %>%
             dplyr::pull())

  }
}
