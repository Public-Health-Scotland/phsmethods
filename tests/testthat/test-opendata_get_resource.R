test_that("returns data in the expected format", {
  gp_list_apr_2021 <- "a794d603-95ab-4309-8c92-b48970478c14"

  data <- opendata_get_resource(res_id = gp_list_apr_2021, rows = 1)

  expect_s3_class(data, "tbl_df")
  expect_length(data, 16)
  expect_equal(nrow(data), 1)
})

test_that("errors properly", {
  expect_error(opendata_get_resource(res_id = 123))
  # Valid res-id format
  expect_error(opendata_get_resource("00000000-0000-0000-0000-000000000000"),
    regexp = "HTTP 404"
  )
})

test_that("accepts valid res ids", {
  expect_true(opendata_check_res_id("2dd8534b-0a6f-4744-9253-9565d62f96c2"))
  expect_true(opendata_check_res_id("2f8af19a-cecd-4abf-92c0-968807d5be6d"))
  expect_true(opendata_check_res_id("32a2ab8f-c02d-4657-abae-3900bdced1ef"))
  expect_true(opendata_check_res_id("3349540e-dc63-4d6d-a78b-00387b9aca50"))
  expect_true(opendata_check_res_id("34539f10-62fc-4b3c-8691-1f8f023da601"))
  expect_true(opendata_check_res_id("356eb0c9-3f73-4eab-80bf-7c816118f7b2"))
  expect_true(opendata_check_res_id("427f9a25-db22-4014-a3bc-893b68243055"))
  expect_true(opendata_check_res_id("42db71e6-c7a6-4454-8bb2-d110da6c93e2"))
  expect_true(opendata_check_res_id("4e288e0c-90c4-4f9d-9ce9-efa5741f08ae"))
  expect_true(opendata_check_res_id("4f3d240a-49f0-42f8-9639-4ac70a076c48"))
  expect_true(opendata_check_res_id("538d2526-1fc9-431a-9efc-fb1008e76442"))
  expect_true(opendata_check_res_id("54601e83-f93f-4661-9acd-39ff0a1bb19c"))
  expect_true(opendata_check_res_id("558f1c91-33a2-42fd-af0f-0066d6b0e4c1"))
  expect_true(opendata_check_res_id("571f5278-d6a5-4051-84c8-c01d688aa3ea"))
})

test_that("rejects malformed res ids", {
  # Non hexadecimal characters
  expect_false(opendata_check_res_id("2zz8534g-0a6f-4744-9253-9565d62f96c2"))

  # Non character class
  expect_false(opendata_check_res_id(2348534502474492539565602962))

  # Incorrect length
  expect_false(opendata_check_res_id("54601e83-f93fabc-4661-9acd-39ff0a1bb19c"))

  # Uppercase characters
  expect_false(opendata_check_res_id("571F5278-D6A5-4051-84C8-C01D688AA3EA"))
})
