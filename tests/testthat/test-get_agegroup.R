context("test-get_agegroup")

test_that("Return correct age groups", {
  expect_identical(
    get_agegroup(c(4, 51, 21, 89),
                 breaks = seq(0, 90, 10),
                 as_factor = F),
    c("0-9", "50-59", "20-29", "80-89"))

  expect_identical(
    get_agegroup(c(8, 94, 44, 55, 14),
                 breaks = seq(0, 90, 5)),
    factor(c("5-9", "90+", "40-44", "55-59", "10-14"),
           levels = c("0-4", "5-9", "10-14", "15-19","20-24", "25-29", "30-34",
                      "35-39", "40-44", "45-49", "50-54", "55-59", "60-64",
                      "65-69", "70-74", "75-79", "80-84", "85-89", "90+"),
           ordered = T))

  expect_identical(
    get_agegroup(c(81, 86, 33, 11),
                 breaks=c(86, 34, 32, 87)),
    factor(c("34-85", "86", "32-33", "0-31"),
           levels = c("0-31", "32-33", "34-85", "86", "87+"),
           ordered = T))

  expect_identical(
    get_agegroup(c(0, 99, 1000, 5, 5),
                 breaks = seq(0, 90, 5),
                 as_factor = F),
    c("0-4", "90+", "90+", "5-9", "5-9"))
})

test_that("Default value for breaks", {
  expect_identical(
    get_agegroup(10),
    factor(c("10-14"),
           levels = c("0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34",
                      "35-39", "40-44", "45-49", "50-54", "55-59", "60-64",
                      "65-69", "70-74", "75-79", "80-84", "85-89", "90+"),
           ordered = T))
})


test_that("Non-numeric values for x converted with warning", {
  expect_warning(get_agegroup("test"))

  expect_warning(a <- get_agegroup(c("26", "9", "78", "81"), as_factor = F))
  expect_equal(a, c("25-29", "5-9", "75-79", "80-84"))

  expect_warning(a <- get_agegroup(c("1", "57", "apple", "12"), as_factor = F))
  expect_equal(a, c("0-4", "55-59", NA, "10-14"))
})

test_that("Out of order breaks", {
  expect_identical(
    get_agegroup(c(7, 21, 14),
                 breaks = c(15, 5, 20, 10)),
    factor(c("5-9", "20+", "10-14"),
           levels = c("0-4", "5-9", "10-14", "15-19", "20+"),
           ordered = T))
})

test_that("Duplicate breaks", {
  expect_identical(
    get_agegroup(c(7, 21, 14),
                 breaks = c(5, 10, 10, 15, 5, 20)),
    factor(c("5-9", "20+", "10-14"),
           levels = c("0-4", "5-9", "10-14", "15-19", "20+"),
           ordered = T))
})

test_that("Excluding zero", {
  expect_identical(
    get_agegroup(c(7, 21, 14),
                 breaks = c(10, 20),
                 include_zero = F),
    factor(c(NA, "20+", "10-19"),
           levels = c("10-19", "20+"),
           ordered = T))
})

test_that("Excluding infinity", {
  expect_identical(
    get_agegroup(c(7, 21, 14),
                 breaks = c(10, 20),
                 include_inf = F),
    factor(c("0-9", NA, "10-19"),
           levels = c("0-9", "10-19"),
           ordered = T))
})

test_that("Exclude zero and infinity", {
  expect_identical(
    get_agegroup(c(7, 21, 14),
                 breaks = c(10, 20),
                 include_inf = F,
                 include_zero = F),
    factor(c(NA, NA, "10-19"),
           levels = c("10-19"),
           ordered = T))
})

test_that("Single break value", {
  expect_identical(
    get_agegroup(c(7, 21, 14),
                 breaks = 21,
                 include_inf = F,
                 include_zero = F),
    factor(c(NA, "21",  NA),
           levels = "21",
           ordered = T))
})

test_that("Agegroup seperator", {
  expect_identical(
    get_agegroup(c(7, 21, 14),
                 breaks = c(10, 11, 20),
                 sep=" to "),
    factor(c("0 to 9", "20+", "11 to 19"),
           levels = c("0 to 9", "10", "11 to 19", "20+"),
           ordered = T))
})

test_that("Above character value",{
  expect_identical(
    get_agegroup(c(7, 21, 14),
                 breaks = c(10, 20),
                 above.char = " and above"),
    factor(c("0-9", "20 and above", "10-19"),
           levels = c("0-9", "10-19", "20 and above"),
           ordered = T))
})

test_that("get_agegroup_seq functionality",{
  expect_identical(
    get_agegroup_seq(c(4, 51, 21, 89), from=0, to=90, by=10),
    factor(c("0-9", "50-59", "20-29", "80-89"),
           levels = c("0-9", "10-19", "20-29", "30-39", "40-49",
                      "50-59", "60-69", "70-79", "80-89", "90+"),
           ordered = T)
    )
  expect_identical(
    get_agegroup_seq(c(8, 94, 44, 55, 14)),
    factor(c("5-9", "90+", "40-44", "55-59", "10-14"),
           levels = c("0-4", "5-9", "10-14", "15-19","20-24", "25-29", "30-34",
                      "35-39", "40-44", "45-49", "50-54", "55-59", "60-64",
                      "65-69", "70-74", "75-79", "80-84", "85-89", "90+"),
           ordered = T))
  expect_identical(
    get_agegroup_seq(c(7, 21, 14, 32),
                 from = 10, to = 30, by = 10,
                 include_inf = F,
                 include_zero = F,
                 sep="_",
                 as_factor = F),
    c(NA, "20_29", "10_19", NA))
  expect_error(
    get_agegroup_seq(c(7, 21, 14),
                     breaks = c(10, 20, 30))
  )
})

test_that("Negative values in breaks gives warning", {
  expect_warning(a <- get_agegroup(c(-7, -1, 0, 4), breaks = c(-10, 10)))
  expect_identical(a, factor(c("-10--1", "-10--1",  "0-9", "0-9"),
                             levels = c("-10--1", "0-9", "10+"),
                             ordered = T))
})

test_that("Fractional values in breaks gives warning", {
  expect_warning(
    a <- get_agegroup(c(7, 21, 14, 10.4, 10.6), breaks = c(5, 10.5, 20)))
  expect_identical(a, factor(c("5-9.5", "20+", "10.5-19", "5-9.5", "10.5-19"),
                             levels = c("0-4", "5-9.5", "10.5-19", "20+"),
                             ordered = T))
})
