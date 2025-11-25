# Add a leading zero to nine-digit CHI numbers

`chi_pad` takes a nine-digit CHI number with `character` class and
prefixes it with a zero. Any values provided which are not a string
comprised of nine numeric digits remain unchanged.

## Usage

``` r
chi_pad(x)
```

## Arguments

- x:

  a CHI number or a vector of CHI numbers with `character` class.

## Value

The original character vector with CHI numbers padded if applicable.

## Details

The Community Health Index (CHI) is a register of all patients in NHS
Scotland. A CHI number is a unique, ten-digit identifier assigned to
each patient on the index.

The first six digits of a CHI number are a patient's date of birth in
DD/MM/YY format. The first digit of a CHI number must, therefore, be 3
or less. Depending on the source, CHI numbers are sometimes missing a
leading zero.

While a CHI number is made up exclusively of numeric digits, it cannot
be stored with `numeric` class in R. This is because leading zeros in
numeric values are silently dropped, a practice not exclusive to R. For
this reason, `chi_pad` accepts input values of `character` class only,
and returns values of the same class. It does not assess the validity of
a CHI number - please see
[`chi_check()`](https://public-health-scotland.github.io/phsmethods/reference/chi_check.md)
for that.

## Examples

``` r
chi_pad(c("101011237", "101201234"))
#> [1] "0101011237" "0101201234"
```
