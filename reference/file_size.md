# Calculate file size

**\[deprecated\]**

`file_size` takes a filepath and an optional regular expression pattern.
It returns the size of all files within that directory which match the
given pattern.

## Usage

``` r
file_size(filepath = getwd(), pattern = NULL)
```

## Arguments

- filepath:

  A character string denoting a filepath. Defaults to the working
  directory, [`getwd()`](https://rdrr.io/r/base/getwd.html).

- pattern:

  An optional character string denoting a
  [`regular expression()`](https://rdrr.io/r/base/regex.html) pattern.
  Only file names which match the regular expression will be returned.
  See the **See Also** section for resources regarding how to write
  regular expressions.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
listing the names of files within `filepath` which match `pattern` and
their respective sizes. The column names of this tibble are `name` and
`size`. If no `pattern` is specified, `file_size` returns the names and
sizes of all files within `filepath`. File names and sizes are returned
in alphabetical order of file name. Sub-folders contained within
`filepath` will return a file size of `0 B`.

If `filepath` is an empty folder, or `pattern` matches no files within
`filepath`, `file_size` returns `NULL`.

## Details

The sizes of files with certain extensions are returned with the type of
file prefixed. For example, the size of a 12 KB `.xlsx` file is returned
as `Excel 12 KB`. The complete list of explicitly catered-for file
extensions and their prefixes are as follows:

- `.xls`, `.xlsb`, `.xlsm` and `.xlsx` files are prefixed with `Excel`

- `.csv` files are prefixed with `CSV`

- `.sav` and `.zsav` files are prefixed with `SPSS`

- `.doc`, `.docm` and `.docx` files are prefixed with `Word`

- `.rds` files are prefixed with `RDS`

- `.txt` files are prefixed with `Text`,

- `.fst` files are prefixed with `FST`,

- `.pdf` files are prefixed with `PDF`,

- `.tsv` files are prefixed with `TSV`,

- `.html` files are prefixed with `HTML`,

- `.ppt`, `.pptm` and `.pptx` files are prefixed with `PowerPoint`,

- `.md` files are prefixed with `Markdown`

Files with extensions not contained within this list will have their
size returned with no prefix. To request that a certain extension be
explicitly catered for, please create an issue on
[GitHub](https://github.com/Public-Health-Scotland/phsmethods/issues).

File sizes are returned as the appropriate multiple of the unit byte
(bytes (B), kilobytes (KB), megabytes (MB), etc.). Each multiple is
taken to be 1,024 units of the preceding denomination.

## See also

For more information on using regular expressions, see this [Jumping
Rivers blog
post](https://www.jumpingrivers.com/blog/regular-expressions-every-r-programmer-should-know/)
and this
[vignette](https://stringr.tidyverse.org/articles/regular-expressions.html)
from the
[`stringr()`](https://stringr.tidyverse.org/reference/stringr-package.html)
package.

## Examples

``` r
# Name and size of all files in working directory
file_size()
#> Warning: `file_size()` was deprecated in phsmethods 1.1.0.
#> ℹ We think it is redundant, but if you still have a need for this function,
#>   please get in touch.
#> # A tibble: 10 × 2
#>    name                   size      
#>    <chr>                  <chr>     
#>  1 age_calculate.html     HTML 12 kB
#>  2 age_from_chi.html      HTML 16 kB
#>  3 area_lookup.html       HTML 7 kB 
#>  4 chi_check.html         HTML 12 kB
#>  5 chi_pad.html           HTML 8 kB 
#>  6 create_age_groups.html HTML 10 kB
#>  7 dob_from_chi.html      HTML 13 kB
#>  8 extract_fin_year.html  HTML 7 kB 
#>  9 figures                4 kB      
#> 10 index.html             HTML 6 kB 

# Name and size of .xlsx files only in working directory
file_size(pattern = "\\.xlsx$")
#> Warning: `file_size()` was deprecated in phsmethods 1.1.0.
#> ℹ We think it is redundant, but if you still have a need for this function,
#>   please get in touch.
#> NULL

# Size only of alphabetically first file in working directory
library(magrittr)
file_size() %>%
  dplyr::pull(size) %>%
  magrittr::extract(1)
#> Warning: `file_size()` was deprecated in phsmethods 1.1.0.
#> ℹ We think it is redundant, but if you still have a need for this function,
#>   please get in touch.
#> [1] "HTML 12 kB"
```
