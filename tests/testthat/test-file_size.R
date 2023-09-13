test_that("Returns a tibble", {
  expect_s3_class(file_size(test_path("files")), "tbl")
})

test_that("Identifies correct number of files", {
  expect_equal(nrow(file_size(test_path("files"))), 8)
  expect_equal(nrow(file_size(test_path("files"), ".xlsx?$")), 2)
  expect_equal(nrow(file_size(test_path("files"), ".sav$")), 1)
  expect_null(file_size(test_path("files"), ".pdf$"))
})

test_that("Returns sizes with correct prefix", {
  expect_match(
    file_size(test_path("files"), "tsv") %>%
      dplyr::pull(size),
    "^TSV 1 kB$"
  )
  expect_match(
    file_size(test_path("files"), "csv") %>%
      dplyr::pull(size),
    "^CSV 4 kB$"
  )
  expect_match(
    file_size(test_path("files"), "fst") %>%
      dplyr::pull(size),
    "^FST 897 B$"
  )
})

test_that("Returns sizes in alphabetical order", {
  expect_equal(
    file_size(test_path("files")) %>%
      dplyr::pull(name),
    file_size(test_path("files")) %>%
      dplyr::arrange(name) %>%
      dplyr::pull(name)
  )
})

test_that("Output is identical over time", {
  # Text files report as larger on Windows so snapshot per OS
  os <- ifelse(
    "windows" %in% tolower(Sys.info()[["sysname"]]),
    "windows",
    "UNIX"
  )

  expect_snapshot(file_size(test_path("files")), variant = os)
  expect_snapshot(file_size(test_path("files"), "xlsx?"), variant = os)
})

test_that("Errors if supplied with invalid filepath", {
  expect_error(file_size(test_path("reference_files")))
  expect_error(file_size(NA))
  expect_error(file_size(NULL))
})

test_that("Errors if supplied with invalid regular expression", {
  expect_error(file_size(test_path("files"), 1))
})
