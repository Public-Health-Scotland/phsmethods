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
match_area_names <- function(dataset, code_var) {

  ###############################################.
  ## Merging dataset with names lookup ----
  ###############################################.
  # Read in area name to geographic code lookup
  load("data/area_name_lookup.rda")

  # Function works for data frames sensu lato. Checking dataset provide is one.
  if(is.data.frame(dataset) == FALSE) {
      stop("Dataset provided is not a data frame or tibble.")
  }

  # Testing that code variable provided is a string.
  if(is.factor(dataset[[code_var]]) == FALSE &
         is.character(dataset[[code_var]]) == FALSE) {
    stop("The code variable provided is not of type character or factor.")
  }

  # Testing if codes that want to be matched are in lookup
  if(!(any(unique(substr(area_name_lookup$geo_code, 1, 3)) %in%
         unique(substr(dataset[[code_var]], 1, 3))))) {
    stop("The codes you are trying to match don't exist in the names lookup.")
  }

  # Ensuring geo_code variable is of the right type
  dataset %<>% dplyr::mutate_at(code_var, as.character)

  # If there is already a variable named area_name give a warning
  if ("area_name" %in% names(dataset) == T) {
    warning(paste0("There is already a variable named 'area_name' ",
            "in the dataset. The original variable will be renamed as ",
            "'area_name.x and the one produced by this function as ",
            "'area_name.y' "))
  }

  # Merges with the dataset selected
  dplyr::left_join(dataset, area_name_lookup,
                   by = stats::setNames("geo_code", code_var) )

}

##END
