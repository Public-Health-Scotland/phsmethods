#' @title Translate geography codes into area names
#'
#' @description `match_area` takes a geography code or vector of geography
#' codes. It matches the input to the corresponding value in the
#' [area_lookup()] dataset and returns the corresponding area name.
#'
#' @details `match_area` relies predominantly on the standard 9 digit
#' geography codes. The only exceptions are:
#' \itemize{
#' \item RA2701: No Fixed Abode
#' \item RA2702: Rest of UK (Outside Scotland)
#' \item RA2703: Outside the UK
#' \item RA2704: Unknown Residency
#' }
#'
#' `match_area` caters for both current and previous versions of geography
#' codes (e.g 2014 and 2019 Health Boards).
#'
#' It can account for geography codes pertaining to Health Boards, Council
#' Areas, Health and Social Care Partnerships, Intermediate Zones, Data Zones
#' (2001 and 2011), Electoral Wards, Scottish Parliamentary Constituencies,
#' UK Parliamentary Constituencies, Travel to work areas, National Parks,
#' Community Health Partnerships, Localities (S19), Settlements (S20) and
#' Scotland.
#'
#' `match_area` returns a non-NA value only when an exact match is present
#' between the input value and the corresponding variable in the
#' [area_lookup()] dataset. These exact matches are sensitive to both
#' case and spacing. It is advised to inspect [area_lookup()] in the
#' case of unexpected results, as these may be explained by subtle differences
#' in transcription between the input value and the corresponding value in the
#' lookup dataset.
#'
#' @param x A geography code or vector of geography codes.

#' @return Each geography code within Scotland is unique, and consequently
#' `match_area` returns a single area name for each input value.

#' Any input value without a corresponding value in the
#' [area_lookup()] dataset will return an NA output value.
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
  n_not_9_char <- length(x[!is.na(x)][nchar(x[!is.na(x)]) != 9 &
    !x[!is.na(x)] %in% sprintf("RA270%d", seq(1:4))])

  if (n_not_9_char > 0) {
    cli::cli_warn(c(
      "!" = "{n_not_9_char} non-NA input geograph{?y/ies} {?is/are} not 9 characters in length and will return {.val NA}.",
      "The only allowed codes with a differing number of characters are:",
      "*" = "{.val RA2701} - No Fixed Abode",
      "*" = "{.val RA2702} - Rest of UK (Outside Scotland)",
      "*" = "{.val RA2703} - Outside the UK",
      "*" = "{.val RA2704} - Unknown Residency"
    ))
  }

  # Load area code to name lookup
  area_lookup <- phsmethods::area_lookup

  # Transform variable into data frame to allow merging with lookup
  code_var <- tibble::enframe(code_var,
    name = NULL,
    value = "geo_code"
  )

  # Merge lookup with code variable and retrieving only the name
  dplyr::left_join(code_var,
    area_lookup,
    by = "geo_code"
  ) %>%
    # dplyr::pull takes the last variable if none is specified
    dplyr::pull()
}
