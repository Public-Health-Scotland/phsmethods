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
