test_that("returns data in the expected format", {
  gp_list_apr_2021 <- "a794d603-95ab-4309-8c92-b48970478c14"

  data <- opendata_get_resource(res_id = gp_list_apr_2021, rows = 1)

  expect_s3_class(data, "tbl_df")
  expect_length(data, 16)
  expect_equal(nrow(data), 1)
})

test_that("errors properly", {
  expect_error(opendata_get_resource(res_id = 123))
  expect_error(opendata_get_resource("a794d603-95ab-4309-8c92-b48970478c1"),
               regexp = "HTTP 404")
})
