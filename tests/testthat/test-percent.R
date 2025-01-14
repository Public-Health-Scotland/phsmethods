
test_that("as_percent", {

  expect_error(as_percent(NULL))
  expect_error(as_percent("1"))

  expect_equal(
    as_percent(0.1234567),
    structure(0.1234567, class = "percent", .digits = 2)
  )

  expect_equal(format(as_percent(0.045), digits = 0), "5%")
  expect_equal(round(as_percent(0.045)), as_percent(0.05))

})

test_that("as_percent works correctly", {
  expect_s3_class(as_percent(0.5), "percent")
  expect_type(as_percent(0.5), "double")

  expect_equal(as.character(as_percent(50)), "5,000%")
  expect_equal(as.character(as_percent(5)), "500%")
  expect_equal(as.character(as_percent(0.5)), "50%")
  expect_equal(as.character(as_percent(0.05)), "5%")
  expect_equal(as.character(as_percent(0.005)), "0.5%")
  expect_equal(as.character(as_percent(0.0005)), "0.05%")
  expect_equal(as.character(as_percent(0.00005)), "0.01%")

  expect_equal(format(as_percent(50)), "5,000%")
  expect_equal(format(as_percent(5)), "500%")
  expect_equal(format(as_percent(0.5)), "50%")
  expect_equal(format(as_percent(0.05)), "5%")
  expect_equal(format(as_percent(0.005)), "0.5%")
  expect_equal(format(as_percent(0.0005)), "0.05%")
  expect_equal(format(as_percent(0.00005)), "0.01%")
})

test_that("as_percent handles non-numeric input", {
  expect_error(as_percent("not a number"), regexp = "must be a <numeric> vector, not a <character> vector")
  expect_error(as_percent(list(1, 2, 3)), regexp = "must be a <numeric> vector, not a <list> vector")
})

test_that("round_half_up handles non-numeric input", {
  expect_error(round_half_up("not a number"), regexp = "must be a <numeric> vector, not a <character> vector")
  expect_error(round_half_up(list(1, 2, 3)), regexp = "must be a <numeric> vector, not a <list> vector")
})


test_that("signif_half_up handles non-numeric input", {
  expect_error(signif_half_up("not a number"), regexp = "must be a <numeric> vector, not a <character> vector")
  expect_error(signif_half_up(list(1, 2, 3)), regexp = "must be a <numeric> vector, not a <list> vector")
})


test_that("signif_half_up results are as expected", {
  # scalars
  expect_equal(
    signif_half_up(x = 12.5, digits = 2),
    13
  )
  expect_equal(
    signif_half_up(x = 0),
    0
  )
  expect_equal(signif_half_up(x = -2.5, digits = 1), -3)
  expect_equal(
    signif_half_up(x = 123.45, digits = 4),
    123.5
  )
  expect_equal(signif_half_up(x = -123.45, digits = 4), -123.5)
  # vectors
  expect_equal(
    signif_half_up(
      x = c(12.5, 0, -2.5, 123.45, -123.45),
      digits = 2
    ),
    c(13, 0, -2.5, 120, -120)
  )
})

test_that("signif_half_up works correctly", {
  expect_equal(signif_half_up(0.555, 2), 0.56)
  expect_equal(signif_half_up(0.555, 1), 0.6)
  expect_equal(signif_half_up(12345, 3), 12300)
})

test_that("rounding and recycling", {

  x <- seq(-10, by = 0.05, length = 90)
  dig <- c(0, 1, 2)

  # No digits

  expect_equal(
    round_half_up(x, digits = NULL),
    x
  )
  expect_equal(
    signif_half_up(x, digits = NULL),
    x
  )

  # Inf digits
  expect_equal(
    round_half_up(x, digits = Inf),
    x
  )
  expect_equal(
    signif_half_up(x, digits = Inf),
    x
  )

  expect_equal(
    round_half_up(x, digits = c(Inf, 5, Inf)),
    x
  )
  expect_equal(
    signif_half_up(x, digits = c(Inf, 5, Inf)),
    x
  )

  # 0-length inputs
  expect_equal(
    round_half_up(numeric(), digits = numeric()),
    numeric()
  )
  expect_equal(
    signif_half_up(numeric(), digits = numeric()),
    numeric()
  )

  expect_equal(
    round_half_up(x, digits = numeric()),
    numeric()
  )

  expect_equal(
    signif_half_up(x, digits = numeric()),
    numeric()
  )

  expect_equal(
    round_half_up(numeric(), digits = 2),
    numeric()
  )

  expect_equal(
    signif_half_up(numeric(), digits = 2),
    numeric()
  )


  # Recycling of digits

  expect_equal(
    round_half_up(x, digits = dig),
    round_half_up(x, digits = rep_len(dig, 30))
  )
  expect_equal(
    signif_half_up(x, digits = dig),
    signif_half_up(x, digits = rep_len(dig, 30))
  )

  # Recycling of x

  x <- seq(-10, by = 0.05, length = 7)
  dig <- (sample.int(3, 70, TRUE) - 1)

  expect_equal(
    round_half_up(rep_len(x, 70), digits = dig),
    round_half_up(x, digits = dig)
  )
  expect_equal(
    signif_half_up(x, digits = dig),
    signif_half_up(rep_len(x, 70), digits = dig)
  )


  expect_equal(
    as_percent(0.1234567),
    structure(0.1234567, class = "percent", .digits = 2)
  )

  expect_equal(format(as_percent(0.045), digits = 0), "5%")
  expect_equal(round(as_percent(0.045)), as_percent(0.05))

})

test_that("as.character.percent works correctly", {
  p <- as_percent(0.1234)
  expect_equal(as.character(p), "12.34%")
  expect_equal(as.character(p, digits = 1), "12.3%")
})

test_that("format.percent works correctly", {
  p <- as_percent(0.1234)
  expect_equal(format(p), "12.34%")
  expect_equal(format(p, digits = 1), "12.3%")
  expect_equal(format(p, symbol = " (%)"), "12.34 (%)")
})

test_that("print.percent works correctly", {
  expect_output(print(as_percent(0.1234)), "12.34%")
  expect_output(print(as_percent(0.567890)), "56.79%")
  expect_output(print(as_percent(numeric())), "A <percent> vector of length 0")
})

test_that("subsetting percent objects works correctly", {
  p <- as_percent(c(0.1, 0.2, 0.3))
  expect_s3_class(p[1:2], "percent")
  expect_equal(p[1:2], as_percent(c(0.1, 0.2)))
})

test_that("unique.percent works correctly", {
  p <- as_percent(c(0.1, 0.2, 0.1, 0.3))
  expect_s3_class(unique(p), "percent")
  expect_equal(unique(p), as_percent(c(0.1, 0.2, 0.3)))
})

test_that("rep.percent works correctly", {
  p <- as_percent(0.1)
  expect_s3_class(rep(p, 3), "percent")
  expect_equal(rep(p, 3), as_percent(c(0.1, 0.1, 0.1)))
})

test_that("Math.percent works correctly", {
  p <- as_percent(c(0.1234, 0.5678))
  expect_equal(floor(p), as_percent(c(0.12, 0.56)))
  expect_equal(ceiling(p), as_percent(c(0.13, 0.57)))
  expect_equal(trunc(p), as_percent(c(0.12, 0.56)))
  expect_equal(round(p), as_percent(c(0.12, 0.57)))
  expect_equal(signif(p, 2), as_percent(c(0.12, 0.57)))
})

test_that("Summary.percent works correctly", {
  p <- as_percent(c(0.1, 0.2, 0.3))
  expect_s3_class(sum(p), "percent")
  expect_equal(sum(p), as_percent(0.6))
  expect_equal(prod(p), as_percent(0.006))
  expect_equal(min(p), as_percent(0.1))
  expect_equal(max(p), as_percent(0.3))
  expect_equal(range(p), as_percent(c(0.1, 0.3)))
})

test_that("mean.percent works correctly", {
  p <- as_percent(c(0.1, 0.2, 0.3))
  expect_s3_class(mean(p), "percent")
  expect_equal(mean(p), as_percent(0.2))
})
