# Create age groups

`create_age_groups()` takes a numeric vector and assigns each age to the
appropriate age group.

## Usage

``` r
create_age_groups(x, from = 0, to = 90, by = 5, as_factor = FALSE)
```

## Arguments

- x:

  a vector of numeric values

- from:

  the start of the smallest age group. The default is `0`.

- to:

  the end point of the age groups. The default is `90`.

- by:

  the size of the age groups. The default is `5`.

- as_factor:

  The default behaviour is to return a character vector. Use `TRUE` to
  return a factor vector instead.

## Value

A character vector, where each element is the age group for the
corresponding element in `x`. If `as_factor = TRUE`, a factor vector is
returned instead.

## Details

The `from`, `to` and `by` values are used to create distinct age groups.
`from` dictates the starting age of the lowest age group, and `by`
indicates how wide each group should be. `to` stipulates the cut-off
point at which all ages equal to or greater than this value should be
categorised together in a `to+` group. If the specified value of `to` is
not a multiple of `by`, the value of `to` is rounded down to the nearest
multiple of `by`.

The default values of `from`, `to` and `by` correspond to the [European
Standard
Population](https://www.opendata.nhs.scot/dataset/standard-populations/resource/edee9731-daf7-4e0d-b525-e4c1469b8f69)
age groups.

## Examples

``` r
age <- c(54, 7, 77, 1, 26, 101)

create_age_groups(age)
#> [1] "50-54" "5-9"   "75-79" "0-4"   "25-29" "90+"  
create_age_groups(age, from = 0, to = 80, by = 10)
#> [1] "50-59" "0-9"   "70-79" "0-9"   "20-29" "80+"  

# Final group may start below 'to'
create_age_groups(age, from = 0, to = 65, by = 10)
#> [1] "50-59" "0-9"   "60+"   "0-9"   "20-29" "60+"  

# To get the output as a factor:
create_age_groups(age, as_factor = TRUE)
#> [1] 50-54 5-9   75-79 0-4   25-29 90+  
#> 19 Levels: 0-4 < 5-9 < 10-14 < 15-19 < 20-24 < 25-29 < 30-34 < ... < 90+
```
