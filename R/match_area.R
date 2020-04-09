#' @title Translate geography codes into area names
#'
#' @description \code{match_area} takes a geography code or vector of geography
#' codes. It matches the input to the corresponding value(s) in the
#' \code{\link{area_lookup}} dataset and returns the corresponding area name.
#'
#' @details \code{match_area} relies predominantly on the standard 9 digit
#' geography codes. The only exceptions are:
#' \itemize{
#' \item RA2701: No Fixed Abode
#' \item RA2702: Rest of UK (Outside Scotland)
#' \item RA2703: Outside the UK
#' \item RA2704: Unknown Residency
#' }
#'
#' \code{match_area} caters for both current and previous versions of geography
#' codes (e.g 2014 and 2019 Health Boards).
#'
#' It can account for geography codes pertaining to Health Boards, Council
#' Areas, Health and Social Care Partnerships, Intermediate Zones, Data Zones
#' (2001 and 2011), Electoral Wards, Scottish Parliamentary Constituencies,
#' UK Parliamentary Constituencies, Travel to work areas, National Parks,
#' Commmunity Health Partnerships, Localities (S19), Settlements (S20) and
#' Scotland.
#'
#' \code{match_area} returns a non-NA value only when an exact match is present
#' between the input value and the corresponding variable in the
#' \code{\link{area_lookup}} dataset. These exact matches are sensitive to both
#' case and spacing. It is advised to inspect \code{\link{area_lookup}} in the
#' case of unexpected results, as these may be explained by subtle differences
#' in transcription between the input vector and the corresponding value in the
#' lookup dataset.
#'
#' @param x A geogrpahy code or vector of geography codes.

#' @return Each geography code within Scotland is unique, and consequently
#' \code{match_area} returns a single area name for each input value.

#' Any input value without a corresponding value in the
#' \code{\link{area_lookup}} dataset will return an NA output value.
#'
#' @examples
#' match_area("S20000010")
#'
#' library(dplyr)
#' df <- tibble(code = c("S02000656", "S02001042", "S08000020", "S12000013"))
#' df %>% mutate(name = match_area(code))
#'
#' @export

match_area <- function(x) {

  # Coerce input to character to prevent any warning messages appearing about
  # type conversion in dplyr::left_join
  code_var <- as.character(x)

  # Calculate the number of non-NA input geography codes which are not 9
  # characters in length or one of the exceptions
  n <- length(x[!is.na(x)][nchar(x[!is.na(x)]) != 9 &
                             !x[!is.na(x)] %in% sprintf("RA270%d", seq(1:4))])

  # If n is one, the warning message describing the number of non-NA codes
  # which are not length 9 or one of the exceptions should use singular verbs
  # Otherwise, use plural ones
  singular <- "code is"
  multiple <- "codes are"

  if (n > 0) {
    warning(glue::glue("{n} non-NA input geography ",
                       "{ifelse(n == 1, singular, multiple)} not 9 characters ",
                       "in length and will return an NA. The only allowed ",
                       "codes with a differing number of characters are:\n",
                       "\U2022 RA2701: No Fixed Abode\n",
                       "\U2022 RA2702: Rest of UK (Outside Scotland)\n",
                       "\U2022 RA2703: Outside the UK\n",
                       "\U2022 RA2704: Unknown Residency"))
  }

  # Reading area code to name lookup
  area_lookup <- phsmethods::area_lookup

  # Transforming variable into data frame to allow merging with lookup
  code_var <- tibble::enframe(code_var,
                              name = NULL,
                              value = "geo_code")

  # Merging lookup with code variable and retrieving only the name
  dplyr::left_join(code_var,
                   area_lookup,
                   by = "geo_code") %>%

    # dplyr::pull takes the last variable if none is specified
    dplyr::pull()

}
