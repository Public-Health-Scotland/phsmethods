# Extract sex from the CHI number

`sex_from_chi` takes a CHI number or a vector of CHI numbers and returns
the sex as implied by the CHI number(s). The default return type is an
integer but this can be modified.

## Usage

``` r
sex_from_chi(
  chi_number,
  male_value = 1L,
  female_value = 2L,
  as_factor = FALSE,
  chi_check = TRUE
)
```

## Arguments

- chi_number:

  a CHI number or a vector of CHI numbers with `character` class.

- male_value, female_value:

  optionally supply custom values for Male and Female. Note that that
  these must be of the same class.

- as_factor:

  logical, optionally return as a factor with labels `'Male'` and
  `'Female'`. Note that this will override any custom values supplied
  with `male_value` or `female_value`.

- chi_check:

  logical, optionally skip checking the CHI for validity which will be
  faster but should only be used if you have previously checked the
  CHI(s).

## Value

a vector with the same class as `male_value` and `female_value`,
(integer by default) unless `as_factor` is `TRUE` in which case a factor
will be returned.

## Details

The Community Health Index (CHI) is a register of all patients in NHS
Scotland. A CHI number is a unique, ten-digit identifier assigned to
each patient on the index.

The ninth digit of a CHI number identifies a patient's sex: odd for men,
even for women.

The default behaviour for `sex_from_chi` is to first check the CHI
number is valid using `check_chi` and then to return 1 for male and 2
for female.

There are options to return custom values e.g. `'M'` and `'F'` or to
return a factor which will have labels `'Male'` and `'Female')`

## Examples

``` r
sex_from_chi("0101011237")
#> [1] 1
sex_from_chi(c("0101011237", "0101336489", NA))
#> [1]  1  2 NA
sex_from_chi(
  c("0101011237", "0101336489", NA),
  male_value = "M",
  female_value = "F"
)
#> Using custom values: Male = "M", Female = "F"
#> The return variable will be <character>.
#> [1] "M" "F" NA 
sex_from_chi(c("0101011237", "0101336489", NA), as_factor = TRUE)
#> [1] Male   Female <NA>  
#> Levels: Male Female

library(dplyr)
df <- tibble(chi = c("0101011237", "0101336489", NA))
df %>% mutate(chi_sex = sex_from_chi(chi))
#> # A tibble: 3 × 2
#>   chi        chi_sex
#>   <chr>        <int>
#> 1 0101011237       1
#> 2 0101336489       2
#> 3 NA              NA
```
