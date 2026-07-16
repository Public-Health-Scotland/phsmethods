test_that("Area lookup contains unique geography codes", {
  area_lookup$geo_code |>
    anyDuplicated() |>
    expect_identical(0L)
})

test_that("Area lookup contains no missing rows", {
  area_lookup$geo_code |>
    anyNA() |>
    expect_false()

  area_lookup$area_name |>
    anyNA() |>
    expect_false()
})

test_that("Returns the correct area names", {
  expect_equal(
    match_area(c(
      "S20000010",
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
      "S22000004"
    )),
    c(
      "Eaglesham",
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
      "Banff"
    )
  )
})

test_that("Returns the correct names containing non-ASCII characters", {
  match_area(c(
    "S13002605",
    "S13002606",
    "S13002672",
    "S13002936",
    "S13002999",
    "S13003138",
    "S13003139",
    "S13003140",
    "S13003141",
    "S13003142",
    "S13003143",
    "S19002355",
    "S19002508",
    "S20001990"
  )) |>
    expect_no_warning() |>
    expect_identical(
      c(
        "Steòrnabhagh a Deas",
        "Steòrnabhagh a Tuath",
        "Eilean a' Chèo",
        "Bo’ness and Blackness",
        "Eilean a' Chèo",
        "Sgìr’ Ùige agus Càrlabhagh",
        "Sgìre an Rubha",
        "Sgìre nan Loch",
        "Steòrnabhagh a Deas",
        "Steòrnabhagh a Tuath",
        "Uibhist a Deas, Èirisgeigh agus Beinn na Faoghla",
        paste(
          "Margaidh Ùr, Lacasdal and Bruach Mairi",
          "(Newmarket, Laxdale and Marybank)"
        ),
        "Steòrnabhagh (Stornoway)",
        "Steòrnabhagh (Stornoway)"
      )
    )
})

test_that("Handles NA input values correctly", {
  expect_true(is.na(match_area(NA)))
  expect_equal(
    match_area(c("S13002781", NA, NA, "S13003089")),
    c("Ayr North", NA, NA, "Ayr North")
  )
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
  expect_warning(match_area(123223), "1 non-NA input geography.*")
  expect_warning(
    match_area(c(NA, paste0("RA270", 1:7))),
    "3 non-NA input geographies.*"
  )
})

test_that("Returns the correct names for exceptional RA270 codes", {
  match_area(paste0("RA270", 1:4)) |>
    expect_no_warning() |>
    expect_identical(
      c(
        "No Fixed Abode",
        "Rest of UK (Outside Scotland)",
        "Outside the UK",
        "Unknown residency"
      )
    )
})

test_that("Returns NA for unmatched geography codes", {
  match_area(c("S01000001", "123456789")) |>
    expect_no_warning() |>
    expect_identical(c(NA_character_, NA_character_))
})

test_that("Returns NA for invalid-length unmatched codes", {
  match_area(c("invalid", "S0101248")) |>
    expect_identical(c(NA_character_, NA_character_)) |>
    expect_warning("2 non-NA input geographies")
})

test_that("Preserves input order and duplicate values", {
  match_area(c(
    "S13002781",
    "S20000010",
    "S13002781",
    "RA2703"
  )) |>
    expect_no_warning() |>
    expect_identical(
      c(
        "Ayr North",
        "Eaglesham",
        "Ayr North",
        "Outside the UK"
      )
    )
})

test_that("Returns one value for each input value", {
  x <- c(
    "S20000010",
    NA,
    "S01000001",
    "RA2701",
    "invalid",
    "S20000010"
  )

  match_area(x) |>
    expect_length(length(x)) |>
    expect_warning("1 non-NA input geography is not")
})

test_that("Matching is case sensitive", {
  match_area(c("s20000010", "S20000010")) |>
    expect_no_warning() |>
    expect_identical(c(NA_character_, "Eaglesham"))
})

test_that("Matching is sensitive to whitespace", {
  match_area(c(
    " S20000010",
    "S20000010 ",
    "S20000010"
  )) |>
    expect_identical(
      c(
        NA_character_,
        NA_character_,
        "Eaglesham"
      )
    ) |>
    expect_warning("2 non-NA input geographies")
})

test_that("Handles zero-length input", {
  match_area(character()) |>
    expect_no_warning() |>
    expect_identical(character())
})

test_that("Coerces non-character input to character", {
  match_area(123456789) |>
    expect_no_warning() |>
    expect_identical(NA_character_)
})
