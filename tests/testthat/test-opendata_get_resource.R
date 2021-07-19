test_that("returns data in the expected format", {
  gp_list_apr_2021 <- "a794d603-95ab-4309-8c92-b48970478c14"

  data <- opendata_get_resource(res_id = gp_list_apr_2021, rows = 1)

  expect_s3_class(data, "tbl_df")
  expect_length(data, 16)
  expect_equal(nrow(data), 1)
})

test_that("errors properly", {
  # wrong type
  expect_error(opendata_get_resource(res_id = 123))
  # Invalid format (doesn't match regex)
  expect_error(opendata_get_resource("a794d603-95ab-4309-8c92-b48970478c1"),
    regexp = "The resource ID supplied \\('.+?'\\) is invalid"
  )
  # Correct format but not real
  expect_error(opendata_get_resource("00000000-0000-0000-0000-000000000000"),
    regexp = "Not Found \\(HTTP 404\\)\\."
  )
})

test_that("returns full data if rows not supplied", {
  gp_list_apr_2021 <- "a794d603-95ab-4309-8c92-b48970478c14"

  data <- opendata_get_resource(res_id = gp_list_apr_2021)

  expect_equal(nrow(data), 926)
})

test_that("returns full data if rows > 99999", {
  prescriptions_apr_2021 <- "51b7ad3f-6d52-4165-94f4-92e322656c85"

  expect_message(data <- opendata_get_resource(
    res_id = prescriptions_apr_2021,
    rows = 100000
  ),
  regexp = "Queries for more than 99,999 rows of data will return the full resource\\."
  )

  expect_equal(nrow(data), 1142605)
})
