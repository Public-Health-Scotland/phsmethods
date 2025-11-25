# Assign a date to a quarter

The qtr functions take a date input and calculate the relevant
quarter-related value from it. They all return the year as part of this
value.

- `qtr` returns the current quarter

- `qtr_end` returns the last month in the quarter

- `qtr_next` returns the next quarter

- `qtr_prev` returns the previous quarter

## Usage

``` r
qtr(date, format = c("long", "short"))

qtr_end(date, format = c("long", "short"))

qtr_next(date, format = c("long", "short"))

qtr_prev(date, format = c("long", "short"))
```

## Arguments

- date:

  A date which must be supplied with `Date` or `POSIXct`

- format:

  A `character` string specifying the format the quarter should be
  displayed in. Valid options are `long` (January to March 2018) and
  `short` (Jan-Mar 2018). The default is `long`.

## Value

A character vector of financial quarters in the specified format.

## Details

Quarters are defined as:

- January to March (Jan-Mar)

- April to June (Apr-Jun)

- July to September (Jul-Sep)

- October to December (Oct-Dec)

## Examples

``` r
x <- lubridate::dmy(c(26032012, 04052012, 23092012))
qtr(x)
#> [1] "January to March 2012"  "April to June 2012"     "July to September 2012"
qtr_end(x, format = "short")
#> [1] "Mar 2012" "Jun 2012" "Sep 2012"
qtr_next(x)
#> [1] "April to June 2012"       "July to September 2012"  
#> [3] "October to December 2012"
qtr_prev(x, format = "short")
#> [1] "Oct-Dec 2011" "Jan-Mar 2012" "Apr-Jun 2012"
```
