context("test-file_size")

test_that("Identifies correct number of files", {
  expect_equal(nrow(file_size(test_path("files"))), 8)
  expect_equal(nrow(file_size(test_path("files"), ".xlsx?$")), 2)
  expect_equal(nrow(file_size(test_path("files"), ".sav$")), 1)
  expect_null(file_size(test_path("files"), ".pdf$"))
})

test_that("Returns sizes with correct prefix", {
  expect_true(stringr::str_detect(file_size(test_path("files"), ".tsv$") %>%
                                    dplyr::pull(size),
                                  "^TSV [0-9]* [A-Z]?B$"))
})

test_that("Errors if supplied with invalid filepath", {
  expect_error(file_size(here::here("data")))
})
