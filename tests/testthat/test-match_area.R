context("test-match_area")

testthat::test_that("Expect the same names as in sample dataframe", {

  test_df <- data.frame(
    code = c("S20000010", "S01002363", "S01004303", "S02000656", "S02001042",
             "S08000020", "S12000013", "S12000048", "S13002522",
             "S13002873", "S14000020", "S16000124", "S22000004"),
    name_orig = c("Eaglesham", "Marybank to Newvalley", "Elgin South Lesmurdie",
                  "Govan and Linthouse", "Peebles North", "Grampian",
                  "Na h-Eileanan Siar", "Perth and Kinross", "Dunoon",
                  "Arbroath East and Lunan", "East Lothian",
                  "Hamilton, Larkhall and Stonehouse", "Banff")) %>%
    match_area_names("code") %>%
    dplyr::mutate(check = ifelse(name_orig == area_name, TRUE, FALSE))

  testthat::expect_true(all(test_df$check == T))

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
