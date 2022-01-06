test_that("postcode is deprecated", {
  expect_snapshot({
    expect_equal(stringr::str_length(postcode("G26QE", format = "pc7")), 7)
    expect_equal(stringr::str_length(postcode("G26QE", format = "pc8")), 6)
    expect_equal(stringr::str_length(postcode(c("KA89NB", "PA152TY"),
                                                     format = "pc7")), c(7, 7))
    expect_equal(stringr::str_length(postcode(c("KA89NB", "PA152TY"),
                                                     format = "pc8")), c(7, 8))

    expect_equal(postcode("G36RB"), "G3  6RB")
    expect_equal(postcode("G432XR"), "G43 2XR")
    expect_equal(postcode("DG29BA"), "DG2 9BA")
    expect_equal(postcode("FK101RY"), "FK101RY")
    expect_equal(postcode("E1W3TJ"), "E1W 3TJ")
    expect_equal(postcode("EC1Y8SE"), "EC1Y8SE")

    input_hampden <- c("G429BA", "g429ba", "G42 9BA", "G 4 2 9 B A", "G429b    a")
    formatted_hampden <- suppressWarnings(postcode(input_hampden))

    expect_true(length(unique(formatted_hampden)) == 1)
    expect_equal(unique(formatted_hampden), "G42 9BA")

    expect_true(is.na(suppressWarnings(postcode("G2?QE"))))
    expect_warning(postcode(c("G207AL", "G2O07AL")))
    expect_equal(suppressWarnings(postcode(c("EH7 5QG", NA,
                                                    "EH11 2NL", "EH5 2HF*"))),
                 c("EH7 5QG", NA, "EH112NL", NA))

    input_dens <- c("Dd37Jy", "DD37JY", "D  d 337JY")
    warnings_dens <- capture_warnings(postcode(input_dens))
    expect_length(warnings_dens, 2)

    input_pittodrie <- c("ab245qh", NA, "ab245q", "A  B245QH")
    warnings_pittodrie <- capture_warnings(postcode(input_pittodrie))
    expect_length(warnings_pittodrie, 3)

    expect_warning(postcode("g2"), "^1")
    expect_warning(postcode(c("DG98BS", "dg98b")), "^1")
    expect_warning(postcode(c("KY1 1RZ", "ky1rz", "KY11 R", "KY11R!")), "^3")
    expect_warning(postcode(c("ML53RB", NA, "ML5",
                                     "???", 53, as.factor("ML53RB"))),
                   "^4")
  })
})

test_that("age_group is deprecated", {
  expect_snapshot({
      expect_identical(
        age_group(c(4, 51, 21, 89),
          0, 80, 10,
          as_factor = FALSE
        ),
        c("0-9", "50-59", "20-29", "80+")
      )

      expect_identical(
        age_group(c(8, 94, 44, 55, 14),
          0, 90, 5,
          as_factor = TRUE
        ),
        factor(c("5-9", "90+", "40-44", "55-59", "10-14"),
          levels = c(
            "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34",
            "35-39", "40-44", "45-49", "50-54", "55-59", "60-64",
            "65-69", "70-74", "75-79", "80-84", "85-89", "90+"
          ),
          ordered = TRUE
        )
      )

      expect_identical(
        age_group(c(81, 86, 33, 11),
          4, 84, 3,
          as_factor = FALSE
        ),
        c("79-81", "82+", "31-33", "10-12")
      )

      expect_identical(
        age_group(c(0, 99, 1000, 5, 5),
          5, 90, 5,
          as_factor = FALSE
        ),
        c(NA, "90+", "90+", "5-9", "5-9")
      )

      expect_identical(
        age_group(10, as_factor = TRUE),
        factor(c("10-14"),
          levels = c(
            "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34",
            "35-39", "40-44", "45-49", "50-54", "55-59", "60-64",
            "65-69", "70-74", "75-79", "80-84", "85-89", "90+"
          ),
          ordered = TRUE
        )
      )




      # If x is not numeric cut will error
      expect_error(age_group(c("1", "57", "apple", "12"), as_factor = FALSE))

      # This is true even if all elements are numbers stored as character
      expect_error(age_group(c("26", "9", "78", "81"), as_factor = FALSE))

  })
