# phsmethods 0.1.1 (2020-02-10)

- `file_size()`, `fin_year()`, `qtr()`, `qtr_end()`, `qtr_next()` and `qtr_prev()` now use `inherits(x, "y")` instead of `class(x) == "y"` to check class. The reasoning is explained in this [blogpost by Martin Maechler](https://developer.r-project.org/Blog/public/2019/11/09/when-you-think-class.-think-again/index.html).

- The performance of `fin_year()` has been improved. The function now extracts the unique date(s) from the input, calculates the associated financial year(s), and joins to the original input. This is in contrast with the original method, which directly calculated the financial year of all input dates individually.

# phsmethods 0.1.0 (2020-01-24)

- Initial package release.
- `file_size()`, `fin_year()`, `postcode()`, `qtr()`, `qtr_end()`, `qtr_next()` and `qtr_prev()` functions added.
