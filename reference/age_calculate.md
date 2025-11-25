# Calculate age between two dates

This function calculates the age between two dates using functions in
`lubridate`. It calculates age in either years or months.

## Usage

``` r
age_calculate(
  start,
  end = if (lubridate::is.Date(start)) Sys.Date() else Sys.time(),
  units = c("years", "months"),
  round_down = TRUE
)
```

## Arguments

- start:

  A start date (e.g. date of birth) which must be supplied with `Date`
  or `POSIXct` or `POSIXlt` class.
  [`base::as.Date()`](https://rdrr.io/r/base/as.Date.html),
  [`lubridate::dmy()`](https://lubridate.tidyverse.org/reference/ymd.html)
  and [`as.POSIXct()`](https://rdrr.io/r/base/as.POSIXlt.html) are
  examples of functions which can be used to store dates as an
  appropriate class.

- end:

  An end date which must be supplied with `Date` or `POSIXct` or
  `POSIXlt` class. Default is
  [`Sys.Date()`](https://rdrr.io/r/base/Sys.time.html) or
  [`Sys.time()`](https://rdrr.io/r/base/Sys.time.html) depending on the
  class of `start`.

- units:

  Type of units to be used. years and months are accepted. Default is
  `years`.

- round_down:

  Should returned ages be rounded down to the nearest whole number.
  Default is `TRUE`.

## Value

A numeric vector representing the ages in the given units.

## Examples

``` r
library(lubridate)
#> 
#> Attaching package: ‘lubridate’
#> The following objects are masked from ‘package:base’:
#> 
#>     date, intersect, setdiff, union
birth_date <- lubridate::ymd("2020-02-29")
end_date <- lubridate::ymd("2022-02-21")
age_calculate(birth_date, end_date)
#> [1] 1
age_calculate(birth_date, end_date, units = "months")
#> [1] 23

# If the start day is leap day (February 29th), age increases on 1st March
# every year.
leap1 <- lubridate::ymd("2020-02-29")
leap2 <- lubridate::ymd("2022-02-28")
leap3 <- lubridate::ymd("2022-03-01")

age_calculate(leap1, leap2)
#> [1] 1
age_calculate(leap1, leap3)
#> [1] 2
```
