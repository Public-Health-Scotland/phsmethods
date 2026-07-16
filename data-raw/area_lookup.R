### This script downloads and formats data pertaining to geographic area names
### and codes from the Scottish Government open data platform
###
### The resulting file is used inside the match_area function and is made
### available to users of the package via phsmethods::area_lookup
###
### This script should be re-run prior to every package release, to ensure the
### most up-to-date information provided by the Scottish Government is used
###
### Any substantial changes to the data should be noted in the section
### pertaining to the latest release in the NEWS.md file
###
### This code should run successfully on RStudio server
### It may time out on RStudio desktop due to network security settings
get_area_lookup <- function(endpoint, query) {
  resp <- httr2::request(endpoint) |>
    httr2::req_url_query(query = trimws(query)) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = FALSE)

  tibble::tibble(
    geo_code = vapply(
      resp$results$bindings,
      \(x) x$geo_code$value,
      character(1)
    ),
    area_name = vapply(
      resp$results$bindings,
      \(x) {
        if (is.null(x$area_name)) {
          NA_character_
        } else {
          x$area_name$value
        }
      },
      character(1)
    )
  )
}

endpoint <- "http://statistics.gov.scot/sparql.json"

query <- "
SELECT ?geo_code ?area_name
WHERE {
  ?s <http://statistics.data.gov.uk/def/statistical-entity#code> ?entity ;
     <http://www.w3.org/2004/02/skos/core#notation> ?geo_code .

  OPTIONAL {
    ?s <http://statistics.data.gov.uk/def/statistical-geography#officialname> ?area_name .
  }
}
"

area_lookup <- get_area_lookup(endpoint, query) |>
  tidyr::drop_na(area_name) |>
  # Two of the area names had non-breaking spaces at the end
  # Cleaning as this is definitely a mistake.
  dplyr::mutate(area_name = trimws(area_name, whitespace = "[\\h\\v]")) |>
  dplyr::arrange(geo_code)

# The JSON endpoint correctly preserves Unicode characters in area names,
# including Gaelic accents and typographic punctuation. Previous versions
# using the SPARQL package required several names to be corrected manually.
dplyr::filter(area_lookup, !xfun::is_ascii(area_name))

# Manually add some additional codes which aren't present in the lookup file
other_areas <- tibble::tibble(
  area_name = c(
    "Scotland",
    "Non-NHS Provider/Location",
    "Not applicable",
    "Golden Jubilee Hospital",
    "The State Hospital",
    "No Fixed Abode",
    "Rest of UK (Outside Scotland)",
    "Outside the UK",
    "Unknown residency",
    "Rest of UK (Outside Scotland)",
    "No Fixed Abode",
    "Unknown residency",
    "Outside the UK"
  ),
  geo_code = c(
    "S00000001",
    "S27000001",
    "S27000002",
    "S08100001",
    "S08100008",
    paste0("RA270", 1:4),
    paste0("S0820000", 1:4)
  )
)

# Should the lookup file ever be updated to include any of the additional codes,
# this will prevent those codes from being duplicated in the final file
if (any(other_areas$geo_code %in% area_lookup$geo_code)) {
  other_areas <- dplyr::filter(other_areas, !geo_code %in% area_lookup$geo_code)
}

area_lookup <- dplyr::bind_rows(area_lookup, other_areas)

# Save data to data/area_lookup.rda
usethis::use_data(area_lookup, overwrite = TRUE)
