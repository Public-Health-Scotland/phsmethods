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

