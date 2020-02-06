# phsmethods 0.1.1 (2020-01-29)
- `file_size()`, `fin_year()`, `qtr()`, `qtr_end()`, `qtr_next()` and `qtr_prev()` now use `inherits(x, "y")` instead of `class(x) == "y"` to check class. The reasoning is explained in this [blogpost by Martin Maechler](https://developer.r-project.org/Blog/public/2019/11/09/when-you-think-class.-think-again/index.html). The performance of `fin_year()` has been improved by adjusting the methodology to generate a vector of financial years from the unique elements of the input vector and matching them back to the original list.

# phsmethods 0.1.0 (2020-01-24)

- Initial package release.
- `file_size()`, `fin_year()`, `postcode()`, `qtr()`, `qtr_end()`, `qtr_next()` and `qtr_prev()` functions added.
