test_that("Return correct age groups", {
  expect_identical(
    create_age_groups(
      c(4, 51, 21, 89),
      breaks = seq(0, 80, 10),
      as_factor = FALSE
    ),
    c("0-9", "50-59", "20-29", "80+")
  )

  expect_identical(
    create_age_groups(
      c(8, 94, 44, 55, 14),
      breaks = seq(0, 90, 5),
      as_factor = TRUE
    ),
    factor(
      c("5-9", "90+", "40-44", "55-59", "10-14"),
      levels = c(
        "0-4",
        "5-9",
        "10-14",
        "15-19",
        "20-24",
        "25-29",
        "30-34",
        "35-39",
        "40-44",
        "45-49",
        "50-54",
        "55-59",
        "60-64",
        "65-69",
        "70-74",
        "75-79",
        "80-84",
        "85-89",
        "90+"
      ),
      ordered = TRUE
    )
  )

  expect_identical(
    create_age_groups(
      c(81, 86, 33, 11),
      breaks = seq(4, 84, 3),
      as_factor = FALSE
    ),
    c("79-81", "82+", "31-33", "10-12")
  )

  expect_identical(
    create_age_groups(
      c(0, 99, 1000, 5, 5),
      breaks = seq(5, 90, 5),
      as_factor = FALSE
    ),
    c(NA, "90+", "90+", "5-9", "5-9")
  )
})

test_that("Default value for age groups", {
  expect_identical(
    create_age_groups(10, as_factor = TRUE),
    factor(
      c("10-14"),
      levels = c(
        "0-4",
        "5-9",
        "10-14",
        "15-19",
        "20-24",
        "25-29",
        "30-34",
        "35-39",
        "40-44",
        "45-49",
        "50-54",
        "55-59",
        "60-64",
        "65-69",
        "70-74",
        "75-79",
        "80-84",
        "85-89",
        "90+"
      ),
      ordered = TRUE
    )
  )
})


test_that("Input validation for as_factor and breaks", {
  expect_error(
    create_age_groups(10, as_factor = "TRUE"),
    "must be a .+?logical.+? not a .+?character.+?"
  )
  expect_error(
    create_age_groups(10, as_factor = c(TRUE, FALSE)),
    "must be length 1, not 2."
  )

  expect_error(
    create_age_groups(10, breaks = "0, 10, 20"),
    "must be a .+?numeric.+? vector, not a .+?character.+?"
  )
  expect_error(
    create_age_groups(c(1, 2, 3), breaks = c(0, 5.5, 10)),
    "must all be whole numbers"
  )
  expect_no_error(
    create_age_groups(c(1, 2, 3), breaks = c(0, 5 + 1e-9, 10))
  )
})


test_that("Handling of non-numeric values for x", {
  # If x is not numeric cut will error
  expect_error(
    create_age_groups(c("1", "57", "apple", "12"), as_factor = FALSE)
  )

  # This is true even if all elements are numbers stored as character
  expect_error(
    create_age_groups(c("26", "9", "78", "81"), as_factor = FALSE)
  )
})

test_that("Deprecated from/to/by arguments warn and work like breaks", {
  expect_warning(
    result <- create_age_groups(
      c(0, 9, 10, 19, 20),
      0,
      20,
      10,
      as_factor = FALSE
    ),
    "deprecated"
  )
  expect_identical(
    result,
    c("0-9", "0-9", "10-19", "10-19", "20+")
  )

  expect_error(
    create_age_groups(
      c(5, 14, 25),
      breaks = c(0, 10, 20, 30),
      from = 0,
      to = 30,
      by = 10
    ),
    "should no longer be used, use .*breaks.* only"
  )
})

test_that("Age groups work with breaks parameter for uniform and non-uniform bins", {
  expect_identical(
    create_age_groups(
      c(0, 9, 10, 19, 25, 29),
      breaks = seq(0, 30, 10),
      as_factor = FALSE
    ),
    c("0-9", "0-9", "10-19", "10-19", "20-29", "20-29")
  )

  expect_identical(
    create_age_groups(
      c(0, 17, 18, 44, 45, 64, 65, 90),
      breaks = c(0, 18, 45, 65),
      as_factor = TRUE
    ),
    factor(
      c("0-17", "0-17", "18-44", "18-44", "45-64", "45-64", "65+", "65+"),
      levels = c("0-17", "18-44", "45-64", "65+"),
      ordered = TRUE
    )
  )
})

test_that("NAs, fractional ages, and invalid values are handled correctly", {
  expect_identical(
    create_age_groups(c(NA, 5), breaks = seq(0, 10, 5), as_factor = TRUE),
    factor(
      c(NA, "5-9"),
      levels = c("0-4", "5-9", "10+"),
      ordered = TRUE
    )
  )

  expect_error(
    create_age_groups(c(-1, 5), breaks = c(0, 5, 10)),
    "cannot contain negative ages"
  )

  expect_error(
    create_age_groups(10, breaks = 0),
    "must have at least 2 values"
  )
  expect_error(
    create_age_groups(10, breaks = c(0, 10, 5)),
    "must be strictly increasing and contain no duplicates"
  )
  expect_error(
    create_age_groups(10, breaks = c(0, 5, 5, 10)),
    "must be strictly increasing and contain no duplicates"
  )
})
