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


library(SPARQL)
library(magrittr)

# API address for SG open data platform
endpoint <- "http://statistics.gov.scot/sparql"

# Query for the platform API, written in SPARQL
# The optional means it extracts all codes even when they don't have a name
query <- "SELECT ?geo_code ?area_name
WHERE {
?s <http://statistics.data.gov.uk/def/statistical-entity#code> ?entity;
<http://www.w3.org/2004/02/skos/core#notation> ?geo_code.
OPTIONAL {?s <http://statistics.data.gov.uk/def/statistical-geography#officialname> ?area_name.}
}
ORDER BY ?geo_code "

qd <- SPARQL::SPARQL(endpoint, query)

area_lookup <- qd[["results"]] %>%

  # Extract the code only
  dplyr::mutate(geo_code = substr(geo_code, 2, 10))

# A bunch of area names don't parse correctly from the SG open data platform
# This seems like a problem with their platform, rather than with SPARQL
# Most of the problems seem to be with parsing non-ASCII characters, although
# not all of the area names which are parsed incorrectly should even have
# non-ASCII characters in them
# This step identifies the problem area names
area_lookup %>%
  dplyr::filter(!xfun::is_ascii(area_name))

# I did't see an easier solution than googling the codes of the areas with
# problem names, finding out what the real names are, and manually changing them
area_lookup %<>%
  dplyr::mutate(area_name = dplyr::case_when(
    geo_code == "S13002605" ~ "Ste\U00F2rnabhagh a Deas",
    geo_code == "S13002606" ~ "Ste\U00F2rnabhagh a Tuath",
    geo_code == "S13002672" ~ "Eilean a' Ch\U00E8o",
    geo_code == "S13002891" ~ "Annandale East and Eskdale",
    geo_code == "S13002936" ~ "Bo'ness and Blackness",
    geo_code == "S13002999" ~ "Eilean a' Ch\U00E8o",
    TRUE ~ area_name
  ))

# Manually add some additional codes which aren't present in the lookup file
other_areas <- tibble::tibble(
  area_name = c("Scotland",
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
                "Outside the UK"),
  geo_code = c("S00000001",
               "S27000001",
               "S27000002",
               "S08100001",
               "S08100008",
               sprintf("RA270%d", seq(1:4)),
               sprintf("S0820000%d", seq(1:4))))

# Should the lookup file ever be updated to include any of the additional codes,
# this will prevent those codes from being duplicated in the final file
if (any(other_areas$geo_code %in% area_lookup$geo_code)) {
  other_areas %<>%
    dplyr::filter(!geo_code %in% area_lookup$geo_code)
}

area_lookup %<>%
  tibble::as_tibble() %>%
  dplyr::bind_rows(other_areas)

# Save data to data/area_lookup.rda
usethis::use_data(area_lookup, overwrite = TRUE)
