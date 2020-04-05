#' @title Match geography codes and names
#'
#' @description \code{match_area} takes a vector of geography codes or area
#' names. It matches the input to the corresponding value(s) in the
#' \code{\link{area_lookup}} dataset. It returns the corresponding area name
#' when supplied with a geography code, or the corresponding geography code(s)
#' when supplied with an area name.
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
#' between the input vector and the corresponding variable in the
#' \code{\link{area_lookup}} dataset. These exact matches are sensitive to both
#' case and spacing. Additionally, several place names in Scotland contain
#' letters outwith the standard 26 character Roman alphabet, which may
#' provide an added complication when supplying \code{match_area} with area
#' names. It is advised to inspect \code{\link{area_lookup}} in the case of
#' unexpected results, as these may be explained by subtle differences in
#' transcription between the input vector and the corresponding value in the
#' lookup dataset.
#'
#' @param x An input vector of geography codes or area names.
#' @param return A character string declaring the type of desired output.
#' Valid options are `name` and `code`. When set to `name`, \code{match_area}
#' returns area names. When set to `code`, \code{match_area} returns geography
#' codes. The default value is `name`.
#'
#' @return Each geography code within Scotland is unique, and consequently
#' \code{match_area} returns a single area name for each input value when
#' `return` is set equal to `name`.
#'
#' However, the same area may be covered by multiple geography codes. When
#' `return` is set equal to `code`, and multiple codes are available for a
#' given area, they will all be returned as a single value, separated by
#' commas. They will not be returned as separate entries in a list, as it is
#' not desirable to have a single function producing outputs of varying class.
#' Consider using \code{\link[stringr:str_split]{stringr::str_split()}} to
#' split these into separate entries in a vector, or
#' \code{\link[tidyr:separate]{tidyr::separate()}} to split each entry into a
#' new variable in a \code{\link[base:data.frame]{data.frame()}} or
#' \code{\link[tibble]{tibble}}.
#'
#' Any input value without a corresponding value in the
#' \code{\link{area_lookup}} will return an NA output value.
#'
#' @examples
#' match_area("S20000010")
#' match_area(c("Ayr North", "Ayr East", "Ayr West"), return = "code")
#'
#' library(dplyr)
#' df <- tibble(code = c("S02000656", "S02001042", "S08000020", "S12000013"))
#' df %>% mutate(name = match_area(code))
#'
#' @export

match_area <- function(x, return = c("name", "code")) {

  return <- match.arg(return)

  # Coerce input to character to prevent any warning messages appearing about
  # type conversion in dplyr::left_join
  x <- as.character(x)

  # Calculate the number of non-NA input geography codes which are not 9
  # characters in length or one of the exceptions
  if (return == "name") {
    n <- length(x[!is.na(x)][nchar(x[!is.na(x)]) != 9 &
                               !x[!is.na(x)] %in% sprintf("RA270%d", seq(1:4))])

  } else {

    # This value is irrelevant if the function is provided with area names
    # It's easier to set n equal to zero than to have nested if statements
    n <- 0
  }

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

  area_lookup <- phsmethods::area_lookup

  if (return == "name") {

    x <- tibble::enframe(x,
                         name = NULL,
                         value = "geo_code")

    return(dplyr::left_join(x,
                            area_lookup,
                            by = "geo_code") %>%

             # dplyr::pull takes the last variable if none is specified
             dplyr::pull())

  } else {

    x <- tibble::enframe(x,
                         name = NULL,
                         value = "area_name") %>%

      # NA values will all be lumped together as a factor level, which will
      # cause problems
      # Replace each instance of NA with a character value of "NA.n", where .n
      # represents the nth NA in the input vector
      # These values won't be returned in the final output so it doesn't really
      # matter how they're recorded, each one just needs to be unique
      dplyr::mutate(area_name = replace(
        area_name,
        is.na(area_name),
        sprintf("NA%d", seq(1, dplyr::n_distinct(is.na(area_name))))))

    return(dplyr::left_join(x,
                            area_lookup,
                            by = "area_name") %>%

             # Making area name a factor whose levels are in the same order as
             # the input ensures dplyr::summarise goes in that order and not
             # alphabetically
             dplyr::mutate(area_name = forcats::fct_inorder(area_name)) %>%
             dplyr::group_by(area_name) %>%
             dplyr::summarise(geo_code = stringr::str_c(geo_code,
                                                        collapse = ", ")) %>%
             dplyr::ungroup() %>%
             dplyr::pull())

  }
}
