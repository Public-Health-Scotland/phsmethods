context("test-match_area_names")

testthat::test_that("Expect the same names as in sample dataframe", {
  test_df <- readRDS("tests/testthat/files/code_names_sample.rds") %>%
    match_area_names("code") %>%
    dplyr::mutate(check = ifelse(name_orig == area_name, TRUE, FALSE))

  testthat::expect_true(all(test_df$check == T))

})

testthat::test_that("Not necessarily an error, but if less than 18 some geographic
          entities might have dissapeared, if more some new ones could have been
          added and both cases might merit a check", {

  # Read in area name to geographic code lookup
  names_lookup <- readRDS("reference_files/area_name_lookup.rds")

  number_areas <- length(unique(substr(names_lookup$geo_code, 1, 3)))

  testthat::expect_true(number_areas == 18)

          })

testthat::test_that("Expect an error if object not a dataframe", {

  testthat::expect_error(test_object <- list() %>%
                           match_area_names("code") )

})

testthat::test_that("Expect an error if code variable is numeric", {

  testthat::expect_error(
    test_df <- data.frame(code = 1:10) %>%
      match_area_names("code")
  )

})


##END
