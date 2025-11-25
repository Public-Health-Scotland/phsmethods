# Extract Date of Birth (DoB) from the CHI number

`dob_from_chi` takes a CHI number or a vector of CHI numbers and returns
the Date of Birth (DoB) as implied by the CHI number(s). If the DoB is
ambiguous it will return NA.

## Usage

``` r
dob_from_chi(chi_number, min_date = NULL, max_date = NULL, chi_check = TRUE)
```

## Arguments

- chi_number:

  a CHI number or a vector of CHI numbers with `character` class.

- min_date, max_date:

  optional min and/or max dates that the DoB could take as the century
  needs to be guessed. Must be either length 1 for a 'fixed' date or the
  same length as `chi_number` for a date per CHI number. `min_date` can
  be date based on common sense in the dataset, whilst `max_date` can be
  date when an event happens such as discharge date.

- chi_check:

  logical, optionally skip checking the CHI for validity which will be
  faster but should only be used if you have previously checked the
  CHI(s). The default (TRUE) will check the CHI numbers.

## Value

a date vector of DoB. It will be the same length as `chi_number`.

## Examples

``` r
dob_from_chi("0101336489")
#> [1] "1933-01-01"

library(tibble)
library(dplyr)
data <- tibble(chi = c(
  "0101336489",
  "0101405073",
  "0101625707"
), adm_date = as.Date(c(
  "1950-01-01",
  "2000-01-01",
  "2020-01-01"
)))

data %>%
  mutate(chi_dob = dob_from_chi(chi))
#> # A tibble: 3 × 3
#>   chi        adm_date   chi_dob   
#>   <chr>      <date>     <date>    
#> 1 0101336489 1950-01-01 1933-01-01
#> 2 0101405073 2000-01-01 1940-01-01
#> 3 0101625707 2020-01-01 1962-01-01

data %>%
  mutate(chi_dob = dob_from_chi(chi,
    min_date = as.Date("1930-01-01"),
    max_date = adm_date
  ))
#> # A tibble: 3 × 3
#>   chi        adm_date   chi_dob   
#>   <chr>      <date>     <date>    
#> 1 0101336489 1950-01-01 1933-01-01
#> 2 0101405073 2000-01-01 1940-01-01
#> 3 0101625707 2020-01-01 1962-01-01
```
