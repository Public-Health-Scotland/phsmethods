test_that("sex_from_chi returns expected simple results", {
  # Default behaviour is to check the chi first
  expect_equal(
    sex_from_chi(c(
      "0101011237",
      "0101336489",
      "0101405073",
      "0101625707",
      "0113201234",
      "123456789",
      "12345678900",
      "010120123?",
      NA
    )),
    c(1, 2, 1, 2, NA, NA, NA, NA, NA)
  )

  # Don't check the CHI
  expect_equal(
    sex_from_chi(c(
      "0101011237",
      "0101336489",
      "0101405073",
      "0101625707",
      "0113201234",
      "123456789",
      "12345678900",
      "010120123?",
      NA
    ), chi_check = FALSE),
    c(1, 2, 1, 2, 1, 1, 1, 1, NA)
  )
})

test_that("sex_from_chi works with custom values", {
  expect_message(
    sex_from_chi(c(
      "0101011237",
      "0101336489",
      "0113201234",
      NA
    ),
    male_value = "M",
    female_value = "F"
    )
  )

  expect_equal(
    suppressMessages(
      sex_from_chi(c(
        "0101011237",
        "0101336489",
        "0113201234",
        NA
      ),
      male_value = "M",
      female_value = "F"
      )
    ),
    c("M", "F", NA, NA)
  )

  expect_error(
    sex_from_chi("0101011237",
      male_value = "M"
    ),
    "`male_value` and `female_value` must be of the same class\\..*?$"
  )

  expect_error(
    sex_from_chi("0101011237",
      male_value = 1,
      female_value = 2L
    ),
    "`male_value` and `female_value` must be of the same class\\..*?$"
  )
})

test_that("sex_from_chi can return a factor", {
  expect_s3_class(
    sex_from_chi(c(
      "0101011237",
      "0101336489",
      "0113201234",
      NA
    ),
    as_factor = TRUE
    ),
    "factor"
  )

  expect_equal(
    sex_from_chi(c(
      "0101011237",
      "0101336489",
      "0113201234",
      NA
    ),
    as_factor = TRUE
    ),
    factor(c("Male", "Female", NA, NA), levels = c("Male", "Female"))
  )
})
