# Extract age from the CHI number

`age_from_chi` takes a CHI number or a vector of CHI numbers and returns
the age as implied by the CHI number(s). If the Date of Birth (DoB) is
ambiguous it will return NA. It uses
[`dob_from_chi()`](https://public-health-scotland.github.io/phsmethods/reference/dob_from_chi.md).

## Usage

``` r
age_from_chi(
  chi_number,
  ref_date = NULL,
  min_age = 0L,
  max_age = NULL,
  chi_check = TRUE
)
```

## Arguments

- chi_number:

  a CHI number or a vector of CHI numbers with `character` class.

- ref_date:

  calculate the age at this date, default is to use
  [`Sys.Date()`](https://rdrr.io/r/base/Sys.time.html) i.e. today.

- min_age, max_age:

  optional min and/or max dates that the DoB could take as the century
  needs to be guessed. Must be either length 1 for a 'fixed' age or the
  same length as `chi_number` for an age per CHI number. `min_age` can
  be age based on common sense in the dataset, whilst `max_age` can be
  age when an event happens such as the age at discharge.

- chi_check:

  logical, optionally skip checking the CHI for validity which will be
  faster but should only be used if you have previously checked the
  CHI(s), the default (TRUE) will to check the CHI numbers.

## Value

an integer vector of ages in years truncated to the nearest year. It
will be the same length as `chi_number`.

## Examples

``` r
age_from_chi("0101336489")
#> [1] 93

library(tibble)
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
data <- tibble(chi = c(
  "0101336489",
  "0101405073",
  "0101625707"
), dis_date = as.Date(c(
  "1950-01-01",
  "2000-01-01",
  "2020-01-01"
)))

data %>%
  mutate(chi_age = age_from_chi(chi))
#> # A tibble: 3 × 3
#>   chi        dis_date   chi_age
#>   <chr>      <date>       <dbl>
#> 1 0101336489 1950-01-01      93
#> 2 0101405073 2000-01-01      86
#> 3 0101625707 2020-01-01      64

data %>%
  mutate(chi_age = age_from_chi(chi, min_age = 18, max_age = 65))
#> ! 2 CHI numbers produced ambiguous dates and will be given "NA" for their Dates
#>   of Birth.
#> ✔ Try different values for `min_age` and/or `max_age`.
#> # A tibble: 3 × 3
#>   chi        dis_date   chi_age
#>   <chr>      <date>       <dbl>
#> 1 0101336489 1950-01-01      NA
#> 2 0101405073 2000-01-01      NA
#> 3 0101625707 2020-01-01      64

data %>%
  mutate(chi_age = age_from_chi(chi,
    ref_date = dis_date
  ))
#> # A tibble: 3 × 3
#>   chi        dis_date   chi_age
#>   <chr>      <date>       <dbl>
#> 1 0101336489 1950-01-01      17
#> 2 0101405073 2000-01-01      60
#> 3 0101625707 2020-01-01      58
```
