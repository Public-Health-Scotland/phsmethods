context("test-age_group")

test_that("Return correct age groups", {
  expect_identical(
    age_group(c(4, 51, 21, 89),
              0, 80, 10,
              as_factor = F),
    c("0-9", "50-59", "20-29", "80+"))

  expect_identical(
    age_group(c(8, 94, 44, 55, 14),
              0, 90, 5,
              as_factor = T),
    factor(c("5-9", "90+", "40-44", "55-59", "10-14"),
           levels = c("0-4", "5-9", "10-14", "15-19","20-24", "25-29", "30-34",
                      "35-39", "40-44", "45-49", "50-54", "55-59", "60-64",
                      "65-69", "70-74", "75-79", "80-84", "85-89", "90+"),
           ordered = T))

  expect_identical(
    age_group(c(81, 86, 33, 11),
              4, 84, 3,
              as_factor = F),
    c("79-81", "82+", "31-33", "10-12"))

  expect_identical(
    age_group(c(0, 99, 1000, 5, 5),
              5, 90, 5,
              as_factor = F),
    c(NA, "90+", "90+", "5-9", "5-9"))
})

test_that("Default value for age groups", {
  expect_identical(
    age_group(10, as_factor = T),
    factor(c("10-14"),
           levels = c("0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34",
                      "35-39", "40-44", "45-49", "50-54", "55-59", "60-64",
                      "65-69", "70-74", "75-79", "80-84", "85-89", "90+"),
           ordered = T))
})


test_that("Handling of non-numeric values for x", {
  expect_warning(age_group("test"))

  expect_warning(a <- age_group(c("26", "9", "78", "81"), as_factor = F),
                 regexp = NA)
  expect_equal(a, c("25-29", "5-9", "75-79", "80-84"))

  expect_warning(a <- age_group(c("1", "57", "apple", "12"), as_factor = F))
  expect_equal(a, c("0-4", "55-59", NA, "10-14"))
})
