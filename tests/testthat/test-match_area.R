context("test-match_area")

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

test_that("Returns the correct geography codes", {
  expect_equal(match_area(c("Eaglesham",
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
                            "Banff"),
                          return = "code"),
               c(paste("S13000358, S13001614, S19000012, S19000846,",
                       "S19001492, S20000010, S20000674, S20001190"),
                 "S01002363",
                 "S01004303",
                 "S02000656, S02001856",
                 "S02001042, S02002293",
                 "S08000006, S08000020",
                 "S12000013",
                 "S12000024, S12000048, S37000023, S37000033",
                 paste("S02000135, S02001386, S13002522, S19000059,",
                       "S19000841, S19001487, S20000049, S20000671,",
                       "S20001187"),
                 "S13002514, S13002873",
                 "S12000010, S14000020, S16000025, S16000102, S37000010",
                 "S16000124",
                 paste("S02000099, S02001326, S13001291, S19000291,",
                       "S19000682, S19001326, S20000262, S20000548,",
                       "S20001064, S22000004")))
})

test_that("Handles NA input values correctly", {
  expect_true(is.na(match_area(NA)))
  expect_true(is.na(match_area(NA, return = "code")))
  expect_equal(match_area(c("S13002781", NA, NA, "S13003089")),
               c("Ayr North", NA, NA, "Ayr North"))
})
