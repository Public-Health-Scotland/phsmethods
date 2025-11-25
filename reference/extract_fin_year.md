# Extract the formatted financial year from a date

`extract_fin_year` takes a date and extracts the correct financial year
in the PHS specified format from it.

## Usage

``` r
extract_fin_year(date)
```

## Arguments

- date:

  A date which must be supplied with `Date`, `POSIXct`, `POSIXlt` or
  `POSIXt` class.
  [`base::as.Date()`](https://rdrr.io/r/base/as.Date.html),
  [`lubridate::dmy()`](https://lubridate.tidyverse.org/reference/ymd.html)
  and [`as.POSIXct()`](https://rdrr.io/r/base/as.POSIXlt.html) are
  examples of functions which can be used to store dates as an
  appropriate class.

## Value

A character vector of financial years in the form '2017/18'.

## Details

The PHS accepted format for financial year is YYYY/YY e.g. 2017/18.

## Examples

``` r
x <- lubridate::dmy(c(21012017, 04042017, 17112017))
extract_fin_year(x)
#> [1] "2016/17" "2017/18" "2017/18"
```
