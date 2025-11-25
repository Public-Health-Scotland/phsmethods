# Translate geography codes into area names

`match_area` takes a geography code or vector of geography codes. It
matches the input to the corresponding value in the
[`area_lookup()`](https://public-health-scotland.github.io/phsmethods/reference/area_lookup.md)
dataset and returns the corresponding area name.

## Usage

``` r
match_area(x)
```

## Arguments

- x:

  A geography code or vector of geography codes.

## Value

Each geography code within Scotland is unique, and consequently
`match_area` returns a single area name for each input value. Any input
value without a corresponding value in the
[`area_lookup()`](https://public-health-scotland.github.io/phsmethods/reference/area_lookup.md)
dataset will return an NA output value.

## Details

`match_area` relies predominantly on the standard 9 digit geography
codes. The only exceptions are:

- RA2701: No Fixed Abode

- RA2702: Rest of UK (Outside Scotland)

- RA2703: Outside the UK

- RA2704: Unknown Residency

`match_area` caters for both current and previous versions of geography
codes (e.g 2014 and 2019 Health Boards).

It can account for geography codes pertaining to Health Boards, Council
Areas, Health and Social Care Partnerships, Intermediate Zones, Data
Zones (2001 and 2011), Electoral Wards, Scottish Parliamentary
Constituencies, UK Parliamentary Constituencies, Travel to work areas,
National Parks, Community Health Partnerships, Localities (S19),
Settlements (S20) and Scotland.

`match_area` returns a non-NA value only when an exact match is present
between the input value and the corresponding variable in the
[`area_lookup()`](https://public-health-scotland.github.io/phsmethods/reference/area_lookup.md)
dataset. These exact matches are sensitive to both case and spacing. It
is advised to inspect
[`area_lookup()`](https://public-health-scotland.github.io/phsmethods/reference/area_lookup.md)
in the case of unexpected results, as these may be explained by subtle
differences in transcription between the input value and the
corresponding value in the lookup dataset.

## Examples

``` r
match_area("S20000010")
#> [1] "Eaglesham"

library(dplyr)
df <- tibble(code = c("S02000656", "S02001042", "S08000020", "S12000013"))
df %>% mutate(name = match_area(code))
#> # A tibble: 4 × 2
#>   code      name               
#>   <chr>     <chr>              
#> 1 S02000656 Govan and Linthouse
#> 2 S02001042 Peebles North      
#> 3 S08000020 Grampian           
#> 4 S12000013 Na h-Eileanan Siar 
```
