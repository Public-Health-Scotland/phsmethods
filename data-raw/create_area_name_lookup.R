###############################################.
## Creating lookup from SG open data platform ----
###############################################.
# Extracting the lookup between codes and names from SG open data platform
endpoint <- "http://statistics.gov.scot/sparql" # api adress

# Query for the platform API, written in SPARQL
# the optional means it extracts all codes even when they don't have a name.
query_names <- "SELECT ?geo_code ?area_name
  WHERE {
  ?s <http://statistics.data.gov.uk/def/statistical-entity#code> ?entity;
  <http://www.w3.org/2004/02/skos/core#notation> ?geo_code.
  OPTIONAL {?s <http://statistics.data.gov.uk/def/statistical-geography#officialname> ?area_name.}
  }
  ORDER BY ?geo_code "

qd <- SPARQL::SPARQL(endpoint, query_names)

names_lookup <- qd[["results"]] %>%
  dplyr::mutate(geo_code = substr(geo_code, 2, 10)) # extracting only code

# Adding a few extra codes and names not present in lookup files
other_names <- tibble::tibble(
  area_name = c("Scotland", "Non-NHS Provider/Location", "Not applicable",
                "Golden Jubilee Hospital", "The State Hospital",
                "No Fixed Abode", "Rest of UK (Outside Scotland)",
                "Outside the UK", "Unknown residency",
                "Rest of UK (Outside Scotland)", "No Fixed Abode",
                "Unknown residency", "Outside the UK"),
  geo_code = c("S00000001", "S27000001", "S27000002", "S08100001", "S08100008",
               sprintf("RA270%d", seq(1:4)), sprintf("S0820000%d", seq(1:4))))

names_lookup <- rbind(names_lookup, other_names)

saveRDS(area_name_lookup, file = "data/area_name_lookup.rds")
# There is an issue with testhat that prevents it to access internal filepaths:
# https://github.com/r-lib/testthat/issues/86
# So it needs t be duplicated in its own folder too
saveRDS(area_name_lookup, file = "tests/testthat/data/area_name_lookup.rds")


##END
