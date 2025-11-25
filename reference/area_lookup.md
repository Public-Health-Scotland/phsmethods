# Codes and names of Scottish geographical and administrative areas.

A dataset containing Scotland's geography codes and associated area
names. It is used within
[`match_area()`](https://public-health-scotland.github.io/phsmethods/reference/match_area.md).

## Usage

``` r
area_lookup
```

## Format

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with 2 variables and over 17,000 rows:

- geo_code:

  Standard geography code - 9 characters

- area_name:

  Name of the area the code represents

## Source

<https://statistics.gov.scot/>

## Details

`geo_code` contains geography codes pertaining to Health Boards, Council
Areas, Health and Social Care Partnerships, Intermediate Zones, Data
Zones (2001 and 2011), Electoral Wards, Scottish Parliamentary
Constituencies, UK Parliamentary Constituencies, Travel to work areas,
National Parks, Community Health Partnerships, Localities (S19),
Settlements (S20) and Scotland.

## See also

The script used to create the `area_lookup` dataset on
[GitHub](https://github.com/Public-Health-Scotland/phsmethods/blob/master/data-raw/area_lookup.R).
