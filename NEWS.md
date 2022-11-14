# phsmethods 0.2.2

- Improve `chi_check()` function to make it more efficient and run faster.

- Improve "Using phsmethods" section in readme to be shorter and more accessible. 

- Update all errors, warnings and messages to use the `cli` package. 

- Improve errors when giving incorrect types to some functions.

# phsmethods 0.2.1 (2022-02-11)

- Three functions renamed to improve code clarity: `postcode()` to `format_postcode()`; `age_group()` to `create_age_groups()`; `fin_year()` to `extract_fin_year()`. The old functions will still work but will produce a warning. After a reasonable amount of time they will be removed completely.

- New functions added:
`age_calculate()`([#65](https://github.com/Public-Health-Scotland/phsmethods/issues/65), [@Nic-chr](https://github.com/Nic-Chr));
`dob_from_chi()`([#42](https://github.com/Public-Health-Scotland/phsmethods/issues/42), [@Moohan](https://github.com/Moohan)); and 
`age_from_chi()`([#42](https://github.com/Public-Health-Scotland/phsmethods/issues/42), [@Moohan](https://github.com/Moohan))

- Change the output for `chi_check` so that empty string ("") reports as missing ([#76](https://github.com/Public-Health-Scotland/phsmethods/issues/76))

# phsmethods 0.2.0 (2020-04-17)

- New functions added: `age_group()`([#23](https://github.com/Health-SocialCare-Scotland/phsmethods/issues/23), [@chrisdeans](https://github.com/chrisdeans)); `chi_check()`([#30](https://github.com/Health-SocialCare-Scotland/phsmethods/issues/30), [@graemegowans](https://github.com/graemegowans)); `chi_pad()`([#30](https://github.com/Health-SocialCare-Scotland/phsmethods/issues/30), [@graemegowans](https://github.com/graemegowans)); and `match_area()`([#13](https://github.com/Health-SocialCare-Scotland/phsmethods/issues/13), [@jvillacampa](https://github.com/jvillacampa)).

- The first argument of `postcode()` is now `x`, as opposed to `string`. This is unlikely to break much, if any, existing code. `postcode()` is also now slightly faster.

- `phsmethods` no longer imports `stringi`.

- `phsmethods` now depends on a version of R >= 2.10.

- [Jack Hannah](https://github.com/jackhannah95) is no longer a maintainer.

# phsmethods 0.1.1 (2020-02-10)

- `file_size()`, `fin_year()`, `qtr()`, `qtr_end()`, `qtr_next()` and `qtr_prev()` now use `inherits(x, "y")` instead of `class(x) == "y"` to check class. The reasoning is explained in this [blogpost by Martin Maechler](https://developer.r-project.org/Blog/public/2019/11/09/when-you-think-class.-think-again/index.html).

- The performance of `fin_year()` has been improved. The function now extracts the unique date(s) from the input, calculates the associated financial year(s), and joins to the original input. This is in contrast with the original method, which directly calculated the financial year of all input dates individually.

# phsmethods 0.1.0 (2020-01-24)

- Initial package release.
- `file_size()`, `fin_year()`, `postcode()`, `qtr()`, `qtr_end()`, `qtr_next()` and `qtr_prev()` functions added.
