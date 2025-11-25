# Percentages

`percent` is a lightweight S3 class allowing for pretty printing of
proportions as percentages.  
It aims to remove the need for creating character vectors of
percentages.

## Usage

``` r
as_percent(x, digits = 2)

NA_percent_
```

## Format

An object of class `percent` of length 1.

## Arguments

- x:

  `[numeric]` vector of proportions.

- digits:

  `[numeric(1)]` - The number of digits that will be used for
  formatting. This is by default 2 and is applied whenever
  [`format()`](https://rdrr.io/r/base/format.html),
  [`as.character()`](https://rdrr.io/r/base/character.html) and
  [`print()`](https://rdrr.io/r/base/print.html) are called. This can
  also be controlled directly via
  [`format()`](https://rdrr.io/r/base/format.html).

## Value

An object of class `percent`.

## Details

### Rounding

The rounding for percent vectors differs to that of base R rounding,
namely in that halves are rounded up instead of rounded to even. This
means that `round(x)` will round the percent vector `x` using halves-up
rounding (like in the janitor package).

### Formatting

By default all percentages are formatted to 2 decimal places which can
be overwritten using [`format()`](https://rdrr.io/r/base/format.html) or
using [`round()`](https://rdrr.io/r/base/Round.html) if your required
digits are less than 2. It's worth noting that the digits argument in
`format.percent` uses decimal rounding instead of the usual significant
digit rounding that
[`format.default()`](https://rdrr.io/r/base/format.html) uses.

## Examples

``` r
# Convert proportions to percentages
as_percent(seq(0, 1, 0.1))
#>  [1] "0%"   "10%"  "20%"  "30%"  "40%"  "50%"  "60%"  "70%"  "80%"  "90%" 
#> [11] "100%"

# You can use round() as usual
p <- as_percent(15.56 / 100)
round(p)
#> [1] "16%"
round(p, digits = 1)
#> [1] "15.6%"

p2 <- as_percent(0.0005)
signif(p2, 2)
#> [1] "0.05%"
floor(p2)
#> [1] "0%"
ceiling(p2)
#> [1] "1%"

# We can do basic math operations as usual

# Order of operations doesn't matter
10 * as_percent(c(0, 0.5, 2))
#> [1] "0%"     "500%"   "2,000%"
as_percent(c(0, 0.5, 2)) * 10
#> [1] "0%"     "500%"   "2,000%"

as_percent(0.1) + as_percent(0.2)
#> [1] "30%"

# Formatting options
format(as_percent(2.674 / 100), digits = 2, symbol = " (%)")
#> [1] "2.67 (%)"
# Prints nicely in data frames (and tibbles)
library(dplyr)
starwars %>%
  count(eye_color) %>%
  mutate(perc = as_percent(n / sum(n))) %>%
  arrange(desc(perc)) %>% # We can do numeric sorting with percent vectors
  mutate(perc_rounded = round(perc))
#> # A tibble: 15 × 4
#>    eye_color         n perc      perc_rounded
#>    <chr>         <int> <percent> <percent>   
#>  1 brown            21 24.14%    24%         
#>  2 blue             19 21.84%    22%         
#>  3 yellow           11 12.64%    13%         
#>  4 black            10 11.49%    11%         
#>  5 orange            8 9.20%     9%          
#>  6 red               5 5.75%     6%          
#>  7 hazel             3 3.45%     3%          
#>  8 unknown           3 3.45%     3%          
#>  9 blue-gray         1 1.15%     1%          
#> 10 dark              1 1.15%     1%          
#> 11 gold              1 1.15%     1%          
#> 12 green, yellow     1 1.15%     1%          
#> 13 pink              1 1.15%     1%          
#> 14 red, blue         1 1.15%     1%          
#> 15 white             1 1.15%     1%          
```
