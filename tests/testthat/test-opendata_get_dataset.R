test_that("returns data in the expected format", {
  data <- opendata_get_dataset(
    dataset_name = "gp-practice-populations",
    max_resources = 2,
    rows = 2
  )

  expect_s3_class(data, "tbl_df")
  expect_length(data, 24)
  expect_equal(nrow(data), 2 * 2)
})

test_that("errors properly", {
  expect_error(opendata_get_dataset("Mal-formed-name"),
    regexp = "The dataset name supplied \\('.+?'\\) is invalid"
  )
  expect_error(opendata_get_dataset("non-existent-data"),
    regexp = "The dataset name 'non-existent-data' was not found"
  )
  expect_error(opendata_get_dataset("gp-practice-pops"),
               regexp = "The dataset name 'gp-practice-pops' is incorrect\\.\\nDid you mean 'gp-practice-populations'\\?")
})
