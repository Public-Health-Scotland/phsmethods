test_that("Returns the correct area names", {
  expect_equal(match_area(c("S20000010",
                            "S01002363",
                            "S01004303",
                            "S02000656",
                            "S02001042",
                            "S08000020",
                            "S12000013",
                            "S12000048",
                            "S13002522",
                            "S13002873",
                            "S14000020",
                            "S16000124",
                            "S22000004")),
               c("Eaglesham",
                 "Marybank to Newvalley",
                 "Elgin South Lesmurdie",
                 "Govan and Linthouse",
                 "Peebles North",
                 "Grampian",
                 "Na h-Eileanan Siar",
                 "Perth and Kinross",
                 "Dunoon",
                 "Arbroath East and Lunan",
                 "East Lothian",
                 "Hamilton, Larkhall and Stonehouse",
                 "Banff"))
})

test_that("Handles NA input values correctly", {
  expect_true(is.na(match_area(NA)))
  expect_equal(match_area(c("S13002781", NA, NA, "S13003089")),
               c("Ayr North", NA, NA, "Ayr North"))
})

test_that("Produces warnings for geography codes of invalid length", {
  expect_warning(match_area("tiny changes"))

  # The last entry is only 8 characters
  expect_warning(match_area(c(NA, "S01012487", "S0101248")))
})

test_that("Produces no warning for codes of valid length with no match", {
  expect_silent(match_area("S01000001"))
  expect_silent(match_area(c(NA, "RA2703", "123456789")))
})

test_that("Warns about the appropriate number of entries", {
  expect_warning(match_area(123223), "^1")
  expect_warning(match_area(c(NA, sprintf("RA270%d", seq(1:7)))), "^3")
})
