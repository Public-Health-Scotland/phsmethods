# Format a postcode

`format_postcode` takes a character string or vector of character
strings. It extracts the input values which adhere to the standard UK
postcode format (with or without spaces), assigns the appropriate amount
of spacing to them (for both pc7 and pc8 formats) and ensures all
letters are capitalised.

## Usage

``` r
format_postcode(x, format = c("pc7", "pc8"), quiet = FALSE)
```

## Arguments

- x:

  A character string or vector of character strings. Input values which
  adhere to the standard UK postcode format may be upper or lower case
  and will be formatted regardless of existing spacing. Any input values
  which do not adhere to the standard UK postcode format will generate
  an NA and a warning message - see **Value** section for more
  information.

- format:

  A character string denoting the desired output format. Valid options
  are `pc7` and `pc8`. The default is `pc7`. See **Value** section for
  more information on the string length of output values.

- quiet:

  (optional) If quiet is `TRUE` all messages and warnings will be
  suppressed. This is useful in a production context and when you are
  sure of the data or you are specifically using this function to remove
  invalid postcodes. This will also make the function a bit quicker as
  fewer checks are performed.

## Value

When `format` is set equal to `pc7`, `format_postcode` returns a
character string of length 7. 5 character postcodes have two spaces
after the 2nd character; 6 character postcodes have 1 space after the
3rd character; and 7 character postcodes have no spaces.

When `format` is set equal to `pc8`, `format_postcode` returns a
character string with maximum length 8. All postcodes, whether 5, 6 or 7
characters, have one space before the last 3 characters.

Any input values which do not adhere to the standard UK postcode format
will generate an NA output value and a warning message. A warning is
generated rather than an error so as not to let one erroneously recorded
postcode in a large input vector prevent the remaining entries from
being appropriately formatted.

Any input values which do adhere to the standard UK postcode format but
contain lower case letters will generate a warning message explaining
that these letters will be capitalised.

## Details

The standard UK postcode format (without spaces) is:

- 1 or 2 letters, followed by

- 1 number, followed by

- 1 optional letter or number, followed by

- 1 number, followed by

- 2 letters

[UK government
regulations](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/283357/ILRSpecification2013_14Appendix_C_Dec2012_v1.pdf)
mandate which letters and numbers can be used in specific sections of a
postcode. However, these regulations are liable to change over time. For
this reason, `format_postcode` does not validate whether a given
postcode actually exists, or whether specific numbers and letters are
being used in the appropriate places. It only assesses whether the given
input is consistent with the above format and, if so, assigns the
appropriate amount of spacing and capitalises any lower case letters.

## Examples

``` r
format_postcode("G26QE")
#> [1] "G2  6QE"
format_postcode(c("KA89NB", "PA152TY"), format = "pc8")
#> [1] "KA8 9NB"  "PA15 2TY"

library(dplyr)
df <- tibble(postcode = c("G429BA", "G207AL", "DD37JY", "DG98BS"))
df %>%
  mutate(postcode = format_postcode(postcode))
#> # A tibble: 4 × 1
#>   postcode
#>   <chr>   
#> 1 G42 9BA 
#> 2 G20 7AL 
#> 3 DD3 7JY 
#> 4 DG9 8BS 
```
