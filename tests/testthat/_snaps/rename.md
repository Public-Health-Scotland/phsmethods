# postcode is deprecated

    Code
      expect_equal(stringr::str_length(postcode("G26QE", format = "pc7")), 7)
    Warning <lifecycle_warning_deprecated>
      `postcode()` was deprecated in phsmethods 0.2.0.
      Please use `format_postcode()` instead.
    Code
      expect_equal(stringr::str_length(postcode("G26QE", format = "pc8")), 6)
    Warning <lifecycle_warning_deprecated>
      `postcode()` was deprecated in phsmethods 0.2.0.
      Please use `format_postcode()` instead.
    Code
      expect_equal(stringr::str_length(postcode(c("KA89NB", "PA152TY"), format = "pc7")),
      c(7, 7))
    Warning <lifecycle_warning_deprecated>
      `postcode()` was deprecated in phsmethods 0.2.0.
      Please use `format_postcode()` instead.
    Code
      expect_equal(stringr::str_length(postcode(c("KA89NB", "PA152TY"), format = "pc8")),
      c(7, 8))
    Warning <lifecycle_warning_deprecated>
      `postcode()` was deprecated in phsmethods 0.2.0.
      Please use `format_postcode()` instead.
    Code
      expect_equal(postcode("G36RB"), "G3  6RB")
    Warning <lifecycle_warning_deprecated>
      `postcode()` was deprecated in phsmethods 0.2.0.
      Please use `format_postcode()` instead.
    Code
      expect_equal(postcode("G432XR"), "G43 2XR")
    Warning <lifecycle_warning_deprecated>
      `postcode()` was deprecated in phsmethods 0.2.0.
      Please use `format_postcode()` instead.
    Code
      expect_equal(postcode("DG29BA"), "DG2 9BA")
    Warning <lifecycle_warning_deprecated>
      `postcode()` was deprecated in phsmethods 0.2.0.
      Please use `format_postcode()` instead.
    Code
      expect_equal(postcode("FK101RY"), "FK101RY")
    Warning <lifecycle_warning_deprecated>
      `postcode()` was deprecated in phsmethods 0.2.0.
      Please use `format_postcode()` instead.
    Code
      expect_equal(postcode("E1W3TJ"), "E1W 3TJ")
    Warning <lifecycle_warning_deprecated>
      `postcode()` was deprecated in phsmethods 0.2.0.
      Please use `format_postcode()` instead.
    Code
      expect_equal(postcode("EC1Y8SE"), "EC1Y8SE")
    Warning <lifecycle_warning_deprecated>
      `postcode()` was deprecated in phsmethods 0.2.0.
      Please use `format_postcode()` instead.
    Code
      input_hampden <- c("G429BA", "g429ba", "G42 9BA", "G 4 2 9 B A", "G429b    a")
      formatted_hampden <- suppressWarnings(postcode(input_hampden))
      expect_true(length(unique(formatted_hampden)) == 1)
      expect_equal(unique(formatted_hampden), "G42 9BA")
      expect_true(is.na(suppressWarnings(postcode("G2?QE"))))
      expect_warning(postcode(c("G207AL", "G2O07AL")))
    Warning <simpleWarning>
      1 non-NA input value does not adhere to the standard UK postcode format (with or without spaces) and will be coded as NA. The standard format is:
      • 1 or 2 letters, followed by
      • 1 number, followed by
      • 1 optional letter or number, followed by
      • 1 number, followed by
      • 2 letters
    Code
      expect_equal(suppressWarnings(postcode(c("EH7 5QG", NA, "EH11 2NL", "EH5 2HF*"))),
      c("EH7 5QG", NA, "EH112NL", NA))
      input_dens <- c("Dd37Jy", "DD37JY", "D  d 337JY")
      warnings_dens <- capture_warnings(postcode(input_dens))
      expect_length(warnings_dens, 2)
      input_pittodrie <- c("ab245qh", NA, "ab245q", "A  B245QH")
      warnings_pittodrie <- capture_warnings(postcode(input_pittodrie))
      expect_length(warnings_pittodrie, 3)
      expect_warning(postcode("g2"), "^1")
    Warning <lifecycle_warning_deprecated>
      `postcode()` was deprecated in phsmethods 0.2.0.
      Please use `format_postcode()` instead.
    Code
      expect_warning(postcode(c("DG98BS", "dg98b")), "^1")
    Warning <lifecycle_warning_deprecated>
      `postcode()` was deprecated in phsmethods 0.2.0.
      Please use `format_postcode()` instead.
    Code
      expect_warning(postcode(c("KY1 1RZ", "ky1rz", "KY11 R", "KY11R!")), "^3")
    Warning <lifecycle_warning_deprecated>
      `postcode()` was deprecated in phsmethods 0.2.0.
      Please use `format_postcode()` instead.
    Code
      expect_warning(postcode(c("ML53RB", NA, "ML5", "???", 53, as.factor("ML53RB"))),
      "^4")
    Warning <lifecycle_warning_deprecated>
      `postcode()` was deprecated in phsmethods 0.2.0.
      Please use `format_postcode()` instead.

# age_group is deprecated

    Code
      expect_identical(age_group(c(4, 51, 21, 89), 0, 80, 10, as_factor = FALSE), c(
        "0-9", "50-59", "20-29", "80+"))
    Warning <lifecycle_warning_deprecated>
      `age_group()` was deprecated in phsmethods 0.2.0.
      Please use `create_age_groups()` instead.
    Code
      expect_identical(age_group(c(8, 94, 44, 55, 14), 0, 90, 5, as_factor = TRUE),
      factor(c("5-9", "90+", "40-44", "55-59", "10-14"), levels = c("0-4", "5-9",
        "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49",
        "50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80-84", "85-89", "90+"),
      ordered = TRUE))
    Warning <lifecycle_warning_deprecated>
      `age_group()` was deprecated in phsmethods 0.2.0.
      Please use `create_age_groups()` instead.
    Code
      expect_identical(age_group(c(81, 86, 33, 11), 4, 84, 3, as_factor = FALSE), c(
        "79-81", "82+", "31-33", "10-12"))
    Warning <lifecycle_warning_deprecated>
      `age_group()` was deprecated in phsmethods 0.2.0.
      Please use `create_age_groups()` instead.
    Code
      expect_identical(age_group(c(0, 99, 1000, 5, 5), 5, 90, 5, as_factor = FALSE),
      c(NA, "90+", "90+", "5-9", "5-9"))
    Warning <lifecycle_warning_deprecated>
      `age_group()` was deprecated in phsmethods 0.2.0.
      Please use `create_age_groups()` instead.
    Code
      expect_identical(age_group(10, as_factor = TRUE), factor(c("10-14"), levels = c(
        "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44",
        "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80-84",
        "85-89", "90+"), ordered = TRUE))
    Warning <lifecycle_warning_deprecated>
      `age_group()` was deprecated in phsmethods 0.2.0.
      Please use `create_age_groups()` instead.
    Code
      expect_error(age_group(c("1", "57", "apple", "12"), as_factor = FALSE))
    Warning <lifecycle_warning_deprecated>
      `age_group()` was deprecated in phsmethods 0.2.0.
      Please use `create_age_groups()` instead.
    Code
      expect_error(age_group(c("26", "9", "78", "81"), as_factor = FALSE))
    Warning <lifecycle_warning_deprecated>
      `age_group()` was deprecated in phsmethods 0.2.0.
      Please use `create_age_groups()` instead.

# fin_year is deprecated

    Code
      expect_equal(fin_year(as.Date("20120331", "%Y%m%d")), "2011/12")
    Warning <lifecycle_warning_deprecated>
      `fin_year()` was deprecated in phsmethods 0.2.0.
      Please use `extract_fin_year()` instead.
    Code
      expect_equal(fin_year(as.Date("20120401", "%Y%m%d")), "2012/13")
    Warning <lifecycle_warning_deprecated>
      `fin_year()` was deprecated in phsmethods 0.2.0.
      Please use `extract_fin_year()` instead.
    Code
      expect_equal(fin_year(as.POSIXct("20190104", format = "%Y%m%d")), "2018/19")
    Warning <lifecycle_warning_deprecated>
      `fin_year()` was deprecated in phsmethods 0.2.0.
      Please use `extract_fin_year()` instead.
    Code
      expect_equal(fin_year(as.Date("17111993", "%d%m%Y")), "1993/94")
    Warning <lifecycle_warning_deprecated>
      `fin_year()` was deprecated in phsmethods 0.2.0.
      Please use `extract_fin_year()` instead.
    Code
      expect_equal(fin_year(as.Date("19980404", "%Y%m%d")), "1998/99")
    Warning <lifecycle_warning_deprecated>
      `fin_year()` was deprecated in phsmethods 0.2.0.
      Please use `extract_fin_year()` instead.
    Code
      expect_equal(fin_year(as.Date("21-Jan-2017", "%d-%B-%Y")), "2016/17")
    Warning <lifecycle_warning_deprecated>
      `fin_year()` was deprecated in phsmethods 0.2.0.
      Please use `extract_fin_year()` instead.
    Code
      expect_equal(fin_year(as.POSIXct("20181401", format = "%Y%d%m")), "2017/18")
    Warning <lifecycle_warning_deprecated>
      `fin_year()` was deprecated in phsmethods 0.2.0.
      Please use `extract_fin_year()` instead.
    Code
      expect_equal(fin_year(lubridate::dmy(29102019)), "2019/20")
    Warning <lifecycle_warning_deprecated>
      `fin_year()` was deprecated in phsmethods 0.2.0.
      Please use `extract_fin_year()` instead.
    Code
      expect_error(fin_year("28102019"))
    Warning <lifecycle_warning_deprecated>
      `fin_year()` was deprecated in phsmethods 0.2.0.
      Please use `extract_fin_year()` instead.
    Code
      expect_error(fin_year("28-Oct-2019"))
    Warning <lifecycle_warning_deprecated>
      `fin_year()` was deprecated in phsmethods 0.2.0.
      Please use `extract_fin_year()` instead.
    Code
      expect_error(fin_year(as.numeric("28102019")))
    Warning <lifecycle_warning_deprecated>
      `fin_year()` was deprecated in phsmethods 0.2.0.
      Please use `extract_fin_year()` instead.
    Code
      expect_error(fin_year(as.factor("28-Oct-2019")))
    Warning <lifecycle_warning_deprecated>
      `fin_year()` was deprecated in phsmethods 0.2.0.
      Please use `extract_fin_year()` instead.
    Code
      expect_equal(fin_year(c(lubridate::dmy(5012020), NA)), c("2019/20", NA))
    Warning <lifecycle_warning_deprecated>
      `fin_year()` was deprecated in phsmethods 0.2.0.
      Please use `extract_fin_year()` instead.

