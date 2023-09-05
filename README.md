
<!-- README.md is generated from README.Rmd. Please edit that file -->

# phsmethods

[![GitHub release (latest by
date)](https://img.shields.io/github/v/release/Public-Health-Scotland/phsmethods)](https://github.com/Public-Health-Scotland/phsmethods/releases/latest)
[![Build
Status](https://github.com/Public-Health-Scotland/phsmethods/workflows/R-CMD-check/badge.svg)](https://github.com/Public-Health-Scotland/phsmethods/actions)
[![codecov](https://codecov.io/gh/Public-Health-Scotland/phsmethods/branch/master/graph/badge.svg)](https://app.codecov.io/gh/Public-Health-Scotland/phsmethods)

`phsmethods` contains functions for commonly undertaken analytical tasks
in [Public Health Scotland
(PHS)](https://www.publichealthscotland.scot/):

- `create_age_groups()` categorises ages into groups
- `chi_check()` assesses the validity of a CHI number
- `chi_pad()` adds a leading zero to nine-digit CHI numbers
- `sex_from_chi()` extracts the sex of a person from a CHI number
- `file_size()` returns the names and sizes of files in a directory
- `extract_fin_year()` assigns a date to a financial year in the format
  `YYYY/YY`
- `match_area()` converts geography codes into area names
- `format_postcode()` formats improperly recorded postcodes
- `qtr()`, `qtr_end()`, `qtr_next()` and `qtr_prev()` assign a date to a
  quarter
- `age_calculate()` calculates age between two dates
- `dob_from_chi()` extracts Date of Birth (DoB) from the CHI number
- `age_from_chi()` extracts age from the CHI number

`phsmethods` can be used on both the [PHS
server](https://pwb.publichealthscotland.org/) and desktop versions of
RStudio.

## Installation

If you are using the PHS Posit Workbench the default repository is the
PHS Posit Package Manager, the benefit of this is that `phsmethods` is
listed there so you can install it with:

``` r
install.packages("phsmethods")
```

To install `phsmethods` directly from GitHub, the package `remotes` is
required, and can be installed with `install.packages("remotes")`.

You can then install `phsmethods` from GitHub with:

``` r
remotes::install_github("Public-Health-Scotland/phsmethods")
```

However, network security settings may prevent
`remotes::install_github()` from working on RStudio desktop. If this is
the case, `phsmethods` can be installed by downloading the [zip of the
repository](https://github.com/Public-Health-Scotland/phsmethods/archive/master.zip)
and running the following code (replacing the section marked `<>`,
including the arrows themselves):

``` r
remotes::install_local("<FILEPATH OF ZIPPED FILE>/phsmethods-master.zip",
  upgrade = "never"
)
```

## Using phsmethods

Load `phsmethods` using `library()`:

``` r
library(phsmethods)
```

To see the documentation for any `phsmethods`’ functions, type
`?function_name` into the RStudio console after loading the package:

``` r
?extract_fin_year
?format_postcode
```

You can access the full list of functions and their help pages on
[Reference page of pkgdown
website](https://public-health-scotland.github.io/phsmethods/reference/index.html).
You will be able to see some examples of each function.

There is also a very useful [PHS Methods online training
course](https://scotland.shinyapps.io/phs-learnr-phsmethods) which gives
you an interactive way to learn about this package.

## Contributing to phsmethods

At present, the maintainer of this package is [Tina
Fu](https://github.com/Tina815).

This package is intended to be in continuous development and
contributions may be made by anyone within PHS. If you would like to
contribute, please first create an
[issue](https://github.com/Public-Health-Scotland/phsmethods/issues) on
GitHub and assign **both** of the package maintainers to it. This is to
ensure that no duplication of effort occurs in the case of multiple
people having the same idea. The package maintainers will discuss the
issue and get back to you as soon as possible.

While the most obvious and eye-catching (as well as intimidating) way of
contributing is by writing a function, this isn’t the only way to make a
useful contribution. Fixing typos in documentation, for example, isn’t
the most glamorous way to contribute, but is of great help to the
package maintainers. Please see this [blog post by Jim
Hester](https://www.tidyverse.org/blog/2017/08/contributing/) for more
information on getting started with contributing to open-source
software.

When contributing, please create a
[branch](https://github.com/Public-Health-Scotland/phsmethods/branches)
in this repository and carry out all work on it. Please ensure you have
linked RStudio to your GitHub account using `usethis::edit_git_config()`
prior to making your contribution. When you are ready for a review,
please create a [pull
request](https://github.com/Public-Health-Scotland/phsmethods/pulls) and
assign **both** of the package maintainers as reviewers. One or both of
them will conduct a review, provide feedback and, if necessary, request
changes before merging your branch.

Please be mindful of information governance when contributing to this
package. No data files (aside from publicly available and downloadable
datasets or unless explicitly approved), server connection details,
passwords or person identifiable or otherwise confidential information
should be included anywhere within this package or any other repository
(whether public or private) used within PHS. This includes within code
and code commentary. For more information on security when using git and
GitHub, and on using git and GitHub for version control more generally,
please see the [Transforming Publishing
Programme](https://www.isdscotland.org/Products-and-Services/Transforming-Publishing-Programme/)’s
[Git guide](https://Public-Health-Scotland.github.io/git-guide/) and
[GitHub
guidance](https://github.com/Public-Health-Scotland/GitHub-guidance).

Please feel free to add yourself to the ‘Authors’ section of the
`Description` file when contributing. As a rule of thumb, please assign
your role as author (`"aut"`) when writing an exported function, and as
contributor (`"ctb"`) for anything else.

`phsmethods` will, as much as possible, adhere to the [tidyverse style
guide](https://style.tidyverse.org/) and the [rOpenSci package
development guide](https://devguide.ropensci.org/). The most pertinent
points to take from these are:

- All function names should be in lower case, with words separated by an
  underscore
- Put a space after a comma, never before
- Put a space before and after infix operators such as `<-`, `==` and
  `+`
- Limit code to 80 characters per line
- Function documentation should be generated using
  [`roxygen2`](https://github.com/r-lib/roxygen2)
- All functions should be tested using
  [`testthat`](https://github.com/r-lib/testthat)
- The package should always pass `devtools::check()`

It’s not necessary to have experience with GitHub or of building an R
package to contribute to `phsmethods`. If you wish to contribute code
then, as long as you can write an R function, the package maintainers
can assist with error handling, writing documentation, testing and other
aspects of package development. It is advised, however, to consult
[Hadley Wickham’s R Packages book](https://r-pkgs.org/) prior to making
a contribution. It may also be useful to consult the
[documentation](https://github.com/Public-Health-Scotland/phsmethods/tree/master/R)
and
[tests](https://github.com/Public-Health-Scotland/phsmethods/tree/master/tests/testthat)
of existing functions within this package as a point of reference.

Please note that this README may fail to ‘Knit’ at times as a result of
network security settings. This will likely be due to the badges for the
package’s release version, continuous integration status and test
coverage at the top of the document. You should only make edits to the
`.Rmd` version, you can then knit yourself, or a GitHub action should
run and knit it for you when you open a pull request.
