#' @title Match geography codes with their names
#'
#' @description \code{match_geo_names} takes a geography code and brings back the
#' name of the area.
#'
#' @details It uses the standard 9 digit codes for matching with the names.
#' It can match with any of the current and previous versions of the codes (e.g
#' 2014 and 2019 Health Boards).
#'
#' It works for Health Boards, Council Areas, Health and Social Care Partnerships,
#' Intermediate Zones, Data Zones, Electoral Wards, Scottish Parliamentary
#' Constituencies and Regions, and UK Parliamentary Constituencies.
#'
#' @param dataset Data frame/tibble that contains the geography code variable.
#' @param code_var The variable that contains the geography codes. Needs to be
#' between quotes.
#'
#' @examples
#' test_df <- data.frame(code = c("3", "S01002363", "S01004303", "S02000656",
#' "S02001042", "S08000020", "S12000013", "S12000048",
#' "S13002522", "S13002873", "S14000020", "S16000124", "S17000012"))
#'
#' match_area_names(dataset = test_df, code_var = "code")
#' test_df %>% match_geo_names("code")
#'
#' @export
match_area_names <- function(dataset, code_var) {

  # Folder where all the lookups between codes and names sit
  cl_out <- paste0("/conf/linkage/output/lookups/Unicode/Geography/",
                   "Scottish Postcode Directory/Codes and Names/")

  # List of name-code files in cl-out
  files <-  list.files(path = cl_out, pattern = "*.csv", full.names = TRUE)

  # Selecting name files for main geographies that would be included in lookup
  files_wanted <- paste0("Health Board Area|Council Area|Intermediate Zone|",
                         "Data Zone|Integration Authority|",
                         "Parliamentary|Electoral")
  # selecting only those of interest
  files <- files[grepl(files_wanted, files) == T]

  # Creating names lookup for all geographies.
  # Read and combines all files in folder
  names_lookup <- do.call(dplyr::bind_rows, lapply(files, function(x){
    data.table::fread(x) %>% janitor::clean_names()# variables to lower case
  }))

  # Now formatting it in a long format with only two columns: code and area_name.
  names_lookup %<>%
    dplyr::select(-nrs_health_board_area_name) %>% # duplicated name column
    dplyr::mutate_all(as.character) %>% # as there are a couple of integer ones
    # Moving all codes and all names on their own columns
    tidyr::pivot_longer(cols = contains("name"), names_to = "index",
                 values_to = "area_name") %>%
    tidyr::pivot_longer(cols = contains("code"), names_to = "index2",
                 values_to = "geo_code") %>%
    # filtering out those rows of spurious combinations
    dplyr::filter(!(is.na(geo_code)) & !(is.na(area_name))) %>%
    # Selecting only one row of names per code
    # (e.g. a CA with the same code in different versions)
    dplyr::select(-index, -index2) %>%
    unique()

  # Adding a few extra codes and names not present in lookup files
  other_names <- data.frame(area_name = c(rep("Scotland", 2),
                                          "Non-NHS Provider/Location",
                                          "Not applicable",
                                          "Golden Jubilee Hospital"),
                            geo_code = c("S00000001", "S92000003", "S27000001",
                                         "S27000002", "S08100001"))
  names_lookup <- rbind(names_lookup, other_names)

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
  dplyr::left_join(dataset, names_lookup, by = setNames("geo_code", code_var) )

}

##END
