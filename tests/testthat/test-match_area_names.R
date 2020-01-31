context("test-match_area_names")

test_that("Expect the same names as in sample dataframe", {
  test_df <- readRDS("tests/testthat/files/code_names_sample.rds") %>%
    match_area_names("code") %>%
    mutate(check = ifelse(name_orig == area_name, TRUE, FALSE))

  expect_true(all(test_df$check == T))

})


test_that("Not necessarily an error, but if less than 19 some files might have dissapeared,
          if more some new ones could have been added and this might merit a check", {
  cl_out <- "/conf/linkage/output/lookups/Unicode/Geography/Scottish Postcode Directory/Codes and Names/"

  # Selecting name files for main geographies
  files_wanted <- paste0("Health Board Area|Council Area|Intermediate Zone|Data Zone|",
                         "Integration Authority|Parliamentary|Electoral")
  # List of name-code files in cl-out
  files <-  list.files(path = cl_out, pattern = "*.csv", full.names = TRUE)
  files <- files[grepl(files_wanted, files) == TRUE] #selecting only those of interest

  expect_true(length(files) == 19)

})


##END
